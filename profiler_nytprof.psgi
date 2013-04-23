use Plack::Builder;

builder {
	enable 'Profiler::NYTProf';
	sub { [ '200', [], [ 'Hello Profiler' ] ] };
};


