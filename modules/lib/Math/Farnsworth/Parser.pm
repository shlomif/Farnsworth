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
use Parse::Yapp::Driver;

#line 11 "Farnsworth.yp"

use Data::Dumper; #boobs
use Text::Balanced qw(extract_delimited);
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
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			'STRING' => 6,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'expr' => 9,
			'stma' => 3,
			'exprval' => 5
		}
	},
	{#State 1
		ACTIONS => {
			"(" => 8,
			'NAME' => 12,
			'NUMBER' => 11
		},
		GOTOS => {
			'exprval' => 13
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 20,
			"::-" => 17,
			":=" => 14,
			"=!=" => 16,
			"{" => 15,
			"=" => 18,
			":-" => 19
		},
		DEFAULT => -19
	},
	{#State 3
		ACTIONS => {
			'' => 21
		}
	},
	{#State 4
		DEFAULT => -48
	},
	{#State 5
		ACTIONS => {
			" " => 23,
			'NUMBER' => 11,
			'NAME' => 12,
			"(" => 8
		},
		DEFAULT => -21,
		GOTOS => {
			'exprval' => 22
		}
	},
	{#State 6
		DEFAULT => -49
	},
	{#State 7
		ACTIONS => {
			";" => 24
		},
		DEFAULT => -2
	},
	{#State 8
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 26,
			'exprval' => 5
		}
	},
	{#State 9
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			":->" => 37,
			"!=" => 38,
			"|||" => 39,
			"?" => 40,
			"/" => 42,
			"->" => 41,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -4
	},
	{#State 10
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'array' => 46,
			'expr' => 47,
			'exprval' => 5
		}
	},
	{#State 11
		DEFAULT => -18
	},
	{#State 12
		DEFAULT => -19
	},
	{#State 13
		DEFAULT => -22
	},
	{#State 14
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 48,
			'exprval' => 5
		}
	},
	{#State 15
		ACTIONS => {
			'NAME' => 50
		},
		GOTOS => {
			'arglist' => 51,
			'argelement' => 49
		}
	},
	{#State 16
		ACTIONS => {
			'NAME' => 52
		}
	},
	{#State 17
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 53,
			'exprval' => 5
		}
	},
	{#State 18
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 54,
			'exprval' => 5
		}
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 55,
			'exprval' => 5
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'array' => 56,
			'expr' => 47,
			'exprval' => 5
		}
	},
	{#State 21
		DEFAULT => 0
	},
	{#State 22
		DEFAULT => -23
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 57,
			'exprval' => 5
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			'STRING' => 6,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 58,
			'expr' => 9,
			'exprval' => 5
		}
	},
	{#State 25
		ACTIONS => {
			"[" => 20,
			"::-" => 17,
			"{" => 15,
			":-" => 19
		},
		DEFAULT => -19
	},
	{#State 26
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			")" => 59,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 60,
			'exprval' => 5
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 61,
			'exprval' => 5
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 62,
			'exprval' => 5
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 63,
			'exprval' => 5
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 64,
			'exprval' => 5
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 65,
			'exprval' => 5
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 66,
			'exprval' => 5
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 67,
			'exprval' => 5
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 68,
			'exprval' => 5
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 69,
			'exprval' => 5
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 70,
			'exprval' => 5
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 71,
			'exprval' => 5
		}
	},
	{#State 39
		ACTIONS => {
			'NAME' => 72
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 73,
			'exprval' => 5
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 74,
			'exprval' => 5
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 75,
			'exprval' => 5
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 76,
			'exprval' => 5
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 77,
			'exprval' => 5
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 78,
			'exprval' => 5
		}
	},
	{#State 46
		ACTIONS => {
			"]" => 79
		}
	},
	{#State 47
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"," => 80,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=" => 43,
			"<=>" => 44,
			">" => 45
		},
		DEFAULT => -11
	},
	{#State 48
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -5
	},
	{#State 49
		ACTIONS => {
			"," => 81
		},
		DEFAULT => -17
	},
	{#State 50
		ACTIONS => {
			"isa" => 83,
			"=" => 82
		},
		DEFAULT => -15
	},
	{#State 51
		ACTIONS => {
			"}" => 84
		}
	},
	{#State 52
		DEFAULT => -8
	},
	{#State 53
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -41
	},
	{#State 54
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -6
	},
	{#State 55
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -42
	},
	{#State 56
		ACTIONS => {
			"]" => 85
		}
	},
	{#State 57
		ACTIONS => {
			"**" => 29,
			"^" => 34
		},
		DEFAULT => -24
	},
	{#State 58
		DEFAULT => -3
	},
	{#State 59
		DEFAULT => -20
	},
	{#State 60
		ACTIONS => {
			"**" => 29,
			"%" => 31,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"/" => 42
		},
		DEFAULT => -26
	},
	{#State 61
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -34
	},
	{#State 62
		DEFAULT => -32
	},
	{#State 63
		ACTIONS => {
			"**" => 29,
			"%" => 31,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"/" => 42
		},
		DEFAULT => -25
	},
	{#State 64
		ACTIONS => {
			"**" => 29,
			"^" => 34
		},
		DEFAULT => -30
	},
	{#State 65
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 66
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 67
		DEFAULT => -31
	},
	{#State 68
		ACTIONS => {
			"**" => 29,
			"^" => 34
		},
		DEFAULT => -27
	},
	{#State 69
		ACTIONS => {
			"**" => 29,
			"%" => 31,
			"^" => 34,
			"*" => 35,
			"/" => 42
		},
		DEFAULT => -29
	},
	{#State 70
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -7
	},
	{#State 71
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 72
		DEFAULT => -9
	},
	{#State 73
		ACTIONS => {
			":" => 86,
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		}
	},
	{#State 74
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -47
	},
	{#State 75
		ACTIONS => {
			"**" => 29,
			"^" => 34
		},
		DEFAULT => -28
	},
	{#State 76
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 77
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 78
		ACTIONS => {
			"-" => 27,
			"<" => undef,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => undef,
			">=" => undef,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => undef,
			"/" => 42,
			"<=>" => undef,
			"<=" => undef,
			">" => undef
		},
		DEFAULT => -35
	},
	{#State 79
		DEFAULT => -46
	},
	{#State 80
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'array' => 87,
			'expr' => 47,
			'exprval' => 5
		}
	},
	{#State 81
		ACTIONS => {
			'NAME' => 50
		},
		GOTOS => {
			'arglist' => 88,
			'argelement' => 49
		}
	},
	{#State 82
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 89,
			'exprval' => 5
		}
	},
	{#State 83
		ACTIONS => {
			'NAME' => 90
		}
	},
	{#State 84
		ACTIONS => {
			":=" => 91
		}
	},
	{#State 85
		DEFAULT => -45
	},
	{#State 86
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 92,
			'exprval' => 5
		}
	},
	{#State 87
		DEFAULT => -10
	},
	{#State 88
		DEFAULT => -16
	},
	{#State 89
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -14
	},
	{#State 90
		ACTIONS => {
			"=" => 93
		},
		DEFAULT => -13
	},
	{#State 91
		ACTIONS => {
			"-" => 1,
			'NAME' => 25,
			'DATE' => 4,
			"{" => 95,
			'STRING' => 6,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 94,
			'exprval' => 5
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -33
	},
	{#State 93
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			'NAME' => 25,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 96,
			'exprval' => 5
		}
	},
	{#State 94
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -43
	},
	{#State 95
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			'STRING' => 6,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 97,
			'expr' => 9,
			'exprval' => 5
		}
	},
	{#State 96
		ACTIONS => {
			"-" => 27,
			"<" => 28,
			"+" => 30,
			"**" => 29,
			"%" => 31,
			"==" => 32,
			">=" => 33,
			"^" => 34,
			"*" => 35,
			"per" => 36,
			"!=" => 38,
			"?" => 40,
			"->" => 41,
			"/" => 42,
			"<=>" => 44,
			"<=" => 43,
			">" => 45
		},
		DEFAULT => -12
	},
	{#State 97
		ACTIONS => {
			"}" => 98
		}
	},
	{#State 98
		DEFAULT => -44
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
#line 22 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 23 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 24 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 28 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 3,
sub
#line 29 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 6
		 'stmt', 3,
sub
#line 30 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 31 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 9
		 'stmt', 3,
sub
#line 33 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 10
		 'array', 3,
sub
#line 46 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 11
		 'array', 1,
sub
#line 47 "Farnsworth.yp"
{ bless [ $_[1]], 'Array'}
	],
	[#Rule 12
		 'argelement', 5,
sub
#line 50 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 13
		 'argelement', 3,
sub
#line 51 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 14
		 'argelement', 3,
sub
#line 52 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 15
		 'argelement', 1,
sub
#line 53 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 16
		 'arglist', 3,
sub
#line 56 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 17
		 'arglist', 1,
sub
#line 57 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 18
		 'exprval', 1,
sub
#line 60 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 19
		 'exprval', 1,
sub
#line 61 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 20
		 'exprval', 3,
sub
#line 62 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 21
		 'expr', 1,
sub
#line 67 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 22
		 'expr', 2,
sub
#line 68 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 23
		 'expr', 2,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,2], ''], 'Mul' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3], ''], 'Mul' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 33
		 'expr', 5,
sub
#line 81 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 86 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 87 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 88 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 89 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 42
		 'expr', 3,
sub
#line 90 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 43
		 'expr', 6,
sub
#line 91 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 44
		 'expr', 8,
sub
#line 92 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 45
		 'expr', 4,
sub
#line 93 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 94 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 97 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 48
		 'expr', 1,
sub
#line 99 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 49
		 'expr', 1,
sub
#line 100 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	]
],
                                  @_);
    bless($self,$class);
}

#line 103 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G\s*/\*.*?\*/|gcs and redo; #skip C comments
#	$s =~ s|\G//.*||g;
#	$s =~ s|\G/\*.*?\*/||g;

    #i want a complete number regex
	$s =~ /\G((\d+(\.\d*)?|\.\d+)([Ee][Ee]?[-+]?\d+))/gc 
	      and return 'NUMBER', $1;
	$s =~ /\G((\d+(\.\d*)?|\.\d+))/gc 
	      and return 'NUMBER', $1;
    $s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1;

    #token out the date
    $s =~ /\G\s*(#[^#]*#)\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*("(\\.|[^"])*")/gc #" bad syntax highlighters are annoying
		and return "STRING", $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	#seperated this to shorten the lines, and hopefully to make parts of it more readable
	$s =~ /\G\s*(:=|==|!=|<=>|>=|<=|->|:->|\*\*)\s*/icg and return lc $1;
	$s =~ /\G\s*(\bper\b|\bisa\b|\:?\:\-|\=\!\=|\|\|\|)\s*/icg and return lc $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^|=|;|\{|\}|\>|\<|\?|\:|\,)\s*/cg and return $1;
	$s =~ /\G\s*(\)|\])/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\(|\[)\s*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yylexwatch
{
   my @r = &yylex;
   print Dumper(\@r,[pos $s]);
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
