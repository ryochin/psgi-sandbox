# 

use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use Number::Bytes::Human;

use utf8;

my $app = sub {
	my $req = Plack::Request->new(shift);
	
	my $res = Plack::Response->new(200);
	$res->content_type("text/html");
	
	my $body = "<html>";
	if( my $upload = $req->upload('uptest') ){
		# upload
		# -> $upload is a Plack::Request::Upload object
		$body .= <<"END";
<p>
	length: @{[ Number::Bytes::Human::format_bytes( $upload->size ) ]} bytes
</p>
END
	}
	
	# form
	$body .= <<"END";
<form action="/" method="post" enctype="multipart/form-data">
	<input type="file" name="uptest" />
	<input type="submit" />
</form>

</html>
END
	
	$res->body( $body );
	return $res->finalize;
};

__END__
