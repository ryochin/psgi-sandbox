# simple, minimum code

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;
use HTTP::Exception;

use Path::Class qw(dir);

use utf8;

my $app = sub {
	my $req = Plack::Request->new(shift);

	my $res = Plack::Response->new(200);
	$res->content_type("text/html");
	$res->body("ok.");
	return $res->finalize;
};

my $htdocs_dir = dir('./htdocs/');

builder {
	enable 'Debug';
	enable 'StackTrace';
	enable 'HTTPExceptions';
	enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' }
		'ReverseProxy';
	enable 'Static', path => qw{^/(img|css|js|error)/}, root => $htdocs_dir;
	enable 'Static', path => qw{^/(?:favicon\.(ico|png)|robots\.txt)$}, root => $htdocs_dir;
	$app;
};

__END__

