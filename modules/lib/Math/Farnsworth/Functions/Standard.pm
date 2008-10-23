package Math::Farnsworth::Functions::Standard;

use strict;
use warnings;

use Math::Farnsworth::Value;
use utf8;

use Data::Dumper;

use Math::Pari;

sub init
{
   my $env = shift;

   #i should really make some stuff to make this easier
   #maybe some subs in Math::Farnsworth::Value that get exported
   my $array = new Math::Farnsworth::Value([], {array => 1});
   my $string = new Math::Farnsworth::Value("", {string => 1});
   my $lambda = new Math::Farnsworth::Value("", {lambda => 1});
   my $number = new Math::Farnsworth::Value(0);

   $env->{funcs}->addfunc("push", [["arr", undef, $array], ["in", undef, "VarArg"]],\&push); #actually i might rewrite this in farnsworth now that it can do it
   $env->{funcs}->addfunc("pop", [["arr", undef, $array]],\&pop); #eventually this maybe too
   $env->{funcs}->addfunc("sort", [["sortsub", undef, $lambda],["arr", undef, $array]],\&sort);

   $env->{funcs}->addfunc("length", [["in", undef, undef]],\&length);

   $env->{funcs}->addfunc("ord", [["in", undef, $string]],\&ord);
   $env->{funcs}->addfunc("chr", [["in", undef, $number]],\&chr);
   $env->{funcs}->addfunc("index", [["str", undef, $string],["substr", undef, $string],["pos", $number, $number]],\&index);
   $env->{funcs}->addfunc("eval", [["str", undef, $string]],\&eval);


   $env->{funcs}->addfunc("substrLen", [["str", undef, $string],["left", undef, $number],["length", undef, $number]],\&substrlen); #this one works like perls
   $env->eval("substr{str,left,right}:={substrLen[str,left,right-left]}");
   $env->eval("left{str,pos}:={substrLen[str,0,pos]}");
   $env->eval("right{str,pos}:={substrLen[str,length[str]-pos,pos]}");

   $env->{funcs}->addfunc("reverse", [["in", undef, undef]],\&reverse);

   $env->eval("now{} := {#today#}");

   $env->{funcs}->addfunc("unit", [["in", undef, undef]], \&unit);
}

sub unit
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	print Dumper($branches);

	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{units}->isunit($branches->[1][0][0])))
	{
		die "First argument to unit[] must be a unit name";
	}

	my $unitvar = $eval->{units}->getunit($branches->[1][0][0]);

	return $unitvar; #if its undef, its undef! i should really make some kind of error checking here
}

sub sort
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;

	my $argcount = @{$args->{pari}};

	my $sortlambda;

	if ($args->{pari}->[0]->{dimen}{dimen}{lambda})
	{
		$sortlambda = shift(@{$args->{pari}});
	}
	else
	{
		#i should really do this outside the sub ONCE, but i'm lazy for now
		$sortlambda = $eval->eval("{|a,b| a <=> b}");
	}

	my $sortsub = sub
	{
		my $val = $eval->evalbranch(bless [(bless [$a, $b], 'Array'), $sortlambda], 'LambdaCall');
		
		0+$val->toperl(); #return this, just to make sure the value is right
	};

	my @sorts;

	if (@{$args->{pari}} > 1)
	{
		#we've been given a bunch of things, assume we need to sort them like that
		push @sorts, @{$args->{pari}};
	}
	elsif ((@{$args->{pari}} == 1) && ($args->{pari}[0]->{dimen}{dimen}{array}))
	{
		#given an array as a second value, dereference it since its the only thing we've got
		push @sorts, @{$args->{pari}[0]{pari}};
	}
	else
	{
		#ok you want me to sort ONE thing? i'll sort that one thing, in O(1) time!
		return $args->{pari}[0];
	}

	my @rets = CORE::sort $sortsub @sorts;

	print "SORT RETURNING!\n";
	print Dumper(\@rets);

	return new Math::Farnsworth::Value([@rets], {array => 1});
}

sub push
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[1][0][0])))
	{
		die "First argument to push must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[1][0][0]);

	if (!exists($arrayvar->{dimen}{dimen}{array}))
	{
		die "First argument to push must be an array";
	}

	#ok type checking is done, do the push!
	
	my @input = @{$args->{pari}};
	shift @input; #remove the original array value

	#i should probably flatten arrays here so that; a=[1,2,3]; push[a,a]; will result in a = [1,2,3,1,2,3]; instead of a = [1,2,3,[1,2,3]];

	CORE::push @{$arrayvar->{pari}}, @input;

	return undef; #push doesn't return anything? probably should, but i'll do that later
}

sub pop
{
	#args is... a Math::Farnsworth::Value array
	my ($args, $eval, $branches)= @_;
	
	if ((ref($branches->[1][0]) ne "Fetch") || (!$eval->{vars}->isvar($branches->[1][0][0])))
	{
		die "Argument to pop must be a variable";
	}

	my $arrayvar = $eval->{vars}->getvar($branches->[1][0][0]);

	if (!exists($arrayvar->{dimen}{dimen}{array}))
	{
		die "Argument to pop must be an array";
	}

	#ok type checking is done, do the pop
	
	my $retval = CORE::pop @{$arrayvar->{pari}};

	return $retval; #pop returns the value of the element removed
}

sub length
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			CORE::push @rets, Math::Farnsworth::Value->new(scalar @{$arg->{pari}}, {});
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			CORE::push @rets, Math::Farnsworth::Value->new(length $arg->{pari}, {});
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(0, {});
		}
	}

	if (@rets > 1)
	{
		return Math::Farnsworth::Value->new(\@rets, {array=>1});
	}
	else
	{
		return $rets[0];
	}
}

sub reverse
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (reverse @argsarry) #this will make reverse[1,2,3,4] return [4,3,2,1]
	{
		if ($arg->{dimen}{dimen}{array})
		{
			CORE::push @rets, Math::Farnsworth::Value->new(reverse @{$arg->{pari}}, {array => 1});
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			CORE::push @rets, Math::Farnsworth::Value->new("".reverse($arg->{pari}), {string=>1});
		}
		else
		{
			CORE::push @rets, $arg; #should i make it print the reverse of all its arguments? yes, lets fix that
		}
	}

	if (@rets > 1)
	{
		return Math::Farnsworth::Value->new(\@rets, {array=>1});
	}
	else
	{
		return $rets[0];
	}
}

sub substrlen
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = @{$args->{pari}};


	if ($arg[0]{dimen}{dimen}{array})
	{
		die "substr and friends only works on strings";
	}
	elsif ($arg[0]{dimen}{dimen}{string})
	{
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		print "SUBSTR :: $ns\n";
		return Math::Farnsworth::Value->new($ns, {string=>1});
	}
	else
	{
		die "substr and friends only works on strings";
	}
}

sub ord
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = @{$args->{pari}};

	if ($arg[0]{dimen}{dimen}{string})
	{
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = ord($arg[0]{pari}); #substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		print "ord :: $ns\n";
		return Math::Farnsworth::Value->new($ns);
	}
	else
	{
		die "ord[] only works on strings";
	}
}

sub chr
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = @{$args->{pari}};

	if ($arg[0]{dimen}->compare({dimen=>{}}))
	{
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = chr($arg[0]{pari}); #substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		print "chr :: $ns\n";
		return Math::Farnsworth::Value->new($ns, {string => 1}); #give string flag of 1, since we don't know what language is intended
	}
	else
	{
		die "chr[] only works on plain numbers";
	}
}

sub index
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = @{$args->{pari}};

	if ($arg[0]{dimen}->compare({dimen=>{string=>1}}) && $arg[1]{dimen}->compare({dimen=>{string => 1}}))
	{
		my $pos = 0;
		if (defined($arg[2]) && $arg[2]{dimen}->compare({dimen=>{}}))
		{
			$pos = $arg[2]->{pari};
		}
		my $string = $arg[0]->{pari};
		my $substr = $arg[1]->{pari};
		#do i need to do something to convert these to work? (the 1,2 anyway?)
		my $ns = index $string, $substr, $pos; #substr($arg[0]{pari}, "".$arg[1]{pari}, "".$arg[2]{pari});
		return Math::Farnsworth::Value->new($ns); #give string flag of 1, since we don't know what language is intended
	}
	else
	{
		die "arguments to index[] are of the incorrect type";
	}
}

sub eval
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @arg = @{$args->{pari}};

	if ($arg[0]{dimen}{dimen}{string})
	{
		my $nvars = new Math::Farnsworth::Variables($eval->{vars});
		my %nopts = (vars => $nvars, funcs => $eval->{funcs}, units => $eval->{units}, parser => $eval->{parser});
	    my $neval = $eval->new(%nopts);

		return $neval->eval($arg[0]{pari});
	}
	else
	{
		die "eval[] only works on strings";
	}
}

1;
