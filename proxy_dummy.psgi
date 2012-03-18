use strict;
use warnings;

use Plack::App::Proxy;

my $proxy = Plack::App::Proxy->new->to_app;
my $app = sub {
	my $env = shift;
	$env->{'plack.proxy.url'} = "http://localhost:5000";
	$proxy->( $env );
};

__END__

