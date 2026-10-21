import 'package:latlong2/latlong.dart';

enum RideStatus { idle, searching, driverOnWay, arrived }

class Tariff {
  const Tariff(this.name, this.baseFare, this.perKm, this.icon);
  final String name;
  final int baseFare; // so'm
  final int perKm; // so'm
  final String icon;

  int price(double km) => baseFare + (perKm * km).round();
}

const tariffs = [
  Tariff('Ekonom', 5000, 1800, '🚕'),
  Tariff('Komfort', 8000, 2600, '🚙'),
  Tariff('Biznes', 15000, 4500, '🚘'),
];

class Driver {
  const Driver({
    required this.name,
    required this.car,
    required this.plate,
    required this.rating,
    required this.position,
  });

  final String name;
  final String car;
  final String plate;
  final double rating;
  final LatLng position;

  Driver copyWith({LatLng? position}) => Driver(
        name: name,
        car: car,
        plate: plate,
        rating: rating,
        position: position ?? this.position,
      );
}

class DriverUpdate {
  const DriverUpdate(this.status, this.driver);
  final RideStatus status;
  final Driver? driver;
}
