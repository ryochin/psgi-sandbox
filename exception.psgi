# 

use strict;
use warnings;
use Plack::Builder;

use HTTP::Exception 0.04;

my $app = sub {
	HTTP::Exception::403->throw;
};

builder {
	enable 'HTTPExceptions', rethrow => 1;
	$app;
};

__END__
