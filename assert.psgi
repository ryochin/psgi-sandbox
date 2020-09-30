# PERL_NDEBUG=1 plackup ./assert.psgi

use strict;
use warnings;
use Carp::Assert;
use Carp::Assert::More;

use Plack::Request;
use Plack::Response;

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $x = 5;
  assert $x > 10 => "x is larger than 10";

  my $res = Plack::Response->new(200);
  $res->content_type("text/plain");
  $res->body("ok.");
  return $res->finalize;
};

__END__
