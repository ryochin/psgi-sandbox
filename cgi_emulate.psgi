
use strict;
use warnings;
use CGI::Emulate::PSGI;

my $app = CGI::Emulate::PSGI->handler( sub {
    system('/opt/munin/www/cgi/munin-cgi-graph');
} );

__END__
