package Math::Farnsworth::Units;

use strict;
use warnings;

use Data::Dumper;
use Math::Farnsworth::Value;
use Math::Pari;
use Date::Manip;

sub new
{
	#i should make a constructor that copies, but that'll come later
	my $self = {units=>{1=>1}, dimens=>{bool=>"Boolean", string=>"String"}}; #hack to make things work right
	bless $self;
}

sub addunit
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	$self->{units}{$name} = $value;
	$self->{units}{$name."s"} = $value; #HACK!
}

sub getunit
{
	my $self = shift;
	my $name = shift;

	my $return;

	if ($self->_isunit($name))
	{
		$return = $self->{units}{$name};
	}
	elsif ($self->hasprefix($name))
	{
		my ($preval, undef, $realname) = $self->getprefix($name);
#		print "GETTING PREFIXES: $name :: $preval :: $realname ::".Dumper($preval, $realname) if (($name eq "mg") || ($name eq "l") || $name eq "milli");
		$return = $preval * $self->{units}{$realname};
	}

#	print "GETTING UNIT: $name : $return : ".Dumper($return) if (($name eq "mg") || ($name eq "l") || $name eq "milli");
	return $return;
}

sub hasprefix
{
	my $self = shift;
	my $name = shift;

	#sort them by length, solves issues with longer ones not being found first
	my @keys = keys %{$self->{prefix}};
	for my $pre (sort {length($b) <=> length($a)} @keys)
	{
		if ($name =~ /^\Q$pre\E(.*)$/)
		{
			return 1 if ($self->_isunit($1) || !length($1));
		}
	}
	return 0; #no prefix!
}

sub getprefix
{
	my $self = shift;
	my $name = shift;

	#sort them by length, solves issues with longer ones not being found first
	for my $pre (sort {length($b) <=> length($a)} keys %{$self->{prefix}})
	{
		#print "CHECKING PREFIX: $pre\n" if ($name eq "mg");
		if ($name =~ /^\Q$pre\E(.*)$/)
		{
			my $u = $1;
			#print "FOUND: $name == $pre * $u\n";
			#print Dumper($self->{prefix}{$pre}) if ($name eq "mg");
			$u = 1 unless length($1); #to make certain things work right
			return ($self->{prefix}{$pre},$pre,$u) if ($self->_isunit($1) || !length($1));
		}
	}
	return undef; #to cause errors when not there
}

sub isunit
{
	my $self = shift;
	my $name = shift;

	return $self->hasprefix($name) || $self->_isunit($name); 
}

sub _isunit
{
	my $self = shift;
	my $name = shift;
	return exists($self->{units}{$name});
}

sub adddimen
{
	my $self = shift;
	my $name = shift;
	my $default = shift; #primitive unit for the dimension, all other units are defined against this
	$self->{dimens}{$name} = $default;
	my $val = new Math::Farnsworth::Value(1, {$name => 1}); #i think this is right
	$self->addunit($default, $val);
}

#is this useful? yes, need it for display
sub getdimen
{
	my $self = shift;
	my $name = shift;

	return $self->{dimens}{$name};
}

#these primarily are used for display purposes
sub addcombo
{
	my $self = shift;
	my $name = shift;
	my $value = shift; #this is a valueless list of dimensions
	$self->{combos}{$name} = $value;
}

#this returns the name of the combo that matches the current dimensions of a Math::Farnsworth::Value
sub findcombo
{
	my $self = shift;
	my $value = shift;

	for my $combo (keys %{$self->{combos}})
	{
		my $cv = $self->{combos}{$combo}; #grab the value
		return $combo if ($value->{dimen}->compare($cv->{dimen}));
	}

	return undef; #none found
}

#this sets a display for a combo first, then for a dimension
sub setdisplay
{
	my $self = shift; #i'll implement this later
}

#this takes a set of dimensions and returns what to display
sub getdisplay
{
	my $self = shift; #i'll implement this later too
	my $dimen = shift; #i take a Math::Farnsworth::Dimension object!
    my $value = shift; #the value so we can stringify it

    my @returns;

	if (defined($value->{outmagic}))
	{
		if (exists($value->{outmagic}[1]{dimen}{dimen}{string}))
		{
			#ok we were given a string!
			my $number = $value->{outmagic}[0];
			my $string = $value->{outmagic}[1];
			return $self->getdisplay($number->{dimen}, $number) . " ".$string->{pari};
		}
		elsif (exists($value->{outmagic}[0]) && (!exists($value->{outmagic}[0]{dimen}{dimen}{array})))
		{
			#ok we were given a value without the string
			my $number = $value->{outmagic}[0];
			return $self->getdisplay($number->{dimen}, $number);
		}
		else
		{
			die "Unhandled output magic, this IS A BUG!";
		}
	}
	elsif (exists($dimen->{dimen}{"bool"}))
	{
		return $value ? "True" : "False"
		#these should do something!
	}
	elsif (exists($dimen->{dimen}{"string"}))
	{
		my $val = $value->{pari};
		$val =~ s/\\/\\\\/g;
		$val =~ s/"/\\"/g;
		return '"'.$val.'"';
	}
	elsif (exists($dimen->{dimen}{"array"}))
	{
		my @array; #this will be used to build the output
		for my $v (@{$value->{pari}})
		{
			push @array, $v->toperl($self);
		}

		return '['.(join ' , ', @array).']';
	}
	elsif (exists($dimen->{dimen}{"date"}))
	{
		return UnixDate($value->{pari}, "%O"); #output in ISO format for now
	}
	elsif (exists($dimen->{dimen}{"lambda"}))
	{
		return "No magic for lambdas yet, functions shall get this too";
	}
	else
	{
		for my $d (keys %{$dimen->{dimen}})
		{
			my $exp = "";
			print Dumper($dimen->{dimen}, $exp);
			$exp = "^".($dimen->{dimen}{$d} =~ /^[\d\.]+$/? $dimen->{dimen}{$d} :"(".$dimen->{dimen}{$d}.")") unless ($dimen->{dimen}{$d} == 1);
			print Dumper($exp);
			push @returns, $self->getdimen($d).$exp;
		}
		my $prec = Math::Pari::setprecision();
		Math::Pari::setprecision(30); #set it to 15?
		my $pv = "".(Math::Pari::pari_print($value->{pari}));
		Math::Pari::setprecision($prec); #restore it before calcs
		return $pv." ".join " ", @returns;
	}
}

sub setprefix
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	print "SETTING PREFIX: $name : $value\n" if ($name eq "m");
	$self->{prefix}{$name} = $value;
}

1;
