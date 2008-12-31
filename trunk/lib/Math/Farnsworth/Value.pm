#new value class!
package Math::Farnsworth::Value;

use strict;
use warnings;

use Carp;
use Data::Dumper;

use base qw/Exporter/;

our @EXPORT_OK = qw(TYPE_PLAIN TYPE_TIME);

####
#THESE FUNCTIONS WILL BE MOVED TO Math::Farnsworth::Value, or somewhere more appropriate

sub istype
{
	my $self = shift;
	my $allow = shift; #type to allow!

	if ($allow eq "Array")
	{
		return 1;
	}
	elsif ($allow eq "Boolean")
	{
		return 1;
	}
	elsif ($allow eq "String")
	{
		return 1;
	}
	elsif ($allow eq "Date")
	{
		return 1;
	}
	elsif ($allow eq "Lambda")
	{
		return 1;
	}
	elsif ($allow eq "Undef")
	{
		return 1;
	}
	
	return 0;
}

sub ismediumtype
{
	my $self = shift;
	my $allow = shift; #type to allow!
	
	if ($self->isa("Math::Farnsworth::Value::Array") && $allow ne "Array")
	{
		return 1;
	}
	elsif ($self->isa("Math::Farnsworth::Value::Boolean") && $allow ne "Boolean")
	{
		return 1;
	}
	elsif ($self->isa("Math::Farnsworth::Value::String") && $allow ne "String")
	{
		return 1;
	}
	elsif ($self->isa("Math::Farnsworth::Value::Date") && $allow ne "Date")
	{
		return 1;
	}
	elsif ($self->isa("Math::Farnsworth::Value::Lambda") && $allow ne "Lambda")
	{
		return 1;
	}
	elsif ($self->isa("Math::Farnsworth::Value::Undef") && $allow ne "Undef")
	{
		return 1;
	}
	
	return 0;
}

#these values will also probably be put into a "memoized" setup so that they don't get recreated all the fucking time
sub TYPE_BOOLEAN
{
	new Math::Farnsworth::Value::Boolean(0);
}

sub TYPE_STRING
{
	new Math::Farnsworth::Value::String("");
}

sub TYPE_DATE
{
	new Math::Farnsworth::Value::Date();
}

sub TYPE_PLAIN #this tells it that it is the same as a constraint of "1", e.g. no units
{
	new Math::Farnsworth::Value::Pari(0);
}

sub TYPE_TIME #this tells it that it is the same as a constraint of "1", e.g. no units
{
	new Math::Farnsworth::Value::Pari(0, {time=> 1});
}

sub TYPE_LAMBDA
{
	new Math::Farnsworth::Value::Lambda();
}

sub TYPE_UNDEF
{
	new Math::Farnsworth::Value::Undef();
}

sub TYPE_ARRAY
{
	new Math::Farnsworth::Value::Array();
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
		if (ref($self) eq "Math::Farnsworth::Value::Pari")
		{
			my $ret = $self->getdimen()->compare($comparator->getdimen());
			return $ret;
		}
		else
		{
			return 1; #for now?
		}
	}
}

1;
