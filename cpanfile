requires 'Plack';
requires 'Plack::App::Proxy';
requires 'Plack::Middleware::Auth::Basic';
requires 'Plack::Middleware::Auth::Digest';
requires 'Plack::Middleware::AxsLog';
requires 'Plack::Middleware::CSRFBlock';
requires 'Plack::Middleware::Debug';
requires 'Plack::Middleware::Deflater';
requires 'Plack::Middleware::Profiler::KYTProf';
requires 'Plack::Middleware::Profiler::NYTProf';
requires 'Plack::Middleware::Proxy::Requests';
requires 'Plack::Middleware::ReverseProxy';
requires 'Plack::Middleware::ServerStatus::Lite';

requires 'Starlet';

requires 'CGI::Compile';
requires 'CGI::Emulate::PSGI';
requires 'Flea';
requires 'Tatsumaki';

requires 'Authen::Htpasswd';
requires 'AnyEvent';
requires 'CHI';
requires 'CHI::Driver::Memcached';
requires 'Data::Printer';
requires 'Data::Section';
requires 'File::RotateLogs';
requires 'Furl::HTTP';
requires 'HTTP::Exception';
requires 'HTTP::Session';
requires 'JSON';
requires 'JSON::XS';
requires 'Log::Dispatch::Config';
requires 'Number::Bytes::Human';
requires 'NetAddr::IP';
requires 'NetAddr::IP::Lite';
requires 'Path::Class';
requires 'String::TT';
requires 'Sys::Load';
requires 'Time::HiRes';
requires 'Try::Tiny';
requires 'YAML::Syck';
