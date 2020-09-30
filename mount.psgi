use strict;
use warnings;

use Plack::Builder;

my $app = sub { [ 200, [ 'Content-type' => 'text/plain' ], [ "path: " . shift->{PATH_INFO} ] ] };

builder {
  # user files
  enable 'Rewrite', rules => sub {
    s{^/(?!(css|img|js|error|docs*|user|tmp|stat|list|etc|logs|analog|member|mobile|feed))(([\w\d]{2})[\w\d]{1,}/)(.*)}{/user/$3/$2$4};
  };

  # static
  enable 'DirIndex', dir_index => 'index.html';
  enable 'Static',   path      => qr{^/(img|css|js|error|doc|tmp|user|stat|list|etc|logs|analog|member|mobile|feed)/}, root => "./htdocs/";
  enable 'Static',   path      => qr{\.(txt|html|xml|ico|png|jpg|gif|css|js)$},                                        root => "./htdocs/";

  $app;
};

__END__
