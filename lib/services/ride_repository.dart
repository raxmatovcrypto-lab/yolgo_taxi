import 'package:latlong2/latlong.dart';
import '../models/ride.dart';

/// Server bilan aloqa shu interfeys orqali bo'ladi.
/// Keyin REST + WebSocket (yoki Firebase) versiyasini yozasiz.
abstract class RideRepository {
  Stream<DriverUpdate> requestRide(LatLng pickup, LatLng dropoff, Tariff tariff);
}

/// Server yo'q paytda ishlaydigan soxta versiya (demo uchun).
class MockRideRepository implements RideRepository {
  @override
  Stream<DriverUpdate> requestRide(
      LatLng pickup, LatLng dropoff, Tariff tariff) async* {
    yield const DriverUpdate(RideStatus.searching, null);
    await Future.delayed(const Duration(seconds: 3));

    final start = LatLng(pickup.latitude + 0.012, pickup.longitude + 0.012);
    var driver = Driver(
      name: 'Aziz',
      car: 'Chevrolet Gentra',
      plate: '01 A 777 AA',
      rating: 4.9,
      position: start,
    );
    yield DriverUpdate(RideStatus.driverOnWay, driver);

    const steps = 12;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(seconds: 1));
      final t = i / steps;
      driver = driver.copyWith(
        position: LatLng(
          start.latitude + (pickup.latitude - start.latitude) * t,
          start.longitude + (pickup.longitude - start.longitude) * t,
        ),
      );
      yield DriverUpdate(
        i < steps ? RideStatus.driverOnWay : RideStatus.arrived,
        driver,
      );
    }
  }
}
