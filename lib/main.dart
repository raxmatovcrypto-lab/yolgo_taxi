import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/ride_controller.dart';
import 'services/ride_repository.dart';

void main() {
  runApp(const YolGoApp());
}

class YolGoApp extends StatefulWidget {
  const YolGoApp({super.key});

  @override
  State<YolGoApp> createState() => _YolGoAppState();
}

class _YolGoAppState extends State<YolGoApp> {
  // Keyinchalik MockRideRepository o'rniga haqiqiy server (HttpRideRepository) qo'yiladi.
  late final RideController controller = RideController(MockRideRepository());

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YoʻlGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFFC107),
        useMaterial3: true,
      ),
      home: HomeScreen(controller: controller),
    );
  }
}
