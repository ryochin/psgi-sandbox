#!/usr/bin/perl --

use strict;
use warnings;
use CGI;

use utf8;

my $cgi = CGI->new;
print $cgi->header( -charset => 'utf-8', -type => "text/plain" );
print "ok", "\n";

__END__
