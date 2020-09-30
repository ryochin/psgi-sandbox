#
# http://localhost:5000/?10

use strict;
use warnings;

use Plack::Builder;
use HTTP::Exception;

use Path::Class qw(file);
use Scalar::Util qw(looks_like_number);

my $boundary = sprintf "----=_NeXtPaRt%08.0f", rand() * 1E8;    # by CGI::Push

my $app = sub {
  my $env = shift;
  $env->{'psgi.streaming'} or die "This is not streaming compliant.";

  return sub {
    my $responder = shift;

    my $writer = $responder->(
      [ 200, [ 'Content-Type', sprintf q{multipart/x-mixed-replace; boundary="%s"}, $boundary ] ]
    );

    my $max = ( defined $env->{QUERY_STRING} and looks_like_number $env->{QUERY_STRING} )
      ? int $env->{QUERY_STRING}
      : 1_000_000_000;

    my $n = 0;
    while (1) {
      last if $n++ >= $max;

      # file
      my $file = file( sprintf "./htdocs/img/push%d.jpg", ( ( $n - 1 ) % 5 ) + 1 );
      HTTP::Exception::404->throw if not -r $file;

      # headers
      $writer->write( sprintf "\r\n--%s\r\n", $boundary );
      $writer->write( sprintf "Content-Type: image/jpeg\r\n" );
      $writer->write( sprintf "Content-Length: %d\r\n", $file->stat->size );
      $writer->write("\r\n");

      # content
      $writer->write( $file->slurp . "\r\n" );    # you need concat \r\n in one line

      sleep 1;
    }

    # end
    $writer->write( sprintf "\r\n--%s--\r\n", $boundary );
    $writer->write("\r\n");
    $writer->close;
  };
};

builder {
  enable 'HTTPExceptions';
  $app;
};

__END__
