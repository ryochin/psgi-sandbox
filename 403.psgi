use strict;
use warnings;
use HTTP::Exception;
use Plack::Builder;

builder {
  enable 'HTTPExceptions';
  sub { HTTP::Exception::403->throw };
};
