#
# see http://d.hatena.ne.jp/hiratara/20100209/1265685238

use strict;
use Plack::App::Proxy;
use Plack::Builder;

builder {
  enable 'Proxy::RewriteLocation';
  mount "/joinreq" => Plack::App::Proxy->new(
    remote               => 'http://fumi2.jp/',
    preserve_host_header => 1,
    backend              => 'AnyEvent::HTTP',     # AnyEvent::HTTP is the default if no backend is specified
  )->to_app;
};

__END__

