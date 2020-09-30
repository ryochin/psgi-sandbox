use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

my $app = sub {
  my $req = Plack::Request->new(shift);

  my $body = $req->path eq '/api'
    ? "<html>ok (<a href='/'>back</a>)"
    : &template;

  my $res = Plack::Response->new(200);
  $res->content_type("text/html");
  $res->body( scalar $body );
  return $res->finalize;
};

builder {
  enable 'Session';
  enable 'CSRFBlock',
    meta_tag => 'secure_token';
  $app;
};

sub template {
  return <<'';
<!DOCTYPE html>
<html lang="en">
	<head>
		<title>input form</title>
		<script src="https://ajax.cdnjs.com/ajax/libs/jquery/2.0.0/jquery.min.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(document).ready( function () {
				var token = $("meta[name='csrftoken']").attr("content");
				
				$('#dropper').change( function () {
					if( $(this).is(':checked') ){
						$('input[name="SEC"]').val('');
					}
					else{
						$('input[name="SEC"]').val(token);
					}
				} );
			} );
		</script>
	</head>
	<body>
		<form action="/api" method="post">
			<input type="text" name="email"><input type="submit">
		</form>
		
		<p>
			<input type="checkbox" id="dropper"><label for="dropper"> drop secure token</label>
		</p>
	</body>
</html>

}

__END__
