use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;
use Weather;

my $weather = Weather.new;
my $application = routes($weather);

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<WEATHER_HOST> ||
        die("Missing WEATHER_HOST in environment"),
    port => %*ENV<WEATHER_PORT> ||
        die("Missing WEATHER_PORT in environment"),
    :$application,
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<WEATHER_HOST>:%*ENV<WEATHER_PORT>";

react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
    whenever Supply.interval(1) -> $v {
        $weather.add-data($v.Str);
    }
}
