
use strict;
use CGI::Compile;
use CGI::Emulate::PSGI;

my $sub = CGI::Compile->compile("./test.cgi");
my $app = CGI::Emulate::PSGI->handler( $sub );

