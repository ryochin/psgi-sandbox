# output json

use strict;
use warnings;

use Plack::Request;
use Plack::Response;

use JSON;

use utf8;

my $app = sub {
  # data
  my $status = "42";
  my $data   = {
    status    => $status + 0,    # numify
    user_name => "まいね〜む",
    list      => [ 0 .. 5 ],
    epoch     => time(),
    empty     => undef,
    is_new    => JSON::true,
  };

  # res
  my $res = Plack::Response->new(200);
  $res->content_type("application/json");
  $res->header( 'Content-Language'       => 'ja' );
  $res->header( "X-Content-Type-Options" => "nosniff" );    # for security

  # for dynamic content
  $res->header( 'Pragma'        => 'no-cache' );
  $res->header( 'Cache-control' => [ 'no-cache', 'private' ] );

  $res->body( JSON->new->ascii(1)->encode($data) );

  return $res->finalize;
};

__END__
