# 

use strict;
use warnings;

use Plack::Request;
use Plack::Response;

use Path::Class qw(file);

my $file = file("./test.jpg");
die sprintf "please prepare your file '%s' !", $file->basename if not -r $file;

my $boundary = sprintf "----=_NeXtPaRt%08.0f", rand() * 1E8;    # by CGI::Push

my $app = sub {
	my $env = shift;
	$env->{'psgi.streaming'} or die "This is not streaming compliant.";

	return sub {
		my $responder = shift;
		
		my $writer = $responder->(
			[ 200, [ 'Content-Type', sprintf q{multipart/x-mixed-replace; boundary="%s"}, $boundary ]]
		);
		
		for( 1 .. 5 ){
			# headers
			$writer->write( sprintf "\r\n--%s\r\n", $boundary );
			$writer->write( sprintf "Content-type: image/jpeg\r\n" );
			$writer->write( sprintf "Content-length: %d\r\n", $file->stat->size );
			$writer->write( "\r\n" );
			
			# content
			$writer->write( $file->slurp . "\r\n" );
			
			sleep 1;
		}
		
		# end
		$writer->write( sprintf "\r\n--%s--\r\n", $boundary );
		$writer->write( "\r\n" );
		$writer->close;
	};
};

__END__
