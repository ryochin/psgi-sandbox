use strict;
use warnings;

use Plack::Builder;
use HTTP::Exception;

builder {
	enable 'HTTPExceptions';
	
	# bad robots
	enable_if { shift->{HTTP_USER_AGENT} =~ /(ScoutJ|MJ12bot|SiteExplorer)/o }
		sub { sub { HTTP::Exception::403->throw } };
	
	sub { [ 200, [ 'Content-type' => 'text/plain' ], [ "ok" ] ] };
};

__END__
