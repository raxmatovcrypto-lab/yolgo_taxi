import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../models/ride.dart';
import '../services/ride_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});
  final RideController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final c = controller;
        return Scaffold(
          body: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: c.pickup,
                  initialZoom: 14,
                  onTap: (_, point) => c.setDropoff(point),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.yolgo_taxi',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                      point: c.pickup,
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 32),
                    ),
                    if (c.dropoff != null)
                      Marker(
                        point: c.dropoff!,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                    if (c.driver != null)
                      Marker(
                        point: c.driver!.position,
                        child: const Text('🚕', style: TextStyle(fontSize: 30)),
                      ),
                  ]),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _BottomPanel(c: c),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({required this.c});
  final RideController c;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: switch (c.status) {
              RideStatus.idle => _idle(context),
              RideStatus.searching => [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  const Text('Haydovchi qidirilmoqda...'),
                  TextButton(onPressed: c.cancel, child: const Text('Bekor qilish')),
                ],
              RideStatus.driverOnWay || RideStatus.arrived => _driver(context),
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _idle(BuildContext context) {
    if (c.dropoff == null) {
      return const [
        Text('Xaritada borish manzilini bosing', style: TextStyle(fontSize: 16)),
      ];
    }
    return [
      Text('${c.distanceKm.toStringAsFixed(1)} km',
          style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 8),
      Row(
        children: [
          for (final t in tariffs)
            Expanded(
              child: GestureDetector(
                onTap: () => c.setTariff(t),
                child: Card(
                  color: t == c.tariff ? Theme.of(context).colorScheme.primaryContainer : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      Text(t.icon, style: const TextStyle(fontSize: 24)),
                      Text(t.name),
                      Text('${t.price(c.distanceKm)} soʻm',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: c.request,
          child: Text('Taksi chaqirish - ${c.price} soʻm'),
        ),
      ),
    ];
  }

  List<Widget> _driver(BuildContext context) {
    final d = c.driver!;
    final arrived = c.status == RideStatus.arrived;
    return [
      Text(arrived ? 'Haydovchi yetib keldi!' : 'Haydovchi yoʻlda',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text('${d.name}  ⭐ ${d.rating}'),
        subtitle: Text('${d.car} · ${d.plate}'),
      ),
      TextButton(onPressed: c.cancel, child: Text(arrived ? 'Yopish' : 'Bekor qilish')),
    ];
  }
}
