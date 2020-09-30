# curl http://0.0.0.0:5000/test.cgi

use strict;
use warnings;
use Plack::App::CGIBin;

Plack::App::CGIBin->new( root => "." )->to_app;
