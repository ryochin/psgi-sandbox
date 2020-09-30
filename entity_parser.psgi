use v5.10;
use strict;
use warnings;
use Data::Dumper qw(Dumper);

use HTTP::Entity::Parser;

my $parser = HTTP::Entity::Parser->new;
$parser->register( 'application/x-www-form-urlencoded' => 'HTTP::Entity::Parser::UrlEncoded' );
$parser->register( 'multipart/form-data'               => 'HTTP::Entity::Parser::MultiPart' );
$parser->register( 'application/json'                  => 'HTTP::Entity::Parser::JSON' );

my $app = sub {
  my $env = shift;
  my ( $params, $uploads ) = $parser->parse($env);

  say Dumper($params);
  say Dumper($uploads);

  return [ 200, [ 'Content-type' => 'text/plain' ], ["Hello World"] ];
  }

__END__
