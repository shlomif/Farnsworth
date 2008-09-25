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
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 6,
			'expr' => 9,
			'stma' => 3
		}
	},
	{#State 1
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			" " => 7,
			'NAME' => 12,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 5
		},
		GOTOS => {
			'expr' => 13
		}
	},
	{#State 2
		ACTIONS => {
			"[" => 19,
			":=" => 14,
			"=!=" => 15,
			"::-" => 16,
			"=" => 17,
			":-" => 18
		},
		DEFAULT => -18
	},
	{#State 3
		ACTIONS => {
			'' => 20
		}
	},
	{#State 4
		DEFAULT => -19
	},
	{#State 5
		DEFAULT => -20
	},
	{#State 6
		ACTIONS => {
			";" => 21
		},
		DEFAULT => -2
	},
	{#State 7
		DEFAULT => -48
	},
	{#State 8
		ACTIONS => {
			"-" => 1,
			"(" => 8,
			" " => 7,
			'NAME' => 12,
			'DATE' => 4,
			"[" => 10,
			'NUMBER' => 11,
			'STRING' => 5
		},
		GOTOS => {
			'expr' => 22
		}
	},
	{#State 9
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			":->" => 34,
			"!=" => 35,
			"|||" => 36,
			"?" => 37,
			"/" => 39,
			"->" => 38,
			"<=>" => 41,
			"<=" => 40,
			">" => 42
		},
		DEFAULT => -4
	},
	{#State 10
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 43,
			'expr' => 44
		}
	},
	{#State 11
		DEFAULT => -17
	},
	{#State 12
		ACTIONS => {
			"[" => 19,
			"::-" => 16,
			"=" => 17,
			":-" => 18
		},
		DEFAULT => -18
	},
	{#State 13
		ACTIONS => {
			"**" => 25,
			"%" => 27,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"/" => 39
		},
		DEFAULT => -21
	},
	{#State 14
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 45
		}
	},
	{#State 15
		ACTIONS => {
			'NAME' => 46
		}
	},
	{#State 16
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 47
		}
	},
	{#State 17
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 48
		}
	},
	{#State 18
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 49
		}
	},
	{#State 19
		ACTIONS => {
			"-" => 1,
			'NAME' => 52,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'arglist' => 53,
			'array' => 51,
			'expr' => 44,
			'argelement' => 50
		}
	},
	{#State 20
		DEFAULT => 0
	},
	{#State 21
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			'STRING' => 5,
			"(" => 8,
			" " => 7,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 6,
			'stma' => 54,
			'expr' => 9
		}
	},
	{#State 22
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			")" => 55,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		}
	},
	{#State 23
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 56
		}
	},
	{#State 24
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 57
		}
	},
	{#State 25
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 58
		}
	},
	{#State 26
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 59
		}
	},
	{#State 27
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 60
		}
	},
	{#State 28
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 61
		}
	},
	{#State 29
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 62
		}
	},
	{#State 30
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 63
		}
	},
	{#State 31
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 64
		}
	},
	{#State 32
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 65
		}
	},
	{#State 33
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 66
		}
	},
	{#State 34
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 67
		}
	},
	{#State 35
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 68
		}
	},
	{#State 36
		ACTIONS => {
			'NAME' => 69
		}
	},
	{#State 37
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 70
		}
	},
	{#State 38
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 71
		}
	},
	{#State 39
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 72
		}
	},
	{#State 40
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 73
		}
	},
	{#State 41
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 74
		}
	},
	{#State 42
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 75
		}
	},
	{#State 43
		ACTIONS => {
			"]" => 76
		}
	},
	{#State 44
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"," => 77,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"/" => 39,
			"->" => 38,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -10
	},
	{#State 45
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -5
	},
	{#State 46
		DEFAULT => -7
	},
	{#State 47
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -40
	},
	{#State 48
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -22
	},
	{#State 49
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -41
	},
	{#State 50
		ACTIONS => {
			"," => 78
		},
		DEFAULT => -16
	},
	{#State 51
		ACTIONS => {
			"]" => 79
		}
	},
	{#State 52
		ACTIONS => {
			"," => -14,
			"[" => 19,
			"]" => -14,
			"::-" => 16,
			"=" => 80,
			"isa" => 81,
			":-" => 18
		},
		DEFAULT => -18
	},
	{#State 53
		ACTIONS => {
			"]" => 82
		}
	},
	{#State 54
		DEFAULT => -3
	},
	{#State 55
		DEFAULT => -46
	},
	{#State 56
		ACTIONS => {
			"**" => 25,
			"%" => 27,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"/" => 39
		},
		DEFAULT => -24
	},
	{#State 57
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -33
	},
	{#State 58
		DEFAULT => -31
	},
	{#State 59
		ACTIONS => {
			"**" => 25,
			"%" => 27,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"/" => 39
		},
		DEFAULT => -23
	},
	{#State 60
		ACTIONS => {
			"**" => 25,
			"^" => 30
		},
		DEFAULT => -29
	},
	{#State 61
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -37
	},
	{#State 62
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -36
	},
	{#State 63
		DEFAULT => -30
	},
	{#State 64
		ACTIONS => {
			"**" => 25,
			"^" => 30
		},
		DEFAULT => -25
	},
	{#State 65
		ACTIONS => {
			"**" => 25,
			"^" => 30
		},
		DEFAULT => -26
	},
	{#State 66
		ACTIONS => {
			"**" => 25,
			"%" => 27,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"/" => 39
		},
		DEFAULT => -28
	},
	{#State 67
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -6
	},
	{#State 68
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -39
	},
	{#State 69
		DEFAULT => -8
	},
	{#State 70
		ACTIONS => {
			":" => 83,
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		}
	},
	{#State 71
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -47
	},
	{#State 72
		ACTIONS => {
			"**" => 25,
			"^" => 30
		},
		DEFAULT => -27
	},
	{#State 73
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -35
	},
	{#State 74
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -38
	},
	{#State 75
		ACTIONS => {
			"-" => 23,
			"<" => undef,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => undef,
			">=" => undef,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => undef,
			"/" => 39,
			"<=" => undef,
			"<=>" => undef,
			">" => undef
		},
		DEFAULT => -34
	},
	{#State 76
		DEFAULT => -45
	},
	{#State 77
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'array' => 84,
			'expr' => 44
		}
	},
	{#State 78
		ACTIONS => {
			'NAME' => 85
		},
		GOTOS => {
			'arglist' => 86,
			'argelement' => 50
		}
	},
	{#State 79
		DEFAULT => -44
	},
	{#State 80
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 87
		}
	},
	{#State 81
		ACTIONS => {
			'NAME' => 88
		}
	},
	{#State 82
		ACTIONS => {
			":=" => 89
		}
	},
	{#State 83
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 90
		}
	},
	{#State 84
		DEFAULT => -9
	},
	{#State 85
		ACTIONS => {
			"isa" => 81,
			"=" => 91
		},
		DEFAULT => -14
	},
	{#State 86
		DEFAULT => -15
	},
	{#State 87
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -13
	},
	{#State 88
		ACTIONS => {
			"=" => 92
		},
		DEFAULT => -12
	},
	{#State 89
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			"{" => 94,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 93
		}
	},
	{#State 90
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -32
	},
	{#State 91
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 95
		}
	},
	{#State 92
		ACTIONS => {
			"-" => 1,
			'NAME' => 12,
			'DATE' => 4,
			'STRING' => 5,
			" " => 7,
			"(" => 8,
			"[" => 10,
			'NUMBER' => 11
		},
		GOTOS => {
			'expr' => 96
		}
	},
	{#State 93
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -42
	},
	{#State 94
		ACTIONS => {
			"-" => 1,
			'NAME' => 2,
			'DATE' => 4,
			'STRING' => 5,
			"(" => 8,
			" " => 7,
			"[" => 10,
			'NUMBER' => 11
		},
		DEFAULT => -1,
		GOTOS => {
			'stmt' => 6,
			'stma' => 97,
			'expr' => 9
		}
	},
	{#State 95
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -13
	},
	{#State 96
		ACTIONS => {
			"-" => 23,
			"<" => 24,
			"+" => 26,
			"**" => 25,
			"%" => 27,
			"==" => 28,
			">=" => 29,
			"^" => 30,
			" " => 31,
			"*" => 32,
			"per" => 33,
			"!=" => 35,
			"?" => 37,
			"->" => 38,
			"/" => 39,
			"<=" => 40,
			"<=>" => 41,
			">" => 42
		},
		DEFAULT => -11
	},
	{#State 97
		ACTIONS => {
			"}" => 98
		}
	},
	{#State 98
		DEFAULT => -43
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
{ bless [ @_[1,3] ], 'SetDisplay' }
	],
	[#Rule 7
		 'stmt', 3,
sub
#line 31 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'DefineDimen' }
	],
	[#Rule 8
		 'stmt', 3,
sub
#line 32 "Farnsworth.yp"
{ bless [ @_[3,1] ], 'DefineCombo' }
	],
	[#Rule 9
		 'array', 3,
sub
#line 45 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Array' ? @{$_[3]} : $_[3] ], 'Array' }
	],
	[#Rule 10
		 'array', 1,
sub
#line 46 "Farnsworth.yp"
{ bless [ $_[1]], 'Array'}
	],
	[#Rule 11
		 'argelement', 5,
sub
#line 49 "Farnsworth.yp"
{bless [$_[1], $_[5], $_[3]], 'Argele'}
	],
	[#Rule 12
		 'argelement', 3,
sub
#line 50 "Farnsworth.yp"
{bless [ $_[1], undef, $_[3] ], 'Argele'}
	],
	[#Rule 13
		 'argelement', 3,
sub
#line 51 "Farnsworth.yp"
{bless [$_[1], $_[3]], 'Argele'}
	],
	[#Rule 14
		 'argelement', 1,
sub
#line 52 "Farnsworth.yp"
{bless [ $_[1] ], 'Argele'}
	],
	[#Rule 15
		 'arglist', 3,
sub
#line 55 "Farnsworth.yp"
{ bless [ $_[1], ref($_[3]) eq 'Arglist' ? @{$_[3]} : $_[3] ], 'Arglist' }
	],
	[#Rule 16
		 'arglist', 1,
sub
#line 56 "Farnsworth.yp"
{bless [ $_[1] ], 'Arglist'}
	],
	[#Rule 17
		 'expr', 1,
sub
#line 60 "Farnsworth.yp"
{ bless [ $_[1] ], 'Num' }
	],
	[#Rule 18
		 'expr', 1,
sub
#line 61 "Farnsworth.yp"
{ bless [ $_[1] ], 'Fetch' }
	],
	[#Rule 19
		 'expr', 1,
sub
#line 62 "Farnsworth.yp"
{ bless [ $_[1] ], 'Date' }
	],
	[#Rule 20
		 'expr', 1,
sub
#line 63 "Farnsworth.yp"
{ bless [ $_[1] ], 'String' }
	],
	[#Rule 21
		 'expr', 2,
sub
#line 64 "Farnsworth.yp"
{ bless [ $_[2] , (bless ['-1'], 'Num'), '-name'], 'Mul' }
	],
	[#Rule 22
		 'expr', 3,
sub
#line 65 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Store' }
	],
	[#Rule 23
		 'expr', 3,
sub
#line 67 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Add' }
	],
	[#Rule 24
		 'expr', 3,
sub
#line 68 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Sub' }
	],
	[#Rule 25
		 'expr', 3,
sub
#line 69 "Farnsworth.yp"
{ bless [ @_[1,3], ' '], 'Mul' }
	],
	[#Rule 26
		 'expr', 3,
sub
#line 70 "Farnsworth.yp"
{ bless [ @_[1,3], '*'], 'Mul' }
	],
	[#Rule 27
		 'expr', 3,
sub
#line 71 "Farnsworth.yp"
{ bless [ @_[1,3], '/'], 'Div' }
	],
	[#Rule 28
		 'expr', 3,
sub
#line 72 "Farnsworth.yp"
{ bless [ @_[1,3], 'per' ], 'Div' }
	],
	[#Rule 29
		 'expr', 3,
sub
#line 73 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Mod' }
	],
	[#Rule 30
		 'expr', 3,
sub
#line 74 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 31
		 'expr', 3,
sub
#line 75 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Pow' }
	],
	[#Rule 32
		 'expr', 5,
sub
#line 76 "Farnsworth.yp"
{ bless [@_[1,3,5]], 'Ternary' }
	],
	[#Rule 33
		 'expr', 3,
sub
#line 77 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Lt' }
	],
	[#Rule 34
		 'expr', 3,
sub
#line 78 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Gt' }
	],
	[#Rule 35
		 'expr', 3,
sub
#line 79 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Le' }
	],
	[#Rule 36
		 'expr', 3,
sub
#line 80 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ge' }
	],
	[#Rule 37
		 'expr', 3,
sub
#line 81 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Eq' }
	],
	[#Rule 38
		 'expr', 3,
sub
#line 82 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Compare' }
	],
	[#Rule 39
		 'expr', 3,
sub
#line 83 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'Ne' }
	],
	[#Rule 40
		 'expr', 3,
sub
#line 84 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefix' }
	],
	[#Rule 41
		 'expr', 3,
sub
#line 85 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'SetPrefixAbrv' }
	],
	[#Rule 42
		 'expr', 6,
sub
#line 86 "Farnsworth.yp"
{ bless [@_[1,3,6]], 'FuncDef' }
	],
	[#Rule 43
		 'expr', 8,
sub
#line 87 "Farnsworth.yp"
{ bless [@_[1,3,7]], 'FuncDef' }
	],
	[#Rule 44
		 'expr', 4,
sub
#line 88 "Farnsworth.yp"
{ bless [ @_[1,3] ], 'FuncCall' }
	],
	[#Rule 45
		 'expr', 3,
sub
#line 89 "Farnsworth.yp"
{ $_[2] }
	],
	[#Rule 46
		 'expr', 3,
sub
#line 90 "Farnsworth.yp"
{ bless [$_[2]], 'Paren' }
	],
	[#Rule 47
		 'expr', 3,
sub
#line 93 "Farnsworth.yp"
{ bless [ @_[1,3]], 'Trans' }
	],
	[#Rule 48
		 'expr', 1,
sub
#line 94 "Farnsworth.yp"
{undef}
	]
],
                                  @_);
    bless($self,$class);
}

#line 97 "Farnsworth.yp"


sub yylex
	{
	#i THINK this isn't what i want, since whitespace is significant in a few areas
	#i'm going to instead shrink all whitespace down to no more than one space
	#$s =~ s/\G\s{2,}/ /c; #don't need global?
	$s =~ /\G\s*(?=\s)/gc;
		
	#1 while $s =~ /\G\s+/cg; #remove extra whitespace?

	$s =~ m|\G/\*.*?\*/|gcs and redo; #skip C comments
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
