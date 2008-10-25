1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Math::Farnsworth::Syntax - A bunch of examples of all the syntax in Math::Farnsworth

=head1 SYNOPSIS

This document is intended to help you understand how Math::Farnsworth syntax looks

=head1 DESCRIPTION

Math::Farnsworth is a programming language originally inspired by Frink (see http://futureboy.homeip.net/frinkdocs/ ).
However due to certain difficulties during the creation of it, the syntax has changed slightly and the capabilities are also different.
Some things Math::Farnsworth can do a little better than Frink, other areas Math::Farnsworth lacks (sometimes greatly).

=head2 IMPLICIT MULTIPLICATION

In Math::Farnsworth two tokens that are seperated by a space or parenthesis are 

=head2 VARIABLES

Variables in Math::Farnsworth are pretty simple to understand

	a = 1
	b = a + a
	c = b * b

You can also explicitly declare a variable so that it will only stay local to the scope that it is defined in, this allows you to define a variable that won't cause problems for anybody calling a function or lambda

	var i;
	var x = 10;

=head3 Arrays

Arrays in Math::Farnsworth are pretty simple to understand and create

	B<[>elementB<,> elementB<,> elementB<,> ...B<]>

You can have any number of elements and they can contain anything that you can store in a variable (currently the only thing you cannot store in a variable is a function, but there is a solution to that, see below about Lambdas)

=head2 OPERATORS

The Farnsworth Language is a simple language to learn, the basic operators +-/* are all there and do exactly what you think they should do (assuming you know any math or have programmed before)

There are however two additional operators that you should be aware of to start with

=head3 Logical Operators

Farnsworth has logical operators for dealing with boolean values, it has the standard ones B<||> for OR, and B<&&> for AND, and B<!boolean> for NOT. It also has one more additional one B<^^> for XOR as I've found that to be useful in many situations

=head3 per

This is almost exactly the same as the division operator except that it has a different precedence this allows you to do things like

	10 meters per 3 hours

This means the same as

	10 meters / (3 hours)

but it can be much easier to understand

=head3 Implicit Multiplication

White space or parenthesis between things (numbers, variables, function calls, etc.) means that you want to implicitly multiply the two tokens

	10 meters

is the same as

	10 * meters

note that space around operators such as +-*/ does not imply multiplication, this means that if you wanted to multiply something by a negative number you MUST use a *, otherwise it will think you want to subtract

=head2 Functions

Like most reasonable programming languages Math::Farnsworth has functions, the standard library contains many math related functions see L<Math::Farnsworth::Functions> for a reference of them

=head3 Defining

To define a function you'll want to do something like this

	f{x} := x+x

First we've got 'B<f>' which is the name of the function, then we've got this weird little part following it 'B<{x}>' this defines the arguments that the functions takes, in this case its a single argument named 'B<x>', next we've got 'B<:=>' this is the assignment operator for defining a function (it is also used for units, but we'll cover that later) then we've got the expression 'B<x+x>' which is what the function actually does, in this case we're adding the argument to the function to itself

Now lets have a look at a slightly more complicated function

	max{x,y} := { var z; if (x > y) {z = x} else {z = y}; z}

here we've got a function 'B<max>' that takes two arguments, 'B<x>' and 'B<y>', then we've got something new on the right side, 'B<{ var z; if (x E<gt> y) {z = x} else {z = y}; z}>', we've surrounded the expression on the right with ' B<{ }> ', this lets us use multiple statements to build up the function if you've programmed before you'll realize that we're seperating each expression with a 'B<;>'

the very last expression that gets evaluated, in this case, 'B<z>' is what the function returns (NOTE: there are plans to add the ability to return at any point in the function but those have not been implemented yet)

=head3 Calling Functions

After defining a function you really should be able to call them shouldn't you? there are two basic ways to call functions in Farnsworth

The simplest way is this

	max[1,2]

this will call the function 'B<max>' with the arguments 'B<1>'and 'B<2>'

There is also another way to call functions indirectly, this way shouldn't be used in most cases as it can be confused with unit conversions which we will cover later

	[1,2] -> max
	10 -> f

both of these methods call the functions to the right of 'B<-E<gt>>' using the expressions on the left as arguments. As I've said though this method shouldn't be used heavily as it can be ambiguous as to what you are wanting to do.

=head3 Default Parameters

Arguments to functions in Math::Farnsworth can have default parameters so that they don't always have to be specified explicitly.
They are set when you create the function by setting the arguments equal to the default value

	f{x = 1} := {x * x}

=head3 Type Constraints

Arguments can also be told that they have to be of a certain type in order to be given to a function, otherwise an exception is raised and the execution of the code stops

These also are create at the time you define the function

	f{x isa meter} := {x per 10 seconds}

Currently type constraints have to be some expression that describes the type of input you are expecting, in this case we used "meter" however meter describes a length, and any expression that describes a length can be used as the argument to the function e.g.

	f[10 feet]

is perfectly valid.  There are plans to implement the ability to say something like 'B<f{x isa length}> however they have not been implemented yet.
You can combine default arguments and constraints by specifiying the default argument first, e.g.

	f{x = 10 cm isa meter} := {x per 10 seconds}

=head2 Units

What are units?
Units are things like: inches, feet, meters, gallons, volts, liters, etc.

Farnsworth tracks units throughout all calculations that you do with it this allows you to do things like add two lengths together, or multiply them to get an area.

It also does unit conversions along the way allowing you to do things like 'B<1 foot + 12 inches> ' and Farnsworth will handle it for you correctly.

Farnsworth handles this by converting everything into a single base unit when performing calculations, in the case of lengths it represents them all as meters

=head3 Unit Conversions
 
Since Farnsworth represents everything as a single unit it will always want to give you back your calculations in that base unit; This isn't always what you want. So you can tell it to convert between the units to get exactly what you are after.

	1 foot + 12 inches

When doing that calculation you would most likely want your answer back in 'B<feet>', however farnsworth gives you back something like

	0.6096 m

Now what the heck is that? You wanted feet didn't you? This is what the 'B<-E<gt>>' operator is for, it will make farnsworth tell you the result in any unit you wish, so lets try this again

	1 foot + 12 inches -> feet

and Farnsworth gives you back the single number 'B<2>'. Thats the correct answer, but what if you wanted it to tell you 'B<2 feet>' instead? you can do this by putting the unit you want the result in in quotes that will tell Farnsworth that you want the answer to contain the unit also. So lets do this one more time

	1 foot + 12 inches -> "feet"

And Farnsworth will give you back

	2 feet

=head3 Unit Definitions

Now that you know how to convert between units, lets talk about how to create your own, the basic syntax is

	UnitName := Expression

This allows you to create any unit you would desire, say you want to be able to use smoots to measure things?

	smoot := 5 feet + 7 inches

now you can talk about measurements like 'B<6.5 smoots>' in any other calculation, or convert any distance to smoots, e.g. 'B<1 au -E<gt> "smoots"> '

=head3 Unit Prefixes

Farnsworth also supports the SI standard prefixes such as kilo, centi, nano, etc.

It however supports them on ALL units, so you can in fact say 'B<1 kilosmoot>' to mean 1000 smoots.

you can also define your own prefixes by doing this
	
	kibi :- 1024
	mibi :- 1024 * 1024

This allows you to add any prefixes you need to make a calculation simple and easy to do

NOTE: bits and bytes use the SI units of 1000 for kilobit, megabit, etc. to get the normal meaning of 1024 instead, use the of prefixes such as kibibit, mebibyte, etc. see http://en.wikipedia.org/wiki/Binary_prefix for more information on them.

=head3 More Advanced Unit Manipulation
 
You can also define your own basic units like length, time and mass, you do this by syntax like the following 

	name =!= basicunit

'B<name>' is some unique name for the type of measurement that is going to be represented and 'B<basicunit>' is the primary unit of measure for this "dimension"

so lets say we wanted to be able to count pixels as units 

	pixel =!= pixel
	
and now you've got a basic unit B<pixel> that you can use to define other things like how many pixels are in a VGA screen

	VGA := 640 * 480 pixels

=head2 Control Structures

Like all useful programming languages Math::Farnsworth has ways to do loops and branching

=head3 If

As you've seen above Math::Farnsworth does have B<if> statements, they look just like they do in C or Perl or Java or most other languages like those

	B<if (> condition B<) {> statements to run if true; B<} else {> the optional else clause to run if the condition is false B<}>

=head3 While

Farnsworth also has loops, they look exactly like they do in C or Perl or Java

	B<while (> condition B<) {> statements to run while condition is true B<}>

This is currently the only kind of loop that exists in Farnsworth, however ALL types of loops can be made from this, which is an exercise currently outside the scope of this document

NOTE: for loops are definitely going to be added, i just haven't gotten to them yet.

=head2 Lambdas

Lambdas are a very neat feature of the Math::Farnsworth language, they are best described as something very similar to a subroutine reference in perl.
When you create a lambda it keeps the environment with it that it was defined in (as far as variables are concerned anyway).  This allows you to do things like create static variables between calls

Note: if anyone can think of a better name for these feel free to contact me about it.
Also Note: the syntax for them MIGHT change as i begin to learn how to rewrite the parser to be smarter and fix a number of problems i have with it

=head3 Defining a Lambda

The basic syntax for defining a lambda is similar to how functions are defined

	variable = {`arguments` statements};
	distance = {`x, y` sqrt[x * x + y * y]};

As you can see here, a lambda is actually stored inside a variable rather than a different namespace like functions are, this allows you to have a variable contain the lambda and use it only inside the scope it was defined in, this also allows for fun results when nesting lambdas

=head3 Calling Lambdas

Calling a lambda is fairly simple, the syntax looks a lot like the syntax for doing unit conversion or calling a function implicitly.

	argument => lambda
	[arguments] => lambda

This syntax also makes it easy to chain several lambdas up to do multiple calculations and have the order of execution blatently obvious

	[arguments] => lambda1 => lambda2 => lambda3

=head3 Nesting Lambdas

Since i've mentioned it before and example is neccesary of what nesting a lambda really means

	index = ([] => {`` var count=0; {`` count = count + 1}});

What we've got here is a lambda call inside of an expression that returns a lambda.  Since lambdas carry the scopes that they were defined in around with them the lambda that B<index> contains has access to the variable B<count> and since it was defined outside of the nested lambda it does not get reset between calls, allowing it to continue incrementing B<count> over and over.  
And because B<count> was declared in the first lambda it isn't available to anything outside of that scope, meaning that B<count> cannot be altered by anything other than the lambda that B<index> now contiains.

=head1 SEE ALSO

L<Math::Farnsworth::Evaluate> 
L<Math::Farnsworth::Value> 
L<Math::Farnsworth::Syntax> 
L<Math::Farnsworth::Functions>

There is also an RT tracker for the module (this may change) setup at
L<http://farnsworth.sexypenguins.com/>, you can also reach the tracker by sending an email to E<lt>farnswort.rt@gmail.comE<gt>

=head1 AUTHOR

Ryan Voots E<lt>simcop@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Ryan Voots

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
