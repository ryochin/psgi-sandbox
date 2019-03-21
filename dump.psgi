
use strict;
use warnings;

use Plack::Request;
use Plack::Response;

use Data::Printer;
use String::TT qw(tt);
use Data::Section -setup;

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my @output;
  push @output, p( $req->env );
  push @output, p( $req->parameters );

  for my $upload( $req->uploads ){
    push @output, p( $upload );
  }

  my $output = join "\n", @output;

  my $res = Plack::Response->new(200);
  $res->content_type("text/html; charset=UTF-8");

  my $html =  tt ${ __PACKAGE__->section_data('template') };

warn $req->address;

  $res->body( $html );
  return $res->finalize;
};

__DATA__
__[ template ]__
<html>
<form action="" method="post" enctype="multipart/form-data">
  <p>text <input type="text" name="my_test" value="" /></p>
  <p>file <input type="file" name="my_file" value="" /></p>
  <p><textarea name="my_area"></textarea></p>
  <input type="submit" />
</form>
<hr />
<pre>
[% output | html %]
</pre>
</html>
--
