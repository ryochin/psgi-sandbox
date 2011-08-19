# simple and fullstack webserver

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;
use HTTP::Exception;

use Path::Class qw(dir file);
use Log::Dispatch::Config;
use IO::File;
use Fcntl qw(:flock);

use Data::Printer;

use utf8;

my $app = sub {
	my $req = Plack::Request->new(shift);

	# throw exception
#	HTTP::Exception::503->throw;

	warn p($req->env);

	my $res = Plack::Response->new(200);
	$res->content_type("text/html");
	$res->body(<<"END");
<html>

<p>simple psgi test.</p>

</html>
END
	
	return $res->finalize;
};

# log config
Log::Dispatch::Config->configure( file( "config", "log_web.conf" )->stringify );

my $log_file = file('./logs', 'backend.log');
my $logger = sub {
	my $fh = IO::File->new( $log_file, O_CREAT|O_WRONLY|O_APPEND ) or die $!;
	flock $fh, LOCK_EX;    # get lock for infinity
	seek $fh, 0, LOCK_EX;
	$fh->print(@_);
	flock $fh, LOCK_UN;    # release lock
	$fh->close;
};

my $htdocs_dir = dir('./htdocs/');

builder {
	enable 'Debug';
	enable 'StackTrace';
	enable 'AccessLog', format => 'combined', logger => $logger;
	enable 'ConditionalGET';
	enable 'ContentLength';
	enable 'ErrorDocument',    # before HTTPExceptions
		400 => file( $htdocs_dir, "error", "400.html" ),
		401 => file( $htdocs_dir, "error", "401.html" ),
		403 => file( $htdocs_dir, "error", "403.html" ),
		404 => file( $htdocs_dir, "error", "404.html" ),
		406 => file( $htdocs_dir, "error", "406.html" ),
		413 => file( $htdocs_dir, "error", "413.html" ),
		500 => file( $htdocs_dir, "error", "500.html" ),
		503 => file( $htdocs_dir, "error", "503.html" );
	enable 'HTTPExceptions';
	enable 'Runtime';
	enable 'Head';
	enable 'XFramework', framework => "TestFramework";
	enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' }
		'ReverseProxy';
	enable 'Deflater';    # deflate/gzip
#	'Auth::Digest', realm => "Restricted Area", secret => $auth_secret,
#		authenticator => $authenticator;
#	enable 'Header',
#		set => [ Server => 'PSGI-compatible Server' ];
	
#	enable 'Access',
#		rules => [
#			deny  => "192.168.0.0/24",
#			allow  => "all",
#		];
	enable 'LogDispatch', logger => Log::Dispatch::Config->instance;
	enable 'Static', path => qw{^/(img|css|js|error)/}, root => $htdocs_dir;
	enable 'Static', path => qw{^/(?:favicon\.(ico|png)|robots\.txt)$}, root => $htdocs_dir;
	$app;
};

__END__

