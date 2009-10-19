####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Math::Farnsworth::Parser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
#Included Parse/Yapp/Driver.pm file----------------------------------------
{
#
# Module Parse::Yapp::Driver
#
# This module is part of the Parse::Yapp package available on your
# nearest CPAN
#
# Any use of this module in a standalone parser make the included
# text under the same copyright as the Parse::Yapp module itself.
#
# This notice should remain unchanged.
#
# (c) Copyright 1998-2001 Francois Desarmenien, all rights reserved.
# (see the pod text in Parse::Yapp module for use and distribution rights)
#

package Parse::Yapp::Driver;

require 5.004;

use strict;

use vars qw ( $VERSION $COMPATIBLE $FILENAME );

$VERSION = '1.05';
$COMPATIBLE = '0.07';
$FILENAME=__FILE__;

use Carp;

#Known parameters, all starting with YY (leading YY will be discarded)
my(%params)=(YYLEX => 'CODE', 'YYERROR' => 'CODE', YYVERSION => '',
			 YYRULES => 'ARRAY', YYSTATES => 'ARRAY', YYDEBUG => '');
#Mandatory parameters
my(@params)=('LEX','RULES','STATES');

sub new {
    my($class)=shift;
	my($errst,$nberr,$token,$value,$check,$dotpos);
    my($self)={ ERROR => \&_Error,
				ERRST => \$errst,
                NBERR => \$nberr,
				TOKEN => \$token,
				VALUE => \$value,
				DOTPOS => \$dotpos,
				STACK => [],
				DEBUG => 0,
				CHECK => \$check };

	_CheckParams( [], \%params, \@_, $self );

		exists($$self{VERSION})
	and	$$self{VERSION} < $COMPATIBLE
	and	croak "Yapp driver version $VERSION ".
			  "incompatible with version $$self{VERSION}:\n".
			  "Please recompile parser module.";

        ref($class)
    and $class=ref($class);

    bless($self,$class);
}

sub YYParse {
    my($self)=shift;
    my($retval);

	_CheckParams( \@params, \%params, \@_, $self );

	if($$self{DEBUG}) {
		_DBLoad();
		$retval = eval '$self->_DBParse()';#Do not create stab entry on compile
        $@ and die $@;
	}
	else {
		$retval = $self->_Parse();
	}
    $retval
}

sub YYData {
	my($self)=shift;

		exists($$self{USER})
	or	$$self{USER}={};

	$$self{USER};
	
}

sub YYErrok {
	my($self)=shift;

	${$$self{ERRST}}=0;
    undef;
}

sub YYNberr {
	my($self)=shift;

	${$$self{NBERR}};
}

sub YYRecovering {
	my($self)=shift;

	${$$self{ERRST}} != 0;
}

sub YYAbort {
	my($self)=shift;

	${$$self{CHECK}}='ABORT';
    undef;
}

sub YYAccept {
	my($self)=shift;

	${$$self{CHECK}}='ACCEPT';
    undef;
}

sub YYError {
	my($self)=shift;

	${$$self{CHECK}}='ERROR';
    undef;
}

sub YYSemval {
	my($self)=shift;
	my($index)= $_[0] - ${$$self{DOTPOS}} - 1;

		$index < 0
	and	-$index <= @{$$self{STACK}}
	and	return $$self{STACK}[$index][1];

	undef;	#Invalid index
}

sub YYCurtok {
	my($self)=shift;

        @_
    and ${$$self{TOKEN}}=$_[0];
    ${$$self{TOKEN}};
}

sub YYCurval {
	my($self)=shift;

        @_
    and ${$$self{VALUE}}=$_[0];
    ${$$self{VALUE}};
}

sub YYExpect {
    my($self)=shift;

    keys %{$self->{STATES}[$self->{STACK}[-1][0]]{ACTIONS}}
}

sub YYLexer {
    my($self)=shift;

	$$self{LEX};
}


#################
# Private stuff #
#################


sub _CheckParams {
	my($mandatory,$checklist,$inarray,$outhash)=@_;
	my($prm,$value);
	my($prmlst)={};

	while(($prm,$value)=splice(@$inarray,0,2)) {
        $prm=uc($prm);
			exists($$checklist{$prm})
		or	croak("Unknow parameter '$prm'");
			ref($value) eq $$checklist{$prm}
		or	croak("Invalid value for parameter '$prm'");
        $prm=unpack('@2A*',$prm);
		$$outhash{$prm}=$value;
	}
	for (@$mandatory) {
			exists($$outhash{$_})
		or	croak("Missing mandatory parameter '".lc($_)."'");
	}
}

sub _Error {
	print "Parse error.\n";
}

sub _DBLoad {
	{
		no strict 'refs';

			exists(${__PACKAGE__.'::'}{_DBParse})#Already loaded ?
		and	return;
	}
	my($fname)=__FILE__;
	my(@drv);
	open(DRV,"<$fname") or die "Report this as a BUG: Cannot open $fname";
	while(<DRV>) {
                	/^\s*sub\s+_Parse\s*{\s*$/ .. /^\s*}\s*#\s*_Parse\s*$/
        	and     do {
                	s/^#DBG>//;
                	push(@drv,$_);
        	}
	}
	close(DRV);

	$drv[0]=~s/_P/_DBP/;
	eval join('',@drv);
}

#Note that for loading debugging version of the driver,
#this file will be parsed from 'sub _Parse' up to '}#_Parse' inclusive.
#So, DO NOT remove comment at end of sub !!!
sub _Parse {
    my($self)=shift;

	my($rules,$states,$lex,$error)
     = @$self{ 'RULES', 'STATES', 'LEX', 'ERROR' };
	my($errstatus,$nberror,$token,$value,$stack,$check,$dotpos)
     = @$self{ 'ERRST', 'NBERR', 'TOKEN', 'VALUE', 'STACK', 'CHECK', 'DOTPOS' };

#DBG>	my($debug)=$$self{DEBUG};
#DBG>	my($dbgerror)=0;

#DBG>	my($ShowCurToken) = sub {
#DBG>		my($tok)='>';
#DBG>		for (split('',$$token)) {
#DBG>			$tok.=		(ord($_) < 32 or ord($_) > 126)
#DBG>					?	sprintf('<%02X>',ord($_))
#DBG>					:	$_;
#DBG>		}
#DBG>		$tok.='<';
#DBG>	};

	$$errstatus=0;
	$$nberror=0;
	($$token,$$value)=(undef,undef);
	@$stack=( [ 0, undef ] );
	$$check='';

    while(1) {
        my($actions,$act,$stateno);

        $stateno=$$stack[-1][0];
        $actions=$$states[$stateno];

#DBG>	print STDERR ('-' x 40),"\n";
#DBG>		$debug & 0x2
#DBG>	and	print STDERR "In state $stateno:\n";
#DBG>		$debug & 0x08
#DBG>	and	print STDERR "Stack:[".
#DBG>					 join(',',map { $$_[0] } @$stack).
#DBG>					 "]\n";


        if  (exists($$actions{ACTIONS})) {

				defined($$token)
            or	do {
				($$token,$$value)=&$lex($self);
#DBG>				$debug & 0x01
#DBG>			and	print STDERR "Need token. Got ".&$ShowCurToken."\n";
			};

            $act=   exists($$actions{ACTIONS}{$$token})
                    ?   $$actions{ACTIONS}{$$token}
                    :   exists($$actions{DEFAULT})
                        ?   $$actions{DEFAULT}
                        :   undef;
        }
        else {
            $act=$$actions{DEFAULT};
#DBG>			$debug & 0x01
#DBG>		and	print STDERR "Don't need token.\n";
        }

            defined($act)
        and do {

                $act > 0
            and do {        #shift

#DBG>				$debug & 0x04
#DBG>			and	print STDERR "Shift and go to state $act.\n";

					$$errstatus
				and	do {
					--$$errstatus;

#DBG>					$debug & 0x10
#DBG>				and	$dbgerror
#DBG>				and	$$errstatus == 0
#DBG>				and	do {
#DBG>					print STDERR "**End of Error recovery.\n";
#DBG>					$dbgerror=0;
#DBG>				};
				};


                push(@$stack,[ $act, $$value ]);

					$$token ne ''	#Don't eat the eof
				and	$$token=$$value=undef;
                next;
            };

            #reduce
            my($lhs,$len,$code,@sempar,$semval);
            ($lhs,$len,$code)=@{$$rules[-$act]};

#DBG>			$debug & 0x04
#DBG>		and	$act
#DBG>		and	print STDERR "Reduce using rule ".-$act." ($lhs,$len): ";

                $act
            or  $self->YYAccept();

            $$dotpos=$len;

                unpack('A1',$lhs) eq '@'    #In line rule
            and do {
                    $lhs =~ /^\@[0-9]+\-([0-9]+)$/
                or  die "In line rule name '$lhs' ill formed: ".
                        "report it as a BUG.\n";
                $$dotpos = $1;
            };

            @sempar =       $$dotpos
                        ?   map { $$_[1] } @$stack[ -$$dotpos .. -1 ]
                        :   ();

            $semval = $code ? &$code( $self, @sempar )
                            : @sempar ? $sempar[0] : undef;

            splice(@$stack,-$len,$len);

                $$check eq 'ACCEPT'
            and do {

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Accept.\n";

				return($semval);
			};

                $$check eq 'ABORT'
            and	do {

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Abort.\n";

				return(undef);

			};

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Back to state $$stack[-1][0], then ";

                $$check eq 'ERROR'
            or  do {
#DBG>				$debug & 0x04
#DBG>			and	print STDERR 
#DBG>				    "go to state $$states[$$stack[-1][0]]{GOTOS}{$lhs}.\n";

#DBG>				$debug & 0x10
#DBG>			and	$dbgerror
#DBG>			and	$$errstatus == 0
#DBG>			and	do {
#DBG>				print STDERR "**End of Error recovery.\n";
#DBG>				$dbgerror=0;
#DBG>			};

			    push(@$stack,
                     [ $$states[$$stack[-1][0]]{GOTOS}{$lhs}, $semval ]);
                $$check='';
                next;
            };

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Forced Error recovery.\n";

            $$check='';

        };

        #Error
            $$errstatus
        or   do {

            $$errstatus = 1;
            &$error($self);
                $$errstatus # if 0, then YYErrok has been called
            or  next;       # so continue parsing

#DBG>			$debug & 0x10
#DBG>		and	do {
#DBG>			print STDERR "**Entering Error recovery.\n";
#DBG>			++$dbgerror;
#DBG>		};

            ++$$nberror;

        };

			$$errstatus == 3	#The next token is not valid: discard it
		and	do {
				$$token eq ''	# End of input: no hope
			and	do {
#DBG>				$debug & 0x10
#DBG>			and	print STDERR "**At eof: aborting.\n";
				return(undef);
			};

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Dicard invalid token ".&$ShowCurToken.".\n";

			$$token=$$value=undef;
		};

        $$errstatus=3;

		while(	  @$stack
			  and (		not exists($$states[$$stack[-1][0]]{ACTIONS})
			        or  not exists($$states[$$stack[-1][0]]{ACTIONS}{error})
					or	$$states[$$stack[-1][0]]{ACTIONS}{error} <= 0)) {

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Pop state $$stack[-1][0].\n";

			pop(@$stack);
		}

			@$stack
		or	do {

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**No state left on stack: aborting.\n";

			return(undef);
		};

		#shift the error token

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Shift \$error token and go to state ".
#DBG>						 $$states[$$stack[-1][0]]{ACTIONS}{error}.
#DBG>						 ".\n";

		push(@$stack, [ $$states[$$stack[-1][0]]{ACTIONS}{error}, undef ]);

    }

    #never reached
	croak("Error in driver logic. Please, report it as a BUG");

}#_Parse
#DO NOT remove comment

1;

}
#End of include--------------------------------------------------


#line 20 "Farnsworth.yp"

use Data::Dumper; #boobs
my $s;		# warning - not re-entrant
my $fullstring;
my $charcount;


sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 17,
			"var" => 20,
			'DATE' => 4,
			"while" => 22,
			'STRING' => 7,
			"if" => 10,
			"(" => 26,
			'HEXNUMBER' => 25,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 18,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 1
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 27,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 2
		DEFAULT => -39
	},
	{#State 3
		DEFAULT => -76
	},
	{#State 4
		DEFAULT => -79
	},
	{#State 5
		DEFAULT => -40
	},
	{#State 6
		DEFAULT => -81
	},
	{#State 7
		DEFAULT => -80
	},
	{#State 8
		DEFAULT => -12
	},
	{#State 9
		DEFAULT => -38
	},
	{#State 10
		ACTIONS => {
			"(" => 29
		}
	},
	{#State 11
		ACTIONS => {
			'HEXNUMBER' => 25,
			"(" => 26,
			'NAME' => 30,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'exprval' => 31,
			'arrayfetchexpr' => 5
		}
	},
	{#State 12
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			":->" => 44,
			"!=" => 45,
			"|||" => 46,
			"?" => 49,
			"&&" => 48,
			"||" => 47,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -5
	},
	{#State 13
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"," => 58,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -21,
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'array' => 59,
			'expr' => 60,
			'multexpr' => 14
		}
	},
	{#State 14
		DEFAULT => -50
	},
	{#State 15
		DEFAULT => -34
	},
	{#State 16
		ACTIONS => {
			'NAME' => 62
		},
		DEFAULT => -31,
		GOTOS => {
			'arglist' => 63,
			'argelement' => 61
		}
	},
	{#State 17
		ACTIONS => {
			"[" => 64,
			"::-" => 68,
			":=" => 65,
			"=!=" => 67,
			"{" => 66,
			":-" => 69
		},
		DEFAULT => -36
	},
	{#State 18
		ACTIONS => {
			'' => 70
		}
	},
	{#State 19
		ACTIONS => {
			"\@" => 71,
			'HEXNUMBER' => 25,
			"(" => 26,
			'NUMBER' => 15,
			'NAME' => 30
		},
		DEFAULT => -48,
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'exprval' => 72,
			'arrayfetchexpr' => 5
		}
	},
	{#State 20
		ACTIONS => {
			'NAME' => 73
		}
	},
	{#State 21
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 75
		}
	},
	{#State 22
		ACTIONS => {
			"(" => 76
		}
	},
	{#State 23
		ACTIONS => {
			"\n" => 78,
			";" => 77
		},
		DEFAULT => -2
	},
	{#State 24
		DEFAULT => -13
	},
	{#State 25
		DEFAULT => -35
	},
	{#State 26
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 79,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 27
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -49
	},
	{#State 28
		ACTIONS => {
			"[" => 64,
			"::-" => 68,
			"{" => 66,
			":-" => 69
		},
		DEFAULT => -36
	},
	{#State 29
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 80,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 30
		DEFAULT => -36
	},
	{#State 31
		ACTIONS => {
			"\@" => 71
		},
		DEFAULT => -63
	},
	{#State 32
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 81,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 33
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 82,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 34
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 83,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 35
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 84,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 36
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 85,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 37
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 86,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 38
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 87,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 39
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 88,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 40
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 89,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 41
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 90,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 42
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 91,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 43
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 92,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 44
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 93,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 45
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 94,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 46
		ACTIONS => {
			'NAME' => 95
		}
	},
	{#State 47
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 96,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 48
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 97,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 49
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 98,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 50
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 99,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 51
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 100,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 52
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 101,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 53
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 102,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 54
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 103,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 55
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 104,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 56
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 105,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 57
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 106,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 58
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"," => 58,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -21,
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'array' => 107,
			'expr' => 60,
			'multexpr' => 14
		}
	},
	{#State 59
		ACTIONS => {
			"]" => 108
		}
	},
	{#State 60
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"," => 109,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"&&" => 48,
			"||" => 47,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -20
	},
	{#State 61
		ACTIONS => {
			"," => 110
		},
		DEFAULT => -33
	},
	{#State 62
		ACTIONS => {
			"isa" => 113,
			"byref" => 111,
			"=" => 112
		},
		DEFAULT => -28
	},
	{#State 63
		ACTIONS => {
			"`" => 114
		}
	},
	{#State 64
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"," => 58,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -21,
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'array' => 115,
			'expr' => 60,
			'multexpr' => 14
		}
	},
	{#State 65
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 116,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 66
		ACTIONS => {
			'NAME' => 62
		},
		DEFAULT => -31,
		GOTOS => {
			'arglist' => 117,
			'argelement' => 61
		}
	},
	{#State 67
		ACTIONS => {
			'NAME' => 118
		}
	},
	{#State 68
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 119,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 69
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 120,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 70
		DEFAULT => 0
	},
	{#State 71
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"," => 58,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -21,
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'array' => 121,
			'expr' => 60,
			'multexpr' => 14
		}
	},
	{#State 72
		ACTIONS => {
			"\@" => 71
		},
		DEFAULT => -45
	},
	{#State 73
		ACTIONS => {
			"=" => 122
		},
		DEFAULT => -6
	},
	{#State 74
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 17,
			"var" => 20,
			'DATE' => 4,
			"while" => 22,
			'STRING' => 7,
			"if" => 10,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 123,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 75
		ACTIONS => {
			"else" => 124
		},
		DEFAULT => -16
	},
	{#State 76
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 125,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 77
		ACTIONS => {
			"-" => 1,
			'DATE' => 4,
			'STRING' => 7,
			"if" => 10,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15,
			"{`" => 16,
			'NAME' => 17,
			"var" => 20,
			"while" => 22,
			"(" => 26,
			'HEXNUMBER' => 25
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 126,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 78
		ACTIONS => {
			"-" => 1,
			'DATE' => 4,
			'STRING' => 7,
			"if" => 10,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15,
			"{`" => 16,
			'NAME' => 17,
			"var" => 20,
			"while" => 22,
			"(" => 26,
			'HEXNUMBER' => 25
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 127,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 79
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			")" => 128,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 80
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			")" => 129,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 81
		ACTIONS => {
			"%" => 37,
			" " => 41,
			"*" => 42,
			"**" => 35,
			"^" => 40,
			"per" => 43,
			"/" => 52
		},
		DEFAULT => -52
	},
	{#State 82
		ACTIONS => {
			"-" => 32,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -58
	},
	{#State 83
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -64
	},
	{#State 84
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -57
	},
	{#State 85
		ACTIONS => {
			"%" => 37,
			" " => 41,
			"*" => 42,
			"**" => 35,
			"^" => 40,
			"per" => 43,
			"/" => 52
		},
		DEFAULT => -51
	},
	{#State 86
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -55
	},
	{#State 87
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -68
	},
	{#State 88
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -67
	},
	{#State 89
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -56
	},
	{#State 90
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -47
	},
	{#State 91
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -44
	},
	{#State 92
		ACTIONS => {
			"%" => 37,
			" " => 41,
			"*" => 42,
			"**" => 35,
			"^" => 40,
			"/" => 52
		},
		DEFAULT => -54
	},
	{#State 93
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -9
	},
	{#State 94
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -70
	},
	{#State 95
		DEFAULT => -11
	},
	{#State 96
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -61
	},
	{#State 97
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -60
	},
	{#State 98
		ACTIONS => {
			":" => 130,
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 99
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -62
	},
	{#State 100
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -78
	},
	{#State 101
		ACTIONS => {
			"**" => 35,
			"^" => 40
		},
		DEFAULT => -53
	},
	{#State 102
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"=" => 53,
			"<=>" => 55
		},
		DEFAULT => -41
	},
	{#State 103
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -77
	},
	{#State 104
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -69
	},
	{#State 105
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -66
	},
	{#State 106
		ACTIONS => {
			"-" => 32,
			"<" => undef,
			"%" => 37,
			"==" => undef,
			">=" => undef,
			" " => 41,
			"*" => 42,
			"<=" => undef,
			">" => undef,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => undef,
			"/" => 52,
			"<=>" => undef
		},
		DEFAULT => -65
	},
	{#State 107
		DEFAULT => -22
	},
	{#State 108
		DEFAULT => -75
	},
	{#State 109
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"," => 58,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -21,
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'array' => 131,
			'expr' => 60,
			'multexpr' => 14
		}
	},
	{#State 110
		ACTIONS => {
			'NAME' => 62
		},
		DEFAULT => -31,
		GOTOS => {
			'arglist' => 132,
			'argelement' => 61
		}
	},
	{#State 111
		ACTIONS => {
			"isa" => 133
		},
		DEFAULT => -30
	},
	{#State 112
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 134,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 113
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"..." => 137,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'expr' => 135,
			'multexpr' => 14,
			'constraint' => 136
		}
	},
	{#State 114
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 17,
			"var" => 20,
			'DATE' => 4,
			"while" => 22,
			'STRING' => 7,
			"if" => 10,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 138,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 115
		ACTIONS => {
			"]" => 139
		}
	},
	{#State 116
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -8
	},
	{#State 117
		ACTIONS => {
			"}" => 140
		}
	},
	{#State 118
		DEFAULT => -10
	},
	{#State 119
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"=" => 53,
			"<=>" => 55
		},
		DEFAULT => -71
	},
	{#State 120
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"=" => 53,
			"<=>" => 55
		},
		DEFAULT => -72
	},
	{#State 121
		ACTIONS => {
			"\$" => 141
		}
	},
	{#State 122
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 142,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 123
		ACTIONS => {
			"}" => 143
		}
	},
	{#State 124
		ACTIONS => {
			"{" => 74
		},
		GOTOS => {
			'ifstmts' => 144
		}
	},
	{#State 125
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			")" => 145,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		}
	},
	{#State 126
		DEFAULT => -3
	},
	{#State 127
		DEFAULT => -4
	},
	{#State 128
		DEFAULT => -37
	},
	{#State 129
		DEFAULT => -14
	},
	{#State 130
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 146,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 131
		DEFAULT => -19
	},
	{#State 132
		DEFAULT => -32
	},
	{#State 133
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"..." => 137,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'expr' => 135,
			'multexpr' => 14,
			'constraint' => 147
		}
	},
	{#State 134
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"isa" => 148,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -27
	},
	{#State 135
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -23
	},
	{#State 136
		DEFAULT => -26
	},
	{#State 137
		DEFAULT => -24
	},
	{#State 138
		ACTIONS => {
			"}" => 149
		}
	},
	{#State 139
		DEFAULT => -46
	},
	{#State 140
		ACTIONS => {
			":=" => 150
		}
	},
	{#State 141
		DEFAULT => -42
	},
	{#State 142
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"+" => 36,
			"**" => 35,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"^" => 40,
			"*" => 42,
			"per" => 43,
			"!=" => 45,
			"?" => 49,
			"||" => 47,
			"&&" => 48,
			"^^" => 50,
			"/" => 52,
			"->" => 51,
			"=" => 53,
			"=>" => 54,
			"<=" => 56,
			"<=>" => 55,
			">" => 57
		},
		DEFAULT => -7
	},
	{#State 143
		DEFAULT => -15
	},
	{#State 144
		DEFAULT => -17
	},
	{#State 145
		ACTIONS => {
			"{" => 151
		}
	},
	{#State 146
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"<=>" => 55
		},
		DEFAULT => -59
	},
	{#State 147
		DEFAULT => -29
	},
	{#State 148
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"..." => 137,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval2' => 2,
			'lambda' => 3,
			'exprval' => 19,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6,
			'exprval1' => 9,
			'expr' => 135,
			'multexpr' => 14,
			'constraint' => 152
		}
	},
	{#State 149
		DEFAULT => -43
	},
	{#State 150
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 28,
			'DATE' => 4,
			"{" => 154,
			'STRING' => 7,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		GOTOS => {
			'exprval1' => 9,
			'exprval2' => 2,
			'expr' => 153,
			'lambda' => 3,
			'exprval' => 19,
			'multexpr' => 14,
			'arrayfetchexpr' => 5,
			'assignexpr' => 6
		}
	},
	{#State 151
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 17,
			"var" => 20,
			'DATE' => 4,
			"while" => 22,
			'STRING' => 7,
			"if" => 10,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 155,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 152
		DEFAULT => -25
	},
	{#State 153
		ACTIONS => {
			"-" => 32,
			"conforms" => 33,
			"<" => 34,
			"%" => 37,
			"==" => 38,
			">=" => 39,
			" " => 41,
			"*" => 42,
			"||" => 47,
			"->" => 51,
			"=>" => 54,
			"<=" => 56,
			">" => 57,
			"**" => 35,
			"+" => 36,
			"^" => 40,
			"per" => 43,
			"!=" => 45,
			"&&" => 48,
			"?" => 49,
			"^^" => 50,
			"/" => 52,
			"=" => 53,
			"<=>" => 55
		},
		DEFAULT => -73
	},
	{#State 154
		ACTIONS => {
			"{`" => 16,
			"-" => 1,
			'NAME' => 17,
			"var" => 20,
			'DATE' => 4,
			"while" => 22,
			'STRING' => 7,
			"if" => 10,
			'HEXNUMBER' => 25,
			"(" => 26,
			"!" => 11,
			"[" => 13,
			'NUMBER' => 15
		},
		DEFAULT => -1,
		GOTOS => {
			'exprval2' => 2,
			'stma' => 156,
			'lambda' => 3,
			'exprval' => 19,
			'ifstartcond' => 21,
			'arrayfetchexpr' => 5,
			'if' => 8,
			'assignexpr' => 6,
			'stmt' => 23,
			'exprval1' => 9,
			'while' => 24,
			'expr' => 12,
			'multexpr' => 14
		}
	},
	{#State 155
		ACTIONS => {
			"}" => 157
		}
	},
	{#State 156
		ACTIONS => {
			"}" => 158
		}
	},
	{#State 157
		DEFAULT => -18
	},
	{#State 158
		DEFAULT => -74
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'stma', 0,
sub
#line 30 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 31 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stma', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 5
		 'stmt', 1,
sub
#line 37 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 6
		 'stmt', 2,
sub
#line 38 "Farnsworth.yp"
{ bless [ $_[2] ], 'DeclareVar' }
	],
	[#Rule 7
		 'stmt', 4,
sub
#line 39 "Farnsworth.yp"
{ bless [ $_[2], $_[4] ], 'DeclareVar' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 40 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 41 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 10
		 'stmt', 3,
sub
#line 42 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 11
		 'stmt', 3,
sub
#line 43 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineCombo' }
	],
	[#Rule 12
		 'stmt', 1, undef
	],
	[#Rule 13
		 'stmt', 1, undef
	],
	[#Rule 14
		 'ifstartcond', 4,
sub
#line 48 "Farnsworth.yp"
{$_[3]}
	],
	[#Rule 15
		 'ifstmts', 3,
sub
#line 50 "Farnsworth.yp"
{$_[2]}
	],
	[#Rule 16
		 'if', 2,
sub
#line 53 "Farnsworth.yp"
{bless [@_[1,2], undef], 'If'}
	],
	[#Rule 17
		 'if', 4,
sub
#line 54 "Farnsworth.yp"
{bless [@_[1,2,4]], 'If'}
	],
	[#Rule 18
		 'while', 7,
sub
#line 62 "Farnsworth.yp"
{ bless [ @_[3,6] ], 'While' }
	],
	[#Rule 19
		 'array', 3,
sub
#line 69 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ), ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 20
		 'array', 1,
sub
#line 70 "Farnsworth.yp"
{bless [ ( ref($_[1]) eq 'Array' ? ( bless [@{$_[1]}], 'SubArray' ) : $_[1] ) ], 'Array'}
	],
	[#Rule 21
		 'array', 0,
sub
#line 71 "Farnsworth.yp"
{bless [], 'Array'}
	],
	[#Rule 22
		 'array', 2,
sub
#line 72 "Farnsworth.yp"
{bless [ undef, ref($_[2]) eq 'Array' ? @{$_[2]} : $_[2] ], 'Array' }
	],
	[#Rule 23
		 'constraint', 1, undef
	],
	[#Rule 24
		 'constraint', 1,
sub
#line 76 "Farnsworth.yp"
{bless [], 'VarArg'}
	],
	[#Rule 25
		 'argelement', 5,
sub
#line 79 "Farnsworth.yp"
{bless [ $_[1], $_[3], $_[5], 0], 'Argele'}
	],
	[#Rule 26
		 'argelement', 3,
sub
#line 80 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3], 0], 'Argele'}
	],
	[#Rule 27
		 'argelement', 3,
sub
#line 81 "Farnsworth.yp"
{bless [ $_[1], $_[3], undef, 0], 'Argele'}
	],
	[#Rule 28
		 'argelement', 1,
sub
#line 82 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 0], 'Argele'}
	],
	[#Rule 29
		 'argelement', 4,
sub
#line 83 "Farnsworth.yp"
{bless [ $_[1], undef, $_[4], 1], 'Argele'}
	],
	[#Rule 30
		 'argelement', 2,
sub
#line 84 "Farnsworth.yp"
{bless [ $_[1], undef, undef, 1], 'Argele'}
	],
	[#Rule 31
		 'argelement', 0, undef
	],
	[#Rule 32
		 'arglist', 3,
sub
#line 88 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 33
		 'arglist', 1,
sub
#line 89 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 34
		 'exprval1', 1,
sub
#line 92 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 35
		 'exprval1', 1,
sub
#line 93 "Farnsworth.yp"
{ bless [ $_[1] ], 'HexNum' }
	],
	[#Rule 36
		 'exprval2', 1,
sub
#line 97 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 37
		 'exprval2', 3,
sub
#line 98 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 38
		 'exprval', 1, undef
	],
	[#Rule 39
		 'exprval', 1, undef
	],
	[#Rule 40
		 'exprval', 1, undef
	],
	[#Rule 41
		 'assignexpr', 3,
sub
#line 106 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 42
		 'arrayfetchexpr', 4,
sub
#line 109 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'ArrayFetch' }
	],
	[#Rule 43
		 'lambda', 5,
sub
#line 112 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 44
		 'multexpr', 3,
sub
#line 115 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 45
		 'multexpr', 2,
sub
#line 116 "Farnsworth.yp"
{ bless [ @_[1,2], 'imp'], 'Mul' }
	],
	[#Rule 46
		 'multexpr', 4,
sub
#line 119 "Farnsworth.yp"
{ bless [ (bless [$_[1]], 'Fetch'), $_[3], 'imp' ], 'Mul' }
	],
	[#Rule 47
		 'multexpr', 3,
sub
#line 120 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 48
		 'expr', 1,
sub
#line 124 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 49
		 'expr', 2,
sub
#line 125 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 50
		 'expr', 1, undef
	],
	[#Rule 51
		 'expr', 3,
sub
#line 127 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 52
		 'expr', 3,
sub
#line 128 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 53
		 'expr', 3,
sub
#line 129 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 54
		 'expr', 3,
sub
#line 130 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 55
		 'expr', 3,
sub
#line 131 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 56
		 'expr', 3,
sub
#line 132 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 57
		 'expr', 3,
sub
#line 133 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 58
		 'expr', 3,
sub
#line 134 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Conforms' }
	],
	[#Rule 59
		 'expr', 5,
sub
#line 135 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 60
		 'expr', 3,
sub
#line 136 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'And' }
	],
	[#Rule 61
		 'expr', 3,
sub
#line 137 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Or' }
	],
	[#Rule 62
		 'expr', 3,
sub
#line 138 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Xor' }
	],
	[#Rule 63
		 'expr', 2,
sub
#line 139 "Farnsworth.yp"
{ bless [ $_[2] ], 'Not' }
	],
	[#Rule 64
		 'expr', 3,
sub
#line 140 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 65
		 'expr', 3,
sub
#line 141 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 66
		 'expr', 3,
sub
#line 142 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 67
		 'expr', 3,
sub
#line 143 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 68
		 'expr', 3,
sub
#line 144 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 69
		 'expr', 3,
sub
#line 145 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 70
		 'expr', 3,
sub
#line 146 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 71
		 'expr', 3,
sub
#line 147 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 72
		 'expr', 3,
sub
#line 148 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 73
		 'expr', 6,
sub
#line 149 "Farnsworth.yp"
{ bless [@_[1,3], (bless [$_[6]], 'Stmt')], 'FuncDef' }
	],
	[#Rule 74
		 'expr', 8,
sub
#line 150 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 75
		 'expr', 3,
sub
#line 151 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 76
		 'expr', 1, undef
	],
	[#Rule 77
		 'expr', 3,
sub
#line 153 "Farnsworth.yp"
{bless [@_[1,3]], 'LambdaCall'}
	],
	[#Rule 78
		 'expr', 3,
sub
#line 155 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 79
		 'expr', 1,
sub
#line 156 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 80
		 'expr', 1,
sub
#line 157 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 81
		 'expr', 1, undef
	]
],
                                  @_);
    bless($self,$class);
}

#line 160 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\n/gc and redo; #remove \n from the string, need to figure out a good way to make this count the lines later
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G\s*/\*.*?\*/\s*|gcs and redo; #skip C comments
	$s =~ m|\G\s*//.*\n?|gc and redo;
#	$s =~ s|\G/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /\G(0[xb]?[[:xdigit:]](?:[[:xdigit:].]+))/igc and return 'HEXNUMBER', $1;
	#$s =~ /\G(0b[01]+)/igc and return 'HEXNUMBER', $1; #binary
	#$s =~ /\G(0[0-7]+)/igc and return 'HEXNUMBER', $1; #octal
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;
    #$s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1; #this never happens?!?

    #token out the date
    $s =~ /\G\s*#([^#]*)#\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*"((\\.|[^"\\])*)"/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(while|conforms|else|if)\b\s*/cg and return $1;

	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /\G\s*(:=|==|!=|<=>|>=|<=|=>|->|:->|\*\*)\s*/icg and return lc $1;
	$s =~ /\G\s*(var\b|per\b|isa\b|byref\b|\:?\:\-|\=\!\=|\|\|\|)\s*/icg and return lc $1;
    $s =~ /\G\s*(\})/cg and return $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^\^?|=|;|\n|\{\s*\`|\{|\}|\>|\<|\?|\:|\,|\&\&|\|\||\!|\||\.\.\.|\`)\s*/cg and return $1;
	$s =~ /\G\s*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)\s*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yylexwatch
{
   my @r = &yylex;
   #print Dumper(\@r,[pos $s]);
   #$charcount+=pos $s;
   #$s = substr($s, pos $s);
   return @r;
}

sub yyerror
	{
	my $pos = pos $s;
	substr($fullstring,$pos,0) = '<###YYLEX###>';
	$fullstring =~ s/^/### /mg;
	die "### Syntax Error \@ $pos of\n$fullstring\n";
	}

sub parse
	{
	$charcount=0;
	my $self = shift;
	$s = join ' ', @_;
	$fullstring = $s; #preserve it for errors
	my $code = eval
		{ $self->new(yylex => \&yylexwatch, yyerror => \&yyerror)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
