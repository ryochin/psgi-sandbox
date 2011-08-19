# 
# authenticator は生パスワードを返さないといけないから htpasswd 形式はつらい
# でも生パスワードはあんまり書きたくないし、悩ましいところ。
# user:realm:password 形式をハッシュ化したものは渡せるから、自前でなにかつくるかどうか。
# クライアント証明書前提の管理画面で、ダイジェスト認証を念のために使うケースで、
# パスワードを１個だけ共用する場合にはいいのかも。でも config ファイルに DB のパスワードとかも
# 書いてあるわけだし、個人のパスワードを預かるわけでもないから、生でいいんじゃないのとは思う。

use v5.10;
use strict;
use warnings;

use Plack::Builder;
use Plack::Request;
use Plack::Response;

use utf8;

my $app = sub {
	my $req = Plack::Request->new(shift);

	my $user = $req->env->{REMOTE_USER};

	my $res = Plack::Response->new(200);
	$res->content_type("text/plain");
	$res->body("auth ok: user = " . $user);
	return $res->finalize;
};

# auth
my $auth_secret = 'yahooo!';
my $auth_file = "./var/admin_auth.yml";
my $authenticator = sub {
	my $user = shift;

	use YAML::Syck ();

	my $table = YAML::Syck::LoadFile( $auth_file );

	return ( $table->{ $user } // "" );
};

builder {
	enable "Auth::Digest", realm => "Admin Area", secret => $auth_secret,
		authenticator => $authenticator;

	$app,
};

__END__

