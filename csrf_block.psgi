use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

my $app = sub {
	my $req = Plack::Request->new(shift);

	my $body = $req->path eq '/api'
		? "<html>ok"
		: do { local $/; <DATA> };

	my $res = Plack::Response->new(200);
	$res->content_type("text/html");
	$res->body( scalar $body );
	return $res->finalize;
};

builder {
	enable 'Session';
	enable 'CSRFBlock';
	$app;
};

__DATA__
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>input form</title>
	</head>
	<body>
		<form action="/api" method="post">
			<input type="text" name="email"><input type="submit">
		</form>
	</body>
</html>
