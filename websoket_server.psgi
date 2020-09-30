# plackup -s Twiggy -r websoket_server.psgi

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use Plack::App::WebSocket;

# see http://cpansearch.perl.org/src/PLICEASE/AnyEvent-WebSocket-Client-0.20/example/jobserver

builder {
  mount "/websocket" => Plack::App::WebSocket->new(
    on_error => sub {
      my $env = shift;
      return [ 500,
        [ "Content-Type" => "text/plain" ],
        [ "Error: " . $env->{"plack.app.websocket.error"} ] ];
    },
    on_establish => sub {
      my ( $conn, $env ) = @_;

      $conn->on(
        message => sub {
          my ( $conn, $msg ) = @_;

          warn "msg = $msg";

          $conn->send($msg);
        },
        finish => sub {
          undef $conn;
          warn "Bye!!\n";
        },
      );
    }
  )->to_app;

  mount "/" => sub { [ 200, [ 'Content-type' => 'text/plain' ], ["Hello World"] ] };
};

__END__
