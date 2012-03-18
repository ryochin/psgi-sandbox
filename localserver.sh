#!/bin/sh

plackup -S Starlet --listen 0:5000 \
	-MPlack::App::Directory \
	-e "Plack::App::Directory->new({ root => q{$1} || '.' })"

