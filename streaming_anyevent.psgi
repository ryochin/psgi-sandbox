# 
# see http://d.hatena.ne.jp/tokuhirom/20120525/1337920350

use strict;
use warnings;

use AnyEvent;
use Time::HiRes qw(sleep);
use Try::Tiny;

my $i = 0;

my $app = sub {
	my $env = shift;
	$env->{'psgi.streaming'} or die "This is not streaming compliant.";
	
	return sub {
		my $responder = shift;
		
		my $reqcnt = $i++;
		my $cnt = 0;
		
		my $writer = $responder->(
			[200, ['Content-Type' => 'text/plain']]
		);
		
		my $timer; $timer = AE::timer 0, 0.3, sub {
			try {
				$writer->write("$reqcnt: $cnt\n");
				$cnt++;
			} catch {
				warn $_;
			};
			
			return if $cnt < 10;
			
			# end
			undef $timer;
			$writer->close;
		};
	};
};

__END__
