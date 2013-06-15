use strict;
use warnings;

use Plack::Builder;
use HTTP::Exception;

use Sys::Load ();

builder {
	enable 'HTTPExceptions';

	enable_if { (Sys::Load::getload())[0] > 3.00 }
		sub { sub { HTTP::Exception::503->throw } };

	sub { [ 200, [ 'Content-type' => 'text/plain' ], [ "Hello World" ] ] };
};

__END__

