# plackup -s Starlet -r sleep.psgi

sub { sleep 5; [ 200, [ 'Content-type' => 'text/plain' ], ["Hello World"] ] }
