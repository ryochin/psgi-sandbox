# 

use strict;
use warnings;

use Plack::Request;
use Plack::Response;
use Plack::Builder;

use HTTP::Session;
use  HTTP::Session::State::Cookie;
use HTTP::Session::Store::File;

use Path::Class qw(dir file);

use utf8;
use Encode ();

my $app = sub {
	my $req = Plack::Request->new(shift);
	
	my $session = &prepare_session( $req );
	
	$session->set( foo => time ) if not ( 5 % ( int(rand 10) + 1 ) );
	$session->set( bar => q{なんとか〜} );
	
	my $content = "ok: " . $session->get('foo') || "(none)";
	
	my $res = Plack::Response->new(200);
	$res->content_type("text/plain");
	$res->body( Encode::encode_utf8( $content ) );
	
	# finalize session object
	$session->response_filter( $res );
	
	return $res->finalize;
};

sub prepare_session {
	my $req = shift;

	my $state =  HTTP::Session::State::Cookie->new(
		name => "user",
	);
	
#	my $store = HTTP::Session::Store::Memcached->new(
#		memd => Cache::Memcached->new,
#	);
	my $store = HTTP::Session::Store::File->new(
		dir => dir( "var", "session" ),
	);
	
	return HTTP::Session->new(
		state => $state,
		store =>$store,
		request => $req->env,
	);
}

__END__
