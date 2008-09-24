package Math::Farnsworth::Units;

use strict;
use warnings;

use Data::Dumper;
use Math::Farnsworth::Value;

sub new
{
	#i should make a constructor that copies, but that'll come later
	my $self = {};
	bless $self;
}

sub addunit
{
	my $self = shift;
	my $name = shift;
	my $value = shift;
	$self->{units}{$name} = $value;
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
		print Dumper($preval, $realname);
		$return = $preval * $self->{units}{$realname};
	}

	print "GETTING UNIT: $name : $return : ".Dumper($return);
	return $return;
}

sub hasprefix
{
	my $self = shift;
	my $name = shift;

	#sort them by length, solves issues with longer ones not being found first
	my @keys = keys %{$self->{prefix}};
	for my $pre (sort {length($a) <=> length($b)} @keys)
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
	for my $pre (sort {length($a) <=> length($b)} keys %{$self->{prefix}})
	{
		if ($name =~ /^\Q$pre\E(.*)$/)
		{
			my $u = $1;
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

#is this useful?
sub getdimen
{
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
}

sub setprefix
{
	my $self = shift;
	my $name = shift;
	my $value = shift;

	$self->{prefix}{$name} = $value;
}

1;
