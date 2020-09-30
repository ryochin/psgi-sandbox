#

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use Path::Class qw(file);
use IO::File;
use Fcntl qw(:flock);

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $res = Plack::Response->new(200);
  $res->content_type("text/plain");
  $res->body("ok.");
  return $res->finalize;
};

my $log_file = file( './logs', 'backend.log' );
my $logger   = sub {
  my $fh = IO::File->new( $log_file, O_CREAT | O_WRONLY | O_APPEND ) or die $!;
  flock $fh, LOCK_EX;    # get lock for infinity
  seek $fh, 0, LOCK_EX;
  $fh->print(@_);
  flock $fh, LOCK_UN;    # release lock
  $fh->close;
};

builder {
  enable 'AccessLog', format => 'combined', logger => $logger;
  $app;
};

__END__
