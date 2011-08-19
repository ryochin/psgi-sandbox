# 
# see http://d.hatena.ne.jp/hiratara/20100209/1265685238

use strict;
use Plack::App::Proxy;
use Plack::Builder;
 
builder {
    enable 'Proxy::RewriteLocation';
    mount "/" => Plack::App::Proxy->new(
        remote => 'http://localhost:8080/',
        preserve_host_header => 1,
    )->to_app;
};

__END__

