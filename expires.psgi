use strict;
use warnings;

use Plack::Builder;
use Plack::Middleware::Expires;
use Plack::App::File;

builder {
	mount '/' => builder {
		sub { [ 200, [ 'Content-type' => 'text/html' ], [ q{<html><a href="/image">/image</a> } ] ] };
	};
	
	mount '/image' => builder {
		enable 'Expires',
			content_type => [ 'text/css', 'application/javascript', qr!^image/! ],
			expires => 'access plus 3 days';
		
		Plack::App::File->new( file => "./htdocs/test.jpg" );
	};
};

__END__
