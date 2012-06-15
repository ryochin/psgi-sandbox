# 
# Furl streaming proxy

use strict;
use warnings;

use Furl::HTTP;

my $url = "https://www.google.co.jp/images/icons/product/chrome-48.png";

my $app = sub {
	my $env = shift;
	$env->{'psgi.streaming'} or die "This is not streaming compliant.";

	return sub {
		my $responder = shift;
		
		my $writer = $responder->(
			[ 200, [ 'Content-Type', "image/png" ]]
		);
		
		my $furl = Furl::HTTP->new(
			timeout => 10,
		);
		
		$furl->request(
			method => 'GET',
			url => $url,
			write_code => sub {
				my ($res_status, $res_msg, $res_headers, $body) = @_;
				
				$writer->write( $body );
			},
		);
		
		# end
		$writer->close;
	};
};

__END__
