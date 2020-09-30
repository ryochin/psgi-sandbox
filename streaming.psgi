
my $limit = 10 * 1024**2;

my $app = sub {
  my $env = shift;

  return sub {
    my $responder = shift;

    my $writer = $responder->(
      [ 200, [ 'Content-Type', 'application/octet-stream', 'Content-Length', $limit ] ] );

    my $total = 0;
    while (1) {
      my $data = "\0" x ( 1 * 1024**2 );
      $total += length($data);

      $writer->write($data);

      warn $total;

      if ( $total > $limit ) {
        $writer->close;
        last;
      }

      return if $total > 5 * 1024**2;

      sleep 1;
    }

    warn "done";
  };
};
