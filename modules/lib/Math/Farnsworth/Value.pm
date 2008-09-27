#!/usr/bin/perl

package Math::Farnsworth::Value;

use strict;
use warnings;

use Data::Dumper;

use Math::Pari;
use Math::Farnsworth::Dimension;
use utf8;

our $VERSION = 0.5;

use overload 
    '+' => \&add,
    '-' => \&subtract,
    '*' => \&mult,
    '/' => \&div,
	'%' => \&mod,
	'**' => \&pow,
	'<=>' => \&compare,
	'bool' => \&bool,
	'""' => \&toperl;

sub new
{
  my $class = shift;
  my $value = shift;
  my $dimen = shift; #should only really be used internally?
  my $outmagic = shift; #i'm still not sure on this one

  my $self = {};

  bless $self, $class;

  $self->{outmagic} = $outmagic;

  if (ref($dimen) eq "Math::Farnsworth::Dimension")
  {
    $self->{dimen} = $dimen;
  }
  else
  {
	  $dimen = {} if !defined($dimen);
	  $self->{dimen} = new Math::Farnsworth::Dimension($dimen);
  }

  print "Setting VAR: ".Dumper($value);

  if (exists($self->{dimen}{dimen}{string}))
  {
	#here it comes in with quotes, so lets remove them
	$value =~ s/^"(.*)"$/$1/;
	$value =~ s/\\"/"/g;
	$value =~ s/\\\\/\\/g;
	$self->{pari} = $value;
  }
  elsif (exists($self->{dimen}{dimen}{array}))
  {
	#we've got an array here
	$self->{pari} = $value;
  }
  else
  {
	$value =~ s/ee/e/i; #fixes double ee's
	$self->{pari} = PARI $value;
  }


  return $self;
}

sub toperl
{
  my $self = shift;
  my $units = shift;

  print "To PERL\n";
  #print Dumper($self, $units);

  if (ref($units) eq "Math::Farnsworth::Units")
  {
	  return $units->getdisplay($self->{dimen}, $self);
  }

  return "".($self->{pari}); #stringifiying it seems to work
}

sub add
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in addition" unless $one->{dimen}->compare($two->{dimen}); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to

  my $new;
  if ($one->{dimen}{dimen}{string})
  {
	print Dumper($one, $two);
  	$new = new Math::Farnsworth::Value($one->{pari} . $tv, $one->{dimen});
  }
  else
  {
	$new = new Math::Farnsworth::Value($one->{pari} + $tv, $one->{dimen});
  }

  return $new;
}

sub subtract
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in subtraction" unless $one->{dimen}->compare($two->{dimen}); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} - $tv, $one->{dimen}); #if !$rev they are in order
  }
  else
  {
      $new = new Math::Farnsworth::Value($tv - $one->{pari}, $one->{dimen}); #if !$rev they are in order
  }
  return $new;
}

sub mod
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in modulous" unless $one->{dimen}->compare($two->{dimen}); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} % $tv, $one->{dimen}); #if !$rev they are in order
  }
  else
  {
      $new = new Math::Farnsworth::Value($tv % $one->{pari}, $one->{dimen}); #if !$rev they are in order
  }
  return $new;
}

sub mult
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : {};
  
  my $nd = $one->{dimen}->merge($td); #merge the dimensions! don't cross the streams though

  #moving this down so that i don't do any math i don't have to
  my $new = new Math::Farnsworth::Value($one->{pari} * $tv, $nd);
  return $new;
}

sub div
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  my $td = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{dimen} : {};

  #these are a little screwy SO i'll probably comment them more later
  #probably after i find out that they're wrong
  my $qd = $rev ? $td : $one->{dimen};
  my $dd = $rev ? $one->{dimen}->invert() : (ref($td) eq "HASH" ? $td : $td->invert());

  my $nd;
  
  if (ref($qd) ne "HASH")
  {
	  $nd = $qd->merge($dd); #merge the dimensions! don't cross the streams though
  }
  else
  {
	  $nd = $dd->merge($qd); #merge them the other way, because $qd is a "HASH" and not an object
  }

  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} / $tv, $nd); #if !$rev they are in order
  }
  else
  {
      $new = new Math::Farnsworth::Value($tv / $one->{pari}, $nd); #if !$rev they are in order
  }

  return $new;
}

sub bool
{
	my $self = shift;

	#seems good enough of an idea to me
	return $self->{pari}?Math::Farnsworth::Value->new(0, {bool => 1}):Math::Farnsworth::Value->new(1, {bool => 1});
}

sub pow
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;
  
  #moving this down so that i don't do any math i don't have to
  my $new;
  if (!$rev)
  {
	  $new = new Math::Farnsworth::Value($one->{pari} ** $tv, $one->{dimen}->mult($tv)); #if !$rev they are in order
  }
  else
  {
#	  print Dumper(\@_);
	  print "POW: $tv :: $two :: $one\n";
      $new = new Math::Farnsworth::Value($tv ** $one->{pari}, $one->{dimen}->mult($tv)); #if !$rev they are in order
  }

  return $new;
}

sub compare
{
  my ($one, $two, $rev) = @_;

  #check for $two being a simple value
  my $tv = ref($two) && $two->isa("Math::Farnsworth::Value") ? $two->{pari} : $two;

  #i also need to check the units, but that will come later
  #NOTE TO SELF this needs to be more helpful, i'll probably do something by adding stuff in ->new to be able to fetch more about the processing 
  die "Unable to process different units in compare" unless $one->{dimen}->compare($two->{dimen}); #always call this on one, since $two COULD be some other object 

  #moving this down so that i don't do any math i don't have to
  my $new;
  
  if ($one->{pari} == $tv)
  {
	  $new = Math::Farnsworth::Value->new(0);
  }
  elsif ($one->{pari} < $tv)
  {
	  $new = Math::Farnsworth::Value->new(-1);
  }
  elsif ($one->{pari} > $tv)
  {
	  $new = Math::Farnsworth::Value->new(1);
  }

  return $new;
}

