
use strict;
use warnings;

use Plack::Request;
use Plack::Response;

use Data::Printer;
use Data::Section -setup;
use Text::Template;
use CGI;

use utf8;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my @upload;
  for my $upload ( $req->uploads ) {
    push @upload, $upload;
  }

  my $data = {
    env        => np( $req->env ),
    parameters => np( $req->parameters ),
    upload     => np(@upload),
  };

  my $template = Text::Template->new( SOURCE => __PACKAGE__->section_data('template') );
  my $html     = $template->fill_in( HASH => $data );

  my $res = Plack::Response->new(200);
  $res->content_type("text/html; charset=UTF-8");
  $res->body($html);
  return $res->finalize;
};

__DATA__
__[ template ]__
<html>
  <head>
    <title>dump</title>
  </head>
  <body>
    <h1>dump</h1>
    <form action="" method="post">
      <p>text <input type="text" name="my_test" value=""></p>
      <p>file <input type="file" name="my_file" value=""></p>
      <p><textarea name="my_area"></textarea></p>
      <input type="submit">
    </form>
    <hr />

    <h2>env</h2>
    <pre>{$env}</pre>

    <h2>parameters</h2>
    <pre>{$parameters}</pre>

    <h2>upload</h2>
    <pre>{$upload}</pre>

  </body>
</html>
