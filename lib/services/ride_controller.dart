import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import '../models/ride.dart';
import 'ride_repository.dart';

class RideController extends ChangeNotifier {
  RideController(this._repo);
  final RideRepository _repo;

  // TODO: geolocator bilan haqiqiy joylashuvni olish
  LatLng pickup = const LatLng(41.3111, 69.2797); // Toshkent
  LatLng? dropoff;
  Tariff tariff = tariffs.first;
  RideStatus status = RideStatus.idle;
  Driver? driver;
  StreamSubscription<DriverUpdate>? _sub;

  double get distanceKm => dropoff == null
      ? 0
      : const Distance().as(LengthUnit.Kilometer, pickup, dropoff!);
  int get price => dropoff == null ? 0 : tariff.price(distanceKm);

  void setDropoff(LatLng p) {
    if (status != RideStatus.idle) return;
    dropoff = p;
    notifyListeners();
  }

  void setTariff(Tariff t) {
    tariff = t;
    notifyListeners();
  }

  void request() {
    if (dropoff == null || status != RideStatus.idle) return;
    _sub = _repo.requestRide(pickup, dropoff!, tariff).listen((u) {
      status = u.status;
      driver = u.driver;
      notifyListeners();
    });
  }

  void cancel() {
    _sub?.cancel();
    status = RideStatus.idle;
    driver = null;
    dropoff = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
