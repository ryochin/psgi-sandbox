#!/usr/bin/env perl

use strict;
use warnings;

use Plack::Loader;
use Plack::Middleware::AccessLog;

my $app = sub { [ 200, [ 'Content-type' => 'text/plain' ], [ "Hello World" ] ] };

$app = Plack::Middleware::AccessLog->wrap( $app );

local $ENV{PLACK_ENV} = "deployment";
Plack::Loader->load( 'Twiggy', host => '0.0.0.0', port => 5000 )->run( $app );

__END__
