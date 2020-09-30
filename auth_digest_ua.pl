#!/usr/bin/perl --

use strict;
use warnings;

use HTTP::Request::Common;
use LWP::UserAgent;

my $host = "localhost";
my $port = 5000;

my $uri = sprintf "http://%s:%d", $host, $port;

my $req = HTTP::Request::Common::POST( $uri, { foo => 42 } );

my $ua = LWP::UserAgent->new;
$ua->env_proxy;
$ua->credentials( "$host:$port", "Admin Area", "taro", "passwd01" );

if ( my $res = $ua->request($req) ) {
  warn $res->status_line;
}
else {
  warn "failed";
}

__END__
