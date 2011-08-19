# 

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use utf8;

my $app = sub {
	my $req = Plack::Request->new(shift);
	
	# log
	$req->logger->( { level => 'debug', message => "This is a debug message" } );
	
	$req->logger->( { level => 'critical', message => "Boooomb!" } );
	
	my $res = Plack::Response->new(200);
	$res->content_type("text/html");
	$res->body("<html> simple logger");
	return $res->finalize;
};

use Log::Dispatch::Config;
Log::Dispatch::Config->configure('./config/log_web.conf');

builder {
	enable 'LogDispatch', logger => Log::Dispatch::Config->instance;
	$app;
};

__END__
