# 

use strict;
use warnings;
use Plack::Builder;

use File::Temp ();

my $app = sub {
	return [ 200, [ 'Content-Type' => 'text/plain' ], [ "Hello World" ] ];
};

my $fh = File::Temp->new( DIR => "/tmp", SUFFIX => '.dat' );

builder {
	enable "ServerStatus::Lite",
		path => '/server-status',
		allow => [ '127.0.0.1', '192.168.0.0/16' ],
#		counter_file => './var/counter_file.txt',
		counter_file => $fh->filename,
		scoreboard => File::Temp::tempdir( CLEANUP => 1 );
	$app;
};

__END__
