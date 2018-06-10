use OO::Monitors;

class X::Weather::NoSuchId is Exception {
    has $.id;
    method message() { "No weather with ID '$!id'" }
}

monitor Weather {

    has Supplier $!latest-data = Supplier.new;

    method add-data(Str $data --> Nil) {
        start $!latest-data.emit($data);
    }

    method latest-data(--> Supply) {
        supply {
            whenever $!latest-data {
                .emit;
            }
        }
    }
}
