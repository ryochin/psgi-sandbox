# flea framework

use Flea;

sub valid_id {
	my $id = shift;
	
	return $id == 1;
}

my $app = bite {
	get '^/$' {
		file './htdocs/t.html';
	}
	get '^/favicon\.ico$' {
		file './htdocs/favicon.ico';
	}
	get '^/api$' {
		json { foo => 'bar' };
	}
	get '^/html$' {
		html q{<html><a href="http://google.com">google.com</a></html"};
	}
	any '^/resource/(\d+)$' {
		my $req = request(shift);
		my $id = shift;
		http 400 unless valid_id($id);
		
		my $res = response($req);
		$res->content_type("text/plain");
		$res->body("ok");
		
		return $res;
	}
};

__END__
