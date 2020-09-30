#!/usr/bin/perl --

use strict;
use warnings;
use Path::Class qw(file dir);

use utf8;

use AnyEvent::Open3::Simple;
use AnyEvent::WebSocket::Client;
use JSON qw( to_json );

my $client     = AnyEvent::WebSocket::Client->new;
my $connection = $client->connect("ws://localhost:5000/websocket")->recv;

my $done = AnyEvent->condvar;

my $ipc = AnyEvent::Open3::Simple->new(
  on_stdout => sub {
    my ( $proc, $line ) = @_;
    say $line;
    $connection->send( to_json( { type => 'out', data => $line } ) );
  },
  on_stderr => sub {
    my ( $proc, $line ) = @_;
    say STDERR $line;
    $connection->send( to_json( { type => 'err', data => $line } ) );
  },
  on_exit => sub {
    my ( $proc, $exit, $signal ) = @_;
    $connection->send( to_json( { type => 'exit', exit => $exit, signal => $signal } ) );
    $done->send( [ $exit, $signal ] );
  },
  on_error => sub {
    my ($error) = @_;
    $connection->send( to_json( { type => 'error', data => $error } ) );
    $done->croak($error);
  },
);

$connection->send( to_json( [qw(message hello)] ) );
$ipc->run(qw(message hello));

my ( $exit, $signal ) = @{ $done->recv };
if ($signal)
{
  say STDERR "died with signal $signal\n";
  exit 1;
}
else
{
  exit $exit;
}
__END__

 
$client->connect("ws://localhost:5000/websocket")->cb(sub {
   my $connection = eval { shift->recv };
   if($@) {
     # handle error...
	 warn $@;
   }
   
   warn $connection;
   
   # send a message through the websocket...
   $connection->send('a message');
   
   # recieve message from the websocket...
   $connection->on(each_message => sub {
     # $connection is the same connection object
     # $message isa AnyEvent::WebSocket::Message
     my($connection, $message) = @_;
    
	warn "\$message = $message";
   });
   
   # handle a closed connection...
   $connection->on(finish => sub {
     # $connection is the same connection object
     my($connection) = @_;
     warn "\$connection = $connection";
   });

   # close the connection (either inside or
   # outside another callback)
   $connection->close;
 
 });
__END__
