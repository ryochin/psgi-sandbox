# 

use v5.10;
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
	$res->body(<<"END");
<html>

<p>simple psgi test.</p>

</html>
END

	;
	return $res->finalize;
};

my $htdocs_dir = dir('./htdocs/');

builder {
	enable 'Debug', panels => [ qw(DBITrace Memory Timer) ];
	enable 'StackTrace';
	enable 'HTTPExceptions';

	# static server for devel
	enable 'Static', path => qw{^/(img|css|js|error)/}, root => $htdocs_dir;
	enable 'Static', path => qw{^/(?:favicon\.(ico|png)|robots\.txt)$}, root => $htdocs_dir;
	$app;
};

__END__

