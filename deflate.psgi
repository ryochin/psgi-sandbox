# 

use strict;
use warnings;

use Path::Class qw(file);
use Plack::Builder;

use utf8;

my @deflate_content_type;
push @deflate_content_type, map { 'text/' . $_ } qw(plain html css javascript);
push @deflate_content_type, map { 'application/' . $_ } qw(javascript xml json);

builder {
	enable "Deflater",
		content_type => [ @deflate_content_type ],
		vary_user_agent => 1;
	
	sub { [200,['Content-Type','text/plain'], [ file($0)->slurp ] ] }
};

__END__