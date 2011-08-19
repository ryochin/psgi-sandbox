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
	$res->body("ok.");
	return $res->finalize;
};

builder {
	enable 'Access',
#		deny_page => sub { Plack::Response->new(403)->finalize },
		rules => [
			allow => "example.com",
			allow => "127.0.0.0/8",
			deny => "192.168.0.5",
			allow  => "192.168.0.0/24",
			deny  => "all",
		];
	$app;
};

__END__
