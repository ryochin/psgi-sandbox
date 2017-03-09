use Plack::Response;

sub {
	my $res = Plack::Response->new(302);
	$res->redirect("https://example.com/");
	return $res->finalize;
};
