# 

use strict;
use warnings;

use Plack::Request;
use Plack::Response;
use Plack::Builder;

use Plack::Session;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;
use Plack::Session::Store::Cache;

use YAML ();
$YAML::Headless = 1;
$YAML::SortKeys = 1;
$YAML::ImplicitUnicode = 1;

use CHI;    # unified cache interface, uses Moo
use CHI::Driver::Memcached;

use utf8;
use Encode ();

my $app = sub {
	my $env = shift;
	
	my $session = Plack::Session->new($env);
	
	$session->set( foo => time ) if not ( 5 % ( int(rand 10) + 1 ) );
	$session->set( bar => q{なんとか〜} );
	
	my $content = "ok: " . ( $session->get('foo') // "(none)" );
	
	my $res = Plack::Response->new(200);
	$res->content_type("text/plain");
	$res->body( Encode::encode_utf8( $content ) );
	return $res->finalize;
};

my $cache = CHI->new(
	driver => 'Memcached',
	namespace => 'psgi.test.cache',
	servers => [ "127.0.0.1:11211" ],
	debug => 0,
	compress_threshold => 10_000,
);

builder {
	# session
	enable 'Session',
		state => Plack::Session::State::Cookie->new( expires => 60 ),    # sec
#		store => Plack::Session::Store::File->new(
#			dir => './session',
#			serializer => sub { YAML::DumpFile( reverse @_ ) },
#			deserializer => sub { YAML::LoadFile( @_ ) }
#		);
		store => Plack::Session::Store::Cache->new( cache => $cache );
	$app;
};

__END__
