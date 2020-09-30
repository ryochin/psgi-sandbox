#
# 深い階層のディレクトリは掘ってくれない

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use Path::Class qw(dir file);
use File::RotateLogs;

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $res = Plack::Response->new(200);
  $res->content_type("text/plain");
  $res->body("ok.");
  return $res->finalize;
};

my $log_dir = dir("./logs");

my $rotatelogs = File::RotateLogs->new(
  #	logfile => file( $log_dir, "%Y%m%d", "backend_%Y%m%d%H%M.log" )->stringify,
  logfile      => file( $log_dir, "backend_%Y%m%d%H%M.log" )->stringify,
  linkname     => file( $log_dir, "backend_current.log" )->stringify,
  rotationtime => 3600,
  maxage       => 86400,    #1day
);

builder {
  enable 'AxsLog',
    combined      => 1,
    response_time => 1,
    #		error_only => 1,
    logger => sub { $rotatelogs->print(@_) };

  $app;
};

__END__
