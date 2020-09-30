# mkcert localhost
# carton exec -- plackup -r --server Twiggy::TLS --tls-key localhost-key.pem --tls-cert localhost.pem --port 10443 ./tls.psgi
# curl -v --cacert ~/Library/Application\ Support/mkcert/rootCA.pem -H 'Host localhost' https://localhost:10443/

use strict;
use warnings;

use Data::Printer;

use Plack::Request;
use Plack::Response;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $tls_info = $req->env->{"psgi.tls"};

  my $res = Plack::Response->new(200);
  $res->content_type("text/plain");
  $res->body(np($tls_info));
  return $res->finalize;
};
