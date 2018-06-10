use Cro::HTTP::Router;
use Cro::HTTP::Router::WebSocket;
use JSON::Fast;
use Weather;

sub routes(Weather $w) is export {
    route {
        get -> {
            static 'static/index.html'
        }

        get -> 'js', *@path {
            static 'static/js', @path
        }

        get -> 'latest-data' {
            web-socket -> $incoming {
                supply whenever $w.latest-data -> $data {
                    emit to-json {
                        WS_ACTION => True,
                        action => {
                            type => 'LATEST_DATA',
                            text => $data
                        }
                    }
                }
            }
        }
    }
}
