#!/usr/bin/perl

package Math::Farnsworth::Evaluate;

use strict;
use warnings;

use Data::Dumper;
use Carp;

use Math::Farnsworth::FunctionDispatch;
use Math::Farnsworth::Variables;
use Math::Farnsworth::Units;
use Math::Farnsworth::Parser;
use Math::Farnsworth::Value::Pari;
use Math::Farnsworth::Value::Date;
use Math::Farnsworth::Value::String;
use Math::Farnsworth::Value::Undef;
use Math::Farnsworth::Value::Lambda;
use Math::Farnsworth::Value::Array;
use Math::Farnsworth::Value::Boolean;
use Math::Farnsworth::Output;

use Date::Manip;

use Math::Pari ':hex'; #why not?

sub new
{
    my $class = shift;
	my $self = {};
	bless $self;

	my %opts = (@_);

	if (ref($opts{funcs}) eq "Math::Farnsworth::FunctionDispatch")
	{
		$self->{funcs} = $opts{funcs};
	}
	else
	{
		$self->{funcs} = new Math::Farnsworth::FunctionDispatch();
	}

	if (ref($opts{vars}) eq "Math::Farnsworth::Variables")
	{
		$self->{vars} = $opts{vars};
	}
	else
	{
		$self->{vars} = new Math::Farnsworth::Variables();
	}

	if (ref($opts{units}) eq "Math::Farnsworth::Units")
	{
		$self->{units} = $opts{units};
	}
	else
	{
		$self->{units} = new Math::Farnsworth::Units();
	}

	if (ref($opts{parser}) eq "Math::Farnsworth::Parser")
	{
		$self->{parser} = $opts{parser};
	}
	else
	{
		$self->{parser} = new Math::Farnsworth::Parser();
	}

    return $self;
}

sub eval
{
	my $self = shift;
	my $code = shift; #i should probably take an array, so i can use arrays of things, but that'll be later

	$code =~ s/^\s*//;
	$code =~ s/\s*$//;

	my $tree = $self->{parser}->parse($code); #should i catch the exceptions here? dunno

	#print Dumper($tree);

    $self->evalbranch($tree);
}

#evaluate a single branch
sub evalbranch
{
	my $self = shift;

	my $branch = shift;
	my $type = ref($branch); #this'll grab what kind from the bless on the tree

	my $return; #to make things simpler later on

	if ($type eq "Add")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a + $b;
	}
	elsif ($type eq "Sub")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a - $b;
	}
	elsif ($type eq "Mul")
	{
#		print "------MULT!\n";
#		print Dumper($branch);

	    if ((ref($branch->[0]) eq "Fetch") && (ref($branch->[1]) eq "Array") && ($branch->[2] eq "imp"))
		{
		    #we've got a new style function call!
			my $a = $branch->[0][0]; #grab the function name
			my $b = $self->makevalue($branch->[1]);

			print "----------------FUNCCALL!\n";
			print Dumper($a, $b);
			
			if ($self->{funcs}->isfunc($a)) #check if there is a func $a
			{   #$return = $self->{funcs}->callfunc($self, $name, $args, $branch);
				$return = $self->{funcs}->callfunc($self, $a, $b, $branch);
			}
			else #otherwise we try to 
			{
				$a = $self->makevalue($branch->[0]); #evaluate it, since it wasn't a function
				$return = $a * $b; #do the multiplication
			}
		}
		else
		{
		    my $a = $self->makevalue($branch->[0]);
			my $b = $self->makevalue($branch->[1]);
			$return = $a * $b;
		}
	}
	elsif ($type eq "Div")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a / $b;
	}
	elsif ($type eq "Conforms")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = new Math::Farnsworth::Value::Boolean($a->conforms($b));
	}
	elsif ($type eq "Mod")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a % $b;
	}
	elsif ($type eq "Pow")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a ** $b;
	}
	elsif ($type eq "And")
	{
		my $a = $self->makevalue($branch->[0]);

		if ($a->bool())
		{
			my $b = $self->makevalue($branch->[1]);
			$return = $a && $b ? 1 : 0;
			$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
		}
		else
		{
			$return = Math::Farnsworth::Value::Boolean->new(0); #make sure its the right type
		}
	}
	elsif ($type eq "Or")
	{
		my $a = $self->makevalue($branch->[0]);

		if ($a->bool())
		{
			$return = Math::Farnsworth::Value::Boolean->new(1); #make sure its the right type
		}
		else
		{
			my $b = $self->makevalue($branch->[1]);
			$return = $a || $b ? 1 : 0;
			$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
		}
	}
	elsif ($type eq "Xor")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a->bool() ^ $b->bool() ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Not")
	{
		my $a = $self->makevalue($branch->[0]);
		$return = $a->bool() ? 0 : 1;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Gt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = ($a > $b) ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Lt")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a < $b ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Ge")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a >= $b ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Le")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a <= $b ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Compare")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a <=> $b;
		$return = Math::Farnsworth::Value::Pari->new($return); #make sure its the right type
	}
	elsif ($type eq "Eq")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a == $b ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Ne")
	{
		my $a = $self->makevalue($branch->[0]);
		my $b = $self->makevalue($branch->[1]);
		$return = $a != $b ? 1 : 0;
		$return = Math::Farnsworth::Value::Boolean->new($return); #make sure its the right type
	}
	elsif ($type eq "Ternary")
	{
		#turing completeness FTW
		my $left = $self->makevalue($branch->[0]);
		#$left = $left->bool() != new Math::Farnsworth::Value::Pari(0, $left->{dimen}); #shouldn't need it anymore, since i got ->bool working
		$return = $left ? $self->makevalue($branch->[1]) : $self->makevalue($branch->[2]);
	}
	elsif ($type eq "If")
	{
		#turing completeness FTW
		my $left = $self->makevalue($branch->[0]);
		#$left = $left != new Math::Farnsworth::Value(0, $left->{dimen});
		
		if ($left)
		{
			$return = $self->makevalue($branch->[1]);
		}
		else
		{
			$return = $self->makevalue($branch->[2]);
		}
	}
	elsif ($type eq "Store")
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);
		$return = $value; #make stores evaluate to the value on the right
		$self->{vars}->setvar($name, $value);
	}
	elsif ($type eq "DeclareVar")
	{
		my $name = $branch->[0];
		my $value;

		if (defined($branch->[1]))
		{
			$value = $self->makevalue($branch->[1]);
		}
		else
		{
			$value = $self->makevalue(bless [0], 'Num');
		}

		$return = $value; #make stores evaluate to the value on the right
		$self->{vars}->declare($name, $value);
	}
	elsif ($type eq "FuncDef")
	{
		#print Dumper($branch);
		my $name = $branch->[0];
		my $args = $branch->[1];
		my $value = $branch->[2]; #not really a value, but in fact the tree to run for the function

		my $vargs;

		for my $arg (@$args)
		{
			my $constraint = $arg->[2];
			my $default = $arg->[1];
			my $name = $arg->[0]; #name

			if (defined($default))
			{
				$default = $self->makevalue($default); #should be right
			}

			if (defined($constraint))
			{
				#print Dumper($constraint);
				$constraint = $self->makevalue($constraint); #should be right
				#print Dumper($constraint);
			}

			push @$vargs, [$name, $default, $constraint];
		}

		$self->{funcs}->addfunc($name, $vargs, $value);
		$return = undef; #cause an error should someone manage to make it parse other than the way i think it should be
	}
	elsif ($type eq "FuncCall")
	{
		my $name = $branch->[0];
		my $args = $self->makevalue($branch->[1]); #this is an array, need to evaluate it

		$return = $self->{funcs}->callfunc($self, $name, $args, $branch);

		#print "FUNCCALL RETURNED\n";
		#print Dumper($return);

	}
	elsif ($type eq "Lambda")
	{
		my $args = $branch->[0];
		my $code = $branch->[1];

		#print "==========LAMBDA==========\n";
		#print Data::Dumper->Dump([$args,$code], ["args", "code"]);

		my $nvars = new Math::Farnsworth::Variables($self->{vars}); #lamdbas get their own vars
		my %nopts = (vars => $nvars, funcs => $self->{funcs}, units => $self->{units}, parser => $self->{parser});
		my $scope = $self->new(%nopts);

		#this should probably get a function in Math::Farnsworth::FunctionDispatch
		my $vargs;

		for my $arg (@$args)
		{
			my $constraint = $arg->[2];
			my $default = $arg->[1];
			my $name = $arg->[0]; #name

			if (defined($default))
			{
				$default = $self->makevalue($default); #should be right
			}

			if (defined($constraint))
			{
				#print Dumper($constraint);
				$constraint = $self->makevalue($constraint); #should be right
				#print Dumper($constraint);
			}

			push @$vargs, [$name, $default, $constraint];
		}

		my $lambda = {code => $code, args => $vargs, 
			          scope => $scope, branches=>$branch};

		$return = new Math::Farnsworth::Value::Lambda($scope, $args, $code, $branch);
	}
	elsif ($type eq "LambdaCall")
	{		
		my $left = $self->makevalue($branch->[0]);
		my $right = $self->makevalue($branch->[1]);

		die "Right side of lamdbda call must evaluate to a Lambda\n" unless $right->istype("Lambda");

		#need $args to be an array
		my $args = $left->istype("Array") ? $left :  new Math::Farnsworth::Value::Array([$left]); 

		$return = $self->{funcs}->calllambda($right, $args); #needs to be updated
	}
	elsif (($type eq "Array") || ($type eq "SubArray"))
	{
		my $array = []; #fixes bug with empty arrays
		for my $bs (@$branch) #iterate over all the elements
		{
			my $type = ref($bs); #find out what kind of thing we are
			my $value = $self->makevalue($bs);

			#print "ARRAY FILL -- $type\n";

#			if ($value->istype("Array"))
#			{
				#since we have an array, but its not in a SUBarray, we dereference it before the push
				#push @$array, $value->getarray() unless ($type eq "SubArray");
				#push @$array, $value;# if ($type eq "SubArray");
				#}
			#else
			{
				#print "ARRAY VALUE --- ".Dumper($value);
				#its not an array or anything so we push it on
				push @$array, $value; #we return an array ref! i need more error checking around for this later
			}
		}
		$return = new Math::Farnsworth::Value::Array($array);
	}
	elsif ($type eq "ArgArray")
	{
		my $array = []; #autovivification wasn't working?
		for my $bs (@$branch) #iterate over all the elements
		{
			my $type = ref($bs); #find out what kind of thing we are
			my $value = $self->makevalue($bs);

			#even if it is an array we don't want to deref it here, because thats the wrong behavior, this will make things like push[a, 1,2,3] work properly
			push @$array, $value; #we return an array ref! i need more error checking around for this later
		}
		$return = new Math::Farnsworth::Value::Array($array);
	}
	elsif ($type eq "ArrayFetch")
	{
		my $var = $self->makevalue($branch->[0]); #need to check if this is an array, and die if not
		my $listval = $self->makevalue($branch->[1]);
		my @rval;

		#print Dumper($branch, $var, $listval);

		for ($listval->getarray())
		{
			print STDERR "ARFET: ".$_->toperl()."\n";
			#ok this line FOR WHATEVER REASON, makes Math::Pari.xs die in isnull(), WHY i don't know, there's something wrong here somewhere
			#my $float = $_ * (Math::Farnsworth::Value::Pari->new(1.0)); #makes rationals work right
			my $input = $var->getarrayref()->[$_->getpari()*1.0]; #."" makes indexes work right again
			die "Array out of bounds\n" unless defined $input; #NTS: would be useful to look if i have a name and use it
			push @rval, $input;
		}

		#print Dumper(\@rval);

		if (@rval > 1)
		{
			my $pr = new Math::Farnsworth::Value::Array([@rval]);
			$return = $pr;
		}
		else
		{
			$return = $rval[0];
		}
	}
	elsif ($type eq "ArrayStore")
	{
		my $var = $self->makevalue(bless [$branch->[0]], 'Fetch'); #need to check if this is an array, and die if not
		my $listval = $self->makevalue($branch->[1]);
		my $rval = $self->makevalue($branch->[2]);

		#print Dumper($branch, $var, $listval);

		if ($listval->getarray() > 1)
		{
			die "Assigning to slices not implemented yet\n";
		}

		$var->getarrayref()->[$listval->getarrayref()->[0]] = $rval;

		for my $value ($var->getarray())
		{
			$value = $self->makevalue(bless [0], 'Num') if !defined($value);
		}

		$return = $rval;
	}
	elsif ($type eq "While")
	{
		my $cond = $branch->[0]; #what to check each time
		my $stmts = $branch->[1]; #what to run each time

		my $condval = $self->makevalue($cond);
		while ($condval)
		{
			my $v = $self->makevalue($stmts);
			$condval = $self->makevalue($cond);
		}

		$return = undef; #cause errors
	}
	elsif ($type eq "Stmt")
	{
		for my $bs (@$branch) #iterate over all the statements
		{   
			if (defined($bs))
			{
				my $r = $self->makevalue($bs);
				$return = $r if defined $r; #this has interesting semantics!
			}
		}
	}
	elsif ($type eq "Paren")
	{
		$return = $self->makevalue($branch->[0]);
	}
	elsif ($type eq "SetDisplay")
	{
		print Dumper($branch);
		my $combo = $branch->[0][0]; #is a string?
		my $right = $branch->[1];

		Math::Farnsworth::Output->setdisplay($combo, $right);
	}
	elsif ($type eq "UnitDef")
	{
		my $unitsize = $self->makevalue($branch->[1]);
		my $name = $branch->[0];
		$self->{units}->addunit($name, $unitsize);
	}
	elsif ($type eq "DefineDimen")
	{
		my $unit = $branch->[1];
		my $dimen = $branch->[0];
		$self->{units}->adddimen($dimen, $unit);
	}
	elsif ($type eq "DefineCombo")
	{
		my $combo = $branch->[1]; #should get me a string!
		my $value = $self->makevalue($branch->[0]);
		Math::Farnsworth::Output::addcombo($combo, $value);
	}
	elsif (($type eq "SetPrefix") || ($type eq "SetPrefixAbrv"))
	{
		my $name = $branch->[0];
		my $value = $self->makevalue($branch->[1]);
		#carp "SETTING PREFIX0: $name : $value : ".Dumper($branch->[1]) if ($name eq "m");
		$self->{units}->setprefix($name, $value);
	}
	elsif ($type eq "Trans")
	{
		my $left = $self->makevalue($branch->[0]);
		my $rights = eval {$self->makevalue($branch->[1])};
		my $right = $rights;

		if (!$@ && $rights->istype("String")) #if its a string we do some fun stuff
		{
			$right = $self->eval($rights->getstring()); #we need to set $right to the evaluation $rights
		}

		if (!$@)
		{
			if ($left->conforms($right)) #only do this if they are the same
			{
				my $dispval = ($left / $right);
				$return = $left;
				
				if ($rights->istype("String"))
				{
					#right side was a string, use it
					$return->{outmagic} = [$dispval, $rights];
				}
				else
				{
					$return->{outmagic} = [$dispval];
				}
			}
			elsif ($self->{funcs}->isfunc($branch->[1][0]))
			{
				$left = $left->istype("Array") ? $left : new Math::Farnsworth::Value::Array([$left]);
				$return = $self->{funcs}->callfunc($self, $branch->[1][0], $left);
			}
			else
			{
				die "Conformance error, left side has different units than right side\n";
			}
		}
		else
		{
			#$right doesn't evaluate... so we check for a function?
			$left = $left->istype("Array") ? $left : new Math::Farnsworth::Value::Array([$left]);
			$return = $self->{funcs}->callfunc($self, $branch->[1][0], $left);
		}
	}

	if (!defined($return))
	{
		#this creates a "true" undefined value for returning, this makes things funner! it also introduced a bug from naive coding above, which has been fixed
		$return = new Math::Farnsworth::Value::Undef();
	}
	
	return $return;
}

sub makevalue
{
	my $self = shift;
	my $input = shift;

#	print "MAKEVALUE---------\n";
#	print Dumper($input);

	if (ref($input) eq "Num")
	{
		#need to make a value here with Math::Farnsworth::Value!
		my $val = new Math::Farnsworth::Value::Pari($input->[0]);
		return $val;
	}
	if (ref($input) eq "HexNum")
	{
		#need to make a value here with Math::Farnsworth::Value!
		#print "HEX VALUE: ".$input->[0]."\n";
		my $value = eval $input->[0]; #this SHOULD work, shouldn't be a security risk since its validated through the lexer and parser.
		my $val = new Math::Farnsworth::Value::Pari($value);
		return $val;
	}
	elsif (ref($input) eq "Fetch")
	{
		#this needs to decide between variable and unit, but that'll come later
		#esp since i also have to have this overridable for functions!

		my $name = $input->[0];
		if ($self->{vars}->isvar($name))
		{
			return $self->{vars}->getvar($input->[0]);
		}
		elsif ($self->{units}->isunit($name))
		{
			#print "FETCH: $name\n" if ($name eq "milli");
			return $self->{units}->getunit($name);
		}
		
		die "Undefined symbol '$name'\n";
	}
	elsif (ref($input) eq "String") #we've got a string that should be a value!
	{
		my $value = $input->[0];
		#here it comes in with quotes, so lets remove them
		$value =~ s/^"(.*)"$/$1/;
		$value =~ s/\\"/"/g;
		$value =~ s/\\\\/\\/g;
		my $ss = sub
		{
			my $var =shift; 
			$var =~ s/^[\$]//; 
			my $output = undef;
			if ($var !~ /^{.*}$/) 
			{
				$output = new Math::Farnsworth::Output($self->{units}, $self->{vars}->getvar($var), $self);
			} 
			else 
			{
				$var =~ s/[{}]//g;
				$output = new Math::Farnsworth::Output($self->{units}, $self->eval($var), $self);
			}

			"".$output;
		};
		$value =~ s/(?<!\\)(\$\w+|\${[^}]+})/$ss->($1)/eg;
		my $val = new Math::Farnsworth::Value::String($value);
		return $val;
	}
	elsif (ref($input) eq "Date")
	{
		#print "\n\n\nMaking DATE!\n\n\n";
		my $val = new Math::Farnsworth::Value::Date($input->[0]);
#		print Dumper($val);
		return $val;
	}
	elsif (ref($input) eq "VarArg")
	{
		#warn "Got a VarArg, code untested, want to mark when i get them\n"; #just so i can track down the inevitable crash
		return "VarArg";
	}
	elsif (ref($input) =~ /Math::Farnsworth::Value/)
	{
		warn "Got a Math::Farnsworth::Value::*, i PROBABLY shouldn't be getting these, i'm just going to let it fall through";
		return $input;
	}

	return $self->evalbranch($input);
}

1;
