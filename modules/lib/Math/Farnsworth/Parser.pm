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

#line 12 "Farnsworth.yp"

use Data::Dumper; #boobs
my $s;		# warning - not re-entrant
my $lasttype;


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
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'expr' => 10,
			'stma' => 3
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			" " => 8,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 14
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 17,
			":=" => 15,
			"=" => 16
		},
		DEFAULT => -18
	},
	{#State 3
		ACTIONS => {
			'' => 18
		}
	},
	{#State 4
		DEFAULT => -19
	},
	{#State 5
		ACTIONS => {
			"|" => 19
		}
	},
	{#State 6
		DEFAULT => -20
	},
	{#State 7
		ACTIONS => {
			";" => 20
		},
		DEFAULT => -2
	},
	{#State 8
		DEFAULT => -46
	},
	{#State 9
		ACTIONS => {
			"-" => 1,
			"(" => 9,
			" " => 8,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			"[" => 11,
			'NUMBER' => 12,
			'STRING' => 6
		},
		GOTOS => {
			'expr' => 21
		}
	},
	{#State 10
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			":->" => 33,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=>" => 39,
			"<=" => 38,
			">" => 40
		},
		DEFAULT => -4
	},
	{#State 11
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 41,
			'expr' => 42
		}
	},
	{#State 12
		ACTIONS => {
			'NAME' => 43
		},
		DEFAULT => -17
	},
	{#State 13
		ACTIONS => {
			"[" => 44,
			"=" => 16
		},
		DEFAULT => -18
	},
	{#State 14
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -21
	},
	{#State 15
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 45
		}
	},
	{#State 16
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 46
		}
	},
	{#State 17
		ACTIONS => {
			"-" => 1,
			'NAME' => 49,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'arglist' => 50,
			'array' => 48,
			'expr' => 42,
			'argelement' => 47
		}
	},
	{#State 18
		DEFAULT => 0
	},
	{#State 19
		ACTIONS => {
			'NAME' => 51
		},
		GOTOS => {
			'arglist' => 52,
			'argelement' => 47
		}
	},
	{#State 20
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			"(" => 9,
			" " => 8,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 53,
			'expr' => 10
		}
	},
	{#State 21
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			")" => 54,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 55
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 56
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 57
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 58
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 59
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 60
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 61
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 62
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 63
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 64
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 65
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 66
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 67
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 68
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 69
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 70
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 71
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 72
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 73
		}
	},
	{#State 41
		ACTIONS => {
			"]" => 74
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"," => 75,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"->" => 36,
			"/" => 37,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -10
	},
	{#State 43
		DEFAULT => -23
	},
	{#State 44
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 48,
			'expr' => 42
		}
	},
	{#State 45
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -7
	},
	{#State 46
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -22
	},
	{#State 47
		ACTIONS => {
			"," => 76
		},
		DEFAULT => -16
	},
	{#State 48
		ACTIONS => {
			"]" => 77
		}
	},
	{#State 49
		ACTIONS => {
			"," => -14,
			"[" => 44,
			"]" => -14,
			"=" => 78,
			"isa" => 79
		},
		DEFAULT => -18
	},
	{#State 50
		ACTIONS => {
			"]" => 80
		}
	},
	{#State 51
		ACTIONS => {
			"isa" => 79,
			"=" => 81
		},
		DEFAULT => -14
	},
	{#State 52
		ACTIONS => {
			"|" => 82
		}
	},
	{#State 53
		DEFAULT => -3
	},
	{#State 54
		DEFAULT => -44
	},
	{#State 55
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -26
	},
	{#State 56
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -34
	},
	{#State 57
		DEFAULT => -33
	},
	{#State 58
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"/" => 37
		},
		DEFAULT => -25
	},
	{#State 59
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -31
	},
	{#State 60
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 61
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 62
		DEFAULT => -32
	},
	{#State 63
		ACTIONS => {
			"**" => 24,
			"^" => 29
		},
		DEFAULT => -27
	},
	{#State 64
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -28
	},
	{#State 65
		ACTIONS => {
			"**" => 24,
			"%" => 26,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"/" => 37
		},
		DEFAULT => -30
	},
	{#State 66
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -8
	},
	{#State 67
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -40
	},
	{#State 68
		ACTIONS => {
			":" => 83,
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		}
	},
	{#State 69
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -24
	},
	{#State 70
		ACTIONS => {
			"**" => 24,
			"^" => 29,
			" " => 30
		},
		DEFAULT => -29
	},
	{#State 71
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 72
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 73
		ACTIONS => {
			"-" => 22,
			"<" => undef,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => undef,
			">=" => undef,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => undef,
			"/" => 37,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -35
	},
	{#State 74
		DEFAULT => -43
	},
	{#State 75
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'array' => 84,
			'expr' => 42
		}
	},
	{#State 76
		ACTIONS => {
			'NAME' => 51
		},
		GOTOS => {
			'arglist' => 85,
			'argelement' => 47
		}
	},
	{#State 77
		DEFAULT => -42
	},
	{#State 78
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 86
		}
	},
	{#State 79
		ACTIONS => {
			'NAME' => 87
		}
	},
	{#State 80
		ACTIONS => {
			":=" => 88
		}
	},
	{#State 81
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 89
		}
	},
	{#State 82
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 90
		}
	},
	{#State 83
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 91
		}
	},
	{#State 84
		DEFAULT => -9
	},
	{#State 85
		DEFAULT => -15
	},
	{#State 86
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -13
	},
	{#State 87
		ACTIONS => {
			"=" => 92
		},
		DEFAULT => -12
	},
	{#State 88
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 94,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 93
		}
	},
	{#State 89
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -13
	},
	{#State 90
		ACTIONS => {
			"}" => 95,
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		}
	},
	{#State 91
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -41
	},
	{#State 92
		ACTIONS => {
			"-" => 1,
			'NAME' => 13,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			" " => 8,
			"(" => 9,
			"[" => 11,
			'NUMBER' => 12
		},
		GOTOS => {
			'expr' => 96
		}
	},
	{#State 93
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -5
	},
	{#State 94
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			"{" => 5,
			'STRING' => 6,
			"|" => 19,
			"(" => 9,
			" " => 8,
			"[" => 11,
			'NUMBER' => 12
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 7,
			'stma' => 97,
			'expr' => 10
		}
	},
	{#State 95
		DEFAULT => -45
	},
	{#State 96
		ACTIONS => {
			"-" => 22,
			"<" => 23,
			"+" => 25,
			"**" => 24,
			"%" => 26,
			"==" => 27,
			">=" => 28,
			"^" => 29,
			" " => 30,
			"*" => 31,
			"per" => 32,
			"!=" => 34,
			"?" => 35,
			"/" => 37,
			"->" => 36,
			"<=" => 38,
			"<=>" => 39,
			">" => 40
		},
		DEFAULT => -11
	},
	{#State 97
		ACTIONS => {
			"}" => 98
		}
	},
	{#State 98
		DEFAULT => -6
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
#line 21 "Farnsworth.yp"
{undef}
	],
	[#Rule 2
		 'stma', 1,
sub
#line 22 "Farnsworth.yp"
{ bless [ $_[1] ], 'Stmt' }
	],
	[#Rule 3
		 'stma', 3,
sub
#line 23 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq "Stmt" ? @{$_[3]} : $_[3]], 'Stmt' }
	],
	[#Rule 4
		 'stmt', 1,
sub
#line 27 "Farnsworth.yp"
{ $_[1] }
	],
	[#Rule 5
		 'stmt', 6,
sub
#line 28 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 6
		 'stmt', 8,
sub
#line 29 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 30 "Farnsworth.yp"
{ bless [@_[1,3]], 'UnitDef' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 31 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 9
		 'array', 3,
sub
#line 44 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 10
		 'array', 1,
sub
#line 45 "Farnsworth.yp"
{ bless [ $_[1]], 'Array'}
	],
	[#Rule 11
		 'argelement', 5,
sub
#line 48 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 12
		 'argelement', 3,
sub
#line 49 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 13
		 'argelement', 3,
sub
#line 50 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 14
		 'argelement', 1,
sub
#line 51 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 15
		 'arglist', 3,
sub
#line 54 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 16
		 'arglist', 1,
sub
#line 55 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 17
		 'expr', 1,
sub
#line 59 "Farnsworth.yp"
{ bless [ $_[1] ],   'Num' }
	],
	[#Rule 18
		 'expr', 1,
sub
#line 60 "Farnsworth.yp"
{ bless [ $_[1] ],   'Fetch' }
	],
	[#Rule 19
		 'expr', 1,
sub
#line 61 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 20
		 'expr', 1,
sub
#line 62 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 21
		 'expr', 2,
sub
#line 63 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 22
		 'expr', 3,
sub
#line 64 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 23
		 'expr', 2,
sub
#line 65 "Farnsworth.yp"
{ bless [ $_[1], (bless [ $_[2] ], 'Fetch' )], 'Mul' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 66 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 69 "Farnsworth.yp"
{ bless [ @_[1,3], ' '], 'Mul' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 32
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 76 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 41
		 'expr', 5,
sub
#line 83 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 42
		 'expr', 4,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 43
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 44
		 'expr', 3,
sub
#line 86 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 45
		 'expr', 6,
sub
#line 87 "Farnsworth.yp"
{bless [ @_[2,4] ], 'Lambda'}
	],
	[#Rule 46
		 'expr', 1,
sub
#line 88 "Farnsworth.yp"
{undef}
	]
],
                                  @_);
    bless($self,$class);
}

#line 90 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	$s =~ s/\G\s{2,}/ /c; #don't need global?
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

    #i want a complete number regex
	$s =~ /\G(\+?(\d+(\.\d*)?|\.\d+)([Ee][-+]?\d+)?)/gc 
	      and return 'NUMBER', $1;
    $s =~ /\G(0[xX][0-9A-Fa-f])/gc and return $1;

    #token out the date
    $s =~ /\G\s*(#[^#]*#)\s*/gc and return 'DATE', $1;

    $s =~ /\G\s*("(\\"|[^"])*")\s*/gc and return 'STRING', $1;

    #i'll probably ressurect this later too
	#$s =~ /\G(do|for|elsif|else|if|print|while)\b/cg and return $1;
	
	$s =~ /\G\s*(:=|==|!=|>=|<=|->|:->|\*\*|per|isa)\s*/icg and return lc $1;
	$s =~ /\G\s*(\+|\*|-|\/|\%|\^|=|;|\{|\}|\>|\<|\?|\:)\s*/cg and return $1;
	$s =~ /\G\s*(\))/cg and return $1; #freaking quirky lexers!
	$s =~ /\G(\()\s*/cg and return $1;
	$s =~ /\G(\w[\w\d]*)/cg and return 'NAME', $1; #i need to handle -NAME later on when evaluating, or figure out a sane way to do it here
	$s =~ /\G\/\/.*/cg and return ''; #return nothing for C style comments
	$s =~ /\G(.)/cgs and return $1;
    return '';
	}


sub yyerror
	{
	my $pos = pos $s;
	substr($s,$pos,0) = '<###YYLEX###>';
	$s =~ s/^/### /mg;
	die "### Syntax Error \@ $pos of\n$s\n";
	}

sub parse
	{
	$lasttype=0;
	my $self = shift;
	$s = join ' ', @_;
	my $code = eval
		{ $self->new(yylex => \&yylex, yyerror => \&yyerror, yydebug => 0x1F)->YYParse };
	die $@ if $@;
	$code
	}

1;

# vim: filetype=yacc

1;
