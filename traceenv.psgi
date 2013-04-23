# 

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use utf8;

my $app = sub {
	my $req = Plack::Request->new(shift);

	my $res = Plack::Response->new(200);
	$res->content_type("text/plain");
	$res->body("ok");
	return $res->finalize;
};

builder {
	enable 'Debug', panels => [ qw(DBITrace Memory Timer) ];
	enable 'Debug::TraceENV';
	enable 'StackTrace';
	$app;
};

__END__

