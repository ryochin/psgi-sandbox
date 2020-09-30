#
# XXX: it seems something wrong, don't use this code !!

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;
use HTTP::Exception;

use Path::Class qw(dir file);

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $res = Plack::Response->new(200);
  $res->content_type("text/html");
  $res->body("ok.");
  return $res->finalize;
};

# access log
# --preload-app を使わないと、worker の数だけ cronolog プロセスが立ち上がることに注意。
#my $cronolog_file = dir( "./logs/%Y%m/backend_access_%Y%m%d/%H_%M.log" );
my $cronolog_file = dir("./logs/%Y%m/backend_access_%Y%m%d.log");
open my $fh, "| /usr/local/sbin/cronolog $cronolog_file"
  or die $!;
$fh->autoflush(1);

my $htdocs_dir = dir('./htdocs/');

builder {
  enable 'AccessLog', format => 'combined', logger => sub { print {$fh} @_ };
  enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' }
  'ReverseProxy';

  enable 'Static', path => qw{^/(img|css|js|error|doc)/},             root => $htdocs_dir;
  enable 'Static', path => qw{^/(?:favicon\.(ico|png)|robots\.txt)$}, root => $htdocs_dir;
  $app;
};

__END__

