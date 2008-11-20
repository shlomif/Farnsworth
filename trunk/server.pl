#!/usr/bin/perl
#!/home/ryan/userperl/perl5.8/bin/perl

use lib './lib';

use strict;
use warnings;
use Data::Dumper;
use URI::Escape;

use POE::Component::Server::HTTP;
use POE::Component::Server::TCP;
use HTTP::Status;
use POE;
use Encode;

use Math::Farnsworth;

use utf8;

my $farnsworth = new Math::Farnsworth;
$farnsworth->runFile("startups/startup.frns");
#$farnsworth->runFile("startups/combodefaults.frns");
print "DONE STARTING UP!\n";

my $aliases = POE::Component::Server::HTTP->new(
  Port => 8080,
  ContentHandler => {"/", \&runfarnsworth},
	Headers => { Server => "Farnsworth Server 1.2" },
  );

my $tcpserv = POE::Component::Server::TCP->new(
Port => 8081, 
ClientConnected =>
sub {
  print "HEARTBEAT\n";
  $_[HEAP]{client}->put("HEART");
},
ClientInput => sub {print "Dummy\n";}
);

sub runfarnsworth
{
  my ($request, $response) = @_;
  $response->code(RC_OK);
  my $string = "".(uri_unescape $request->uri);
  $string =~ s|^http://[^/]+/||;
  $string = decode("UTF-8", $string);

  print "INPUT: $string\n\n\n\n";
  my $output;
  print "Running\n";

	  my $oa = $SIG{ALRM};
    my $oat = alarm(0);
    $SIG{ALRM} = sub {die "Timeout!"};
    alarm(25);

  my $out = eval 
	{
		my $ret=($farnsworth->runString($string));
    $ret;
  };

    alarm(0);
    $SIG{ALRM} = $oa;
    alarm($oat);

	if ($@)
    {
	  	$output = $@;
    }
    elsif (ref($out) eq "Math::Farnsworth::Output")
    {
      $output = "".$out;
    }
    elsif (!defined($out))
    {
      $output = "Undefined || OK";
    }
    elsif (ref($out) eq "")
    {
      $output = $out;
    }
    else
    {
      $output = "BUG! +- ".ref($out)." -+ ".Dumper($out);
    }

	if (!defined($output) || $output eq "")
	{
		$output = "Got back Empty string for outpt, this is a bug\n";
	}
  print "Done Running : $output\n";

  $response->add_content_utf8(" ".$output);
  return RC_OK;
}

POE::Kernel->run();
