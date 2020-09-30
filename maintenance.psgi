use strict;
use warnings;

use Plack::Builder;
use Plack::Response;
use HTTP::Exception;

use utf8;

my $app = sub {
  return Plack::Response->new(503)->finalize;
};

builder {
  enable 'ErrorDocument',    # before HTTPExceptions
    503 => "./htdocs/doc/maintenance.html";
  enable 'HTTPExceptions';
  $app;
};

__END__
