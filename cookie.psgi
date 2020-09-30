use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;
use HTTP::Exception;

use CGI::Simple::Cookie;

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $h = Plack::Util::headers($req->headers);
  my $cookies = CGI::Simple::Cookie->parse($h->get('Set-Cookie'));

  my $res = Plack::Response->new(200);
  $res->content_type("text/html");
  $res->body("ok.");
  return $res->finalize;
};
