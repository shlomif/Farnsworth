package Math::Farnsworth::Functions::StdMath;

use strict;
use warnings;

use Math::Pari;
use Data::Dumper;

sub init
{
   my $env = shift;

   my $array = new Math::Farnsworth::Value([], {array => 1});
   my $string = new Math::Farnsworth::Value("", {string => 1});
   my $lambda = new Math::Farnsworth::Value("", {lambda => 1});
   my $number = new Math::Farnsworth::Value(0);

   $env->{funcs}->addfunc("ln",  [["in", undef, $number]],\&log);
   $env->{funcs}->addfunc("sin", [["in", undef, $number]],\&sin);
   $env->{funcs}->addfunc("cos", [["in", undef, $number]],\&cos);
   $env->{funcs}->addfunc("tan", [["in", undef, $number]],\&tan);
   $env->eval("csc{x isa 1} := {1/sin[x]}"); 
   $env->eval("sec{x isa 1} := {1/cos[x]}"); 
   $env->eval("cot{x isa 1} := {1/tan[x]}"); 
   $env->eval("log{x isa 1} := {ln[x]/ln[10]}"); 
   $env->eval("atan2{x isa 1,y isa 1} := {var s=x^2+y^2; var r=y+x i; -i * ln[r / sqrt[s]]}");
   $env->{funcs}->addfunc("sinh", [["in", undef, $number]],\&sinh);
   $env->{funcs}->addfunc("cosh", [["in", undef, $number]],\&cosh);
   $env->{funcs}->addfunc("tanh", [["in", undef, $number]],\&tanh);
   $env->{funcs}->addfunc("arcsin", [["in", undef, $number]],\&arcsin);
   $env->{funcs}->addfunc("arccos", [["in", undef, $number]],\&arccos);
   $env->{funcs}->addfunc("arctan", [["in", undef, $number]],\&arctan);
   $env->{funcs}->addfunc("arcsinh", [["in", undef, $number]],\&arcsinh);
   $env->{funcs}->addfunc("arccosh", [["in", undef, $number]],\&arccosh);
   $env->{funcs}->addfunc("arctanh", [["in", undef, $number]],\&arctanh);
   $env->{funcs}->addfunc("asin", [["in", undef, $number]],\&arcsin);
   $env->{funcs}->addfunc("acos", [["in", undef, $number]],\&arccos);
   $env->{funcs}->addfunc("atan", [["in", undef, $number]],\&arctan);
   $env->{funcs}->addfunc("asinh", [["in", undef, $number]],\&arcsinh);
   $env->{funcs}->addfunc("acosh", [["in", undef, $number]],\&arccosh);
   $env->{funcs}->addfunc("atanh", [["in", undef, $number]],\&arctanh);
   $env->{funcs}->addfunc("abs", [["in", undef, undef]],\&abs);
   $env->{funcs}->addfunc("floor", [["in", undef, undef]],\&floor);
   $env->{funcs}->addfunc("ceil", [["in", undef, undef]],\&ceil);
   $env->{funcs}->addfunc("int", [["in", undef, undef]],\&int);
   $env->{funcs}->addfunc("rint", [["in", undef, undef]],\&rint);
   $env->eval("round{x, d isa 1} := {var m = x * 10 ** d; rint[m] * 10 ** -d+0.0};");
   $env->{funcs}->addfunc("trunc", [["in", undef, undef]],\&int);
   $env->{funcs}->addfunc("numerator", [["in", undef, $number]],\&numerator);
   $env->{funcs}->addfunc("denominator", [["in", undef, $number]],\&denominator);
   
   $env->{funcs}->addfunc("real", [["in", undef, $number]],\&real);
   $env->{funcs}->addfunc("imag", [["in", undef, $number]],\&imag);
   $env->eval("imaginary{x isa 1} := imag[x]");
   $env->{funcs}->addfunc("conj", [["in", undef, $number]],\&conj);
   $env->{funcs}->addfunc("norm", [["in", undef, $number]],\&norm);
   
   $env->{funcs}->addfunc("isprime", [["in", undef, $number]],\&isprime);
   $env->{funcs}->addfunc("prime", [["in", undef, $number]],\&prime);
	$env->{funcs}->addfunc("precprime", [["in", undef, $number]],\&precprime);
	$env->{funcs}->addfunc("nextprime", [["in", undef, $number]],\&nextprime);
	$env->{funcs}->addfunc("factor", [["in", undef, $number]],\&factor);
   
   $env->{funcs}->addfunc("randmax", [["in", undef, $number]],\&randmax);
   $env->{funcs}->addfunc("getrseed", [[]],\&getrseed);
   $env->{funcs}->addfunc("setrseed", [[]],\&setrseed);
   $env->eval("random{} := randmax[10**30]/10.0**30");

   $env->{funcs}->addfunc("gcd", [["left", undef, $number],["right", undef, $number]],\&gcd);
   $env->{funcs}->addfunc("lcm", [["left", undef, $number],["right", undef, $number]],\&lcm);

   $env->eval('max{x isa ...} := {if (length[x] == 1 && x@0$ conforms []) {x = x@0$}; var z=[x]; var m = pop[z]; var n = length[z]; var q; while((n=n-1)>=0){q=pop[z]; q>m?m=q:0}; m}'); 
   $env->eval('min{x isa ...} := {if (length[x] == 1 && x@0$ conforms []) {x = x@0$}; var z=[x]; var m = pop[z]; var n = length[z]; var q; while((n=n-1)>=0){q=pop[z]; q<m?m=q:0}; m}'); 
   #$env->{funcs}->addfunc("min", [],\&min);
   #$env->{funcs}->addfunc("max", [],\&max);
   #these functions are simple enough to implement in farnsworth itself, so why not
   $env->{funcs}->addfunc("sqrt", [["in", undef, undef]],\&sqrt); #putting in like this to see if it brings better luck
   $env->eval("i := sqrt[-1]"); #since we have a better sqrt, use it to make a better i
#   $env->eval("sqrt{x} := {x ^ 0.5}"); 
   $env->eval("exp{x isa 1} := {e ^ x}");
   $env->eval("inv{x} := {1/x}"); 
   $env->eval("recip{x} := {1/x}"); 

   $env->eval("_tohex{x isa 1} := { if(x < 16) { substrLen[\"0123456789abcdef\", x, 1] } else { _tohex[floor[x/16]] + _tohex[x%16] } }; tohex{x isa 1} := {\"0x\"+_tohex[x]}");

}

sub sqrt
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in sin yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The sin of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#HAD BUG HERE, sqrt used to not carry units
			my $units = $arg->{dimen};
			$units = $units->mult(PARI '1/2'); #half them all!
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::sqrt($arg->{pari}), $units);
			print Dumper(\@rets);
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

sub sin
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in sin yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The sin of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::sin($arg->{pari}), {});
			print Dumper(\@rets);
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

sub cos
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in cos yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The cos of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::cos($arg->{pari}), {});
			print Dumper(\@rets);
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

sub tan
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::tan($arg->{pari}), {});
			print Dumper(\@rets);
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

sub arcsin
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in sin yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The sin of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::asin($arg->{pari}), {angle=>1});
			print Dumper(\@rets);
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

sub arccos
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in cos yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The cos of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::acos($arg->{pari}), {angle => 1});
			print Dumper(\@rets);
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

sub arctan
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::atan($arg->{pari}), {angle => 1});
			print Dumper(\@rets);
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

sub sinh
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in sin yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The sin of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::sinh($arg->{pari}), {});
			print Dumper(\@rets);
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

sub cosh
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in cos yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The cos of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::cosh($arg->{pari}), {});
			print Dumper(\@rets);
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

sub tanh
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::tanh($arg->{pari}), {});
			print Dumper(\@rets);
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

sub arcsinh
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in sin yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The sin of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::asinh($arg->{pari}), {angle=>1});
			print Dumper(\@rets);
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

sub arccosh
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in cos yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The cos of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::acosh($arg->{pari}), {angle => 1});
			print Dumper(\@rets);
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

sub arctanh
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::atanh($arg->{pari}), {angle => 1});
			print Dumper(\@rets);
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





sub abs
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in abs yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The abs of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::abs($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub floor
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this

			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::floor($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub ceil
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this

			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::ceil($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub int
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in int yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The int of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			my $error = PARI '0';
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::truncate($arg->{pari}, $error), $arg->{dimen});
			print Dumper(\@rets);
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

sub numerator
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::numerator($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub denomenator
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::denomenator($arg->{pari}), $arg->{dimen});
			print Dumper(\@rets);
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

sub real
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return  Math::Farnsworth::Value->new(Math::Pari::real($input->{pari}), $input->{dimen});
}

sub imag
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return  Math::Farnsworth::Value->new(Math::Pari::imag($input->{pari}), $input->{dimen});
}

sub conj
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return  Math::Farnsworth::Value->new(Math::Pari::conj($input->{pari}), $input->{dimen});
}

sub norm
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return  Math::Farnsworth::Value->new(Math::Pari::norm($input->{pari}), $input->{dimen});
}

sub isprime
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::isprime($input->{pari}), {bool => 1});
}

sub prime
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::prime($input->{pari}));
}

sub nextprime
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::nextprime($input->{pari}));
}

sub precprime
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::precprime($input->{pari}));
}

sub factor
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::factor($input->{pari}));
}

sub randmax
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::random($input->{pari}));
}

sub setrseed 
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too
	
	my $oldseed = Math::Pari::getrand();
	Math::Pari::setrand($input->{pari});

	return Math::Farnsworth::Value->new($oldseed);
}

sub getrseed 
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	return Math::Farnsworth::Value->new(Math::Pari::getrand());
}

sub rint
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $input = $eval->{vars}->getvar("in"); #i should clean this up more too

	#die "Argument to rint[] is not a numeric value" unless $input->isPARI();
	my $e = PARI '0';
	return  Math::Farnsworth::Value->new(Math::Pari::round($input->{pari}, $e), $input->{dimen});
}

sub gcd
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $left = $eval->{vars}->getvar("left"); #i should clean this up more too
	my $right = $eval->{vars}->getvar("right"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::gcd($left->{pari}, $right->{pari}));
}

sub lcm
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;

	my $left = $eval->{vars}->getvar("left"); #i should clean this up more too
	my $right = $eval->{vars}->getvar("right"); #i should clean this up more too
	
	return Math::Farnsworth::Value->new(Math::Pari::lcm($left->{pari}, $right->{pari}));
}

sub log
{
	#with an array we give the number of elements, with a string we give the length of the string
	my ($args, $eval, $branches)= @_;
	my @argsarry = @{$args->{pari}};

	my @rets;

	for my $arg (@argsarry)
	{
		if ($arg->{dimen}{dimen}{array})
		{
			die "I don't know what to do with an array in tan yet!\n";
		}
		elsif ($arg->{dimen}{dimen}{string})
		{
			die "The tan of a string is the md5sum of the reverse of the idiot who wanted it";
		}
		else
		{
			#until i decide how this should work on regular numbers, just do this
			CORE::push @rets, Math::Farnsworth::Value->new(Math::Pari::log($arg->{pari}), {});
			print Dumper(\@rets);
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

1;
