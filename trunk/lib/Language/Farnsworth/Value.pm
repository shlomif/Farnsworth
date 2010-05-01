#new value class!
package Language::Farnsworth::Value;

use strict;
use warnings;

use Carp;
use Data::Dumper;

use base qw/Exporter/;

use Language::Farnsworth::Value::Boolean;
use Language::Farnsworth::Value::Array;
use Language::Farnsworth::Value::String;
use Language::Farnsworth::Value::Date;
use Language::Farnsworth::Value::Pari;
use Language::Farnsworth::Value::Lambda;
use Language::Farnsworth::Value::Undef;

use Scalar::Util qw/weaken/; 

our @EXPORT = qw(TYPE_BOOLEAN TYPE_STRING TYPE_DATE TYPE_PLAIN TYPE_TIME TYPE_LAMBDA TYPE_UNDEF TYPE_ARRAY VALUE_ONE);

####
#THESE FUNCTIONS WILL BE MOVED TO Language::Farnsworth::Value, or somewhere more appropriate

sub setref
{
	my $self = shift;
	my $ref = shift;
	$self->{_ref} = $ref;
}

sub sethomescope
{
	my $self = shift;
	my $scope = shift; #Farnsworth::Variables type
	
	unless ($self->{_homescope})
	{
		$self->{_homescope} = $scope;
		weaken $self->{_homescope};
	}
}

sub gethomescope
{
	return $_[0]->{_homescope};
}

sub getref
{
	my $self = shift;
	return $self->{_ref};
}

sub istype
{
	my $self = shift;
	my $allow = shift; #type to allow!

	return ref($self) =~ /\Q$allow/i;
}

sub ismediumtype
{
	my $self = shift;
	my $allow = shift; #type to allow!
	$allow ||= "";
	
	if ($self->isa("Language::Farnsworth::Value::Array") && $allow ne "Array")
	{
		return 1;
	}
	elsif ($self->isa("Language::Farnsworth::Value::Boolean") && $allow ne "Boolean")
	{
		return 1;
	}
	elsif ($self->isa("Language::Farnsworth::Value::String") && $allow ne "String")
	{
		return 1;
	}
	elsif ($self->isa("Language::Farnsworth::Value::Date") && $allow ne "Date")
	{
		return 1;
	}
# promoting Lambda to a High type, so that it can capture the multiplication with other types
#	elsif ($self->isa("Language::Farnsworth::Value::Lambda") && $allow ne "Lambda")
#	{
#		return 1;
#	}
	elsif ($self->isa("Language::Farnsworth::Value::Undef") && $allow ne "Undef")
	{
		return 1;
	}
	
	return 0;
}

#these values will also probably be put into a "memoized" setup so that they don't get recreated all the fucking time

{
	my $boolean;
	my $string;
	my $date;
	my $plain;
	my $time;
	my $lambda;
	my $undef;
	my $array;
	my $valueone;

	sub TYPE_BOOLEAN{return $boolean if $boolean; $boolean=new Language::Farnsworth::Value::Boolean(0)}
	sub TYPE_STRING	{return $string if $string; $string=new Language::Farnsworth::Value::String("")}
	sub TYPE_DATE	{return $date if $date; $date=new Language::Farnsworth::Value::Date("today")}
	#this tells it that it is the same as a constraint of "1", e.g. no units
	sub TYPE_PLAIN 	{return $plain if $plain; $plain=new Language::Farnsworth::Value::Pari(0)}
	sub VALUE_ONE   {return $valueone if $valueone; $valueone=new Language::Farnsworth::Value::Pari(1,{},undef,undef,1)}
	#this tells it that it is the same as a constraint of "1 s", e.g. seconds
	sub TYPE_TIME	{return $time if $time; $time=new Language::Farnsworth::Value::Pari(0, {time=>1})}
	sub TYPE_LAMBDA	{return $lambda if $lambda; $lambda=new Language::Farnsworth::Value::Lambda()}
	sub TYPE_UNDEF  {return $undef if $undef; $undef=new Language::Farnsworth::Value::Undef()}
	sub TYPE_ARRAY	{return $array if $array; $array=new Language::Farnsworth::Value::Array([])}
}

sub conforms
{
	my $self = shift;
	my $comparator = shift;

	if (ref($self) ne ref($comparator))
	{
		return 0;
	}
	else
	{
		if (ref($self) eq "Language::Farnsworth::Value::Pari")
		{
			my $ret = $self->getdimen()->compare($comparator->getdimen());
			return 1 if ($comparator->isvalueone()); #read the sentinal value
			return $ret;
		}
		else
		{
			return 1; #for now?
		}
	}
}

sub clone
{
	my $self = shift;
	my $class = ref($self);

	my $newself = {};
	$newself->{$_} = $self->{$_} for (grep /^_/, keys %$self);

	bless $newself, $class;

	$newself;
}

sub getpari
{
	#error("Attempting to use ");
}

sub getarray
{
}

sub getarrayref
{
}

sub getstring
{
}

1;
