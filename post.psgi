use strict;
use warnings;

use Plack::Request;
use Plack::Response;
use DDP;

use Data::Section -setup;
use Text::Template;

  my $template = Text::Template->new( TYPE => 'STRING', SOURCE => ${ __PACKAGE__->section_data('main') } );

sub {
  my $req = Plack::Request->new(shift);

  our $data   = $req->param('data');
  our $result = '?';

  if( defined $data ){
    $data = $result = int($data || 7) * 6;

    p($req);
  }
  else{
    $data = 7;
  }

  my $res = Plack::Response->new(200);
  $res->content_type("text/html");
  $res->body( $template->fill_in );
  return $res->finalize;
};

__DATA__
__[ main ]__
<html>
<p>result: {$result}</p>

<form action="/" method="post">
  <input type="text" name="data" value="{$data}"><br>
  <input type="submit" value="show result">
</form>

</html>
