#
# plackup -s Twiggy -E -r --port 8080 ./proxy_forward.psgi

use strict;
use warnings;

use Plack::Builder;
use Plack::App::Proxy;

builder {
  enable 'AccessLog', format => 'combined';

  enable 'Proxy::Connect';
  enable 'Proxy::AddVia';
  enable 'Proxy::Requests';

  enable sub {
    my $app = shift;
    sub {
      my $env = shift;

      # do something

      my $res = $app->($env);
      return $res;
    };
  };

  Plack::App::Proxy->new(
    backend => "AnyEvent::HTTP",
    options => {
      timeout => 60,
      proxy   => [ "localhost", 3128 ],
    },
  )->to_app;
};

__END__
