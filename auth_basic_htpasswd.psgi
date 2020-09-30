# http://d.hatena.ne.jp/tokuhirom/20100904/1283573706

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use Authen::Htpasswd;

use utf8;

my $htpasswd = "./var/htpasswd";
die "cannot find file $htpasswd !"
  if not -r $htpasswd;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $res = Plack::Response->new(200);
  $res->content_type("text/plain");
  $res->body("ok.");
  return $res->finalize;
};

my $authen        = Authen::Htpasswd->new( $htpasswd, { encrypt_hash => 'md5' } );
my $authenticator = sub {
  my ( $username, $password ) = @_;
  my $user = $authen->lookup_user($username);
  return $user && $user->check_password($password);
};

builder {
  enable 'Auth::Basic', authenticator => $authenticator;
  $app;
};

__END__
