import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models.dart';
import 'app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(CheckInAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(DaylogAdapter());

  // Open Daylog database
  await Hive.openBox<Daylog>('daylogs');

  runApp(const DaylogApp());
}

class DaylogApp extends StatelessWidget {
  const DaylogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daylog',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFF7F7F5),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F6B63),
          brightness: Brightness.light,
        ),

        fontFamily: 'Roboto',
      ),

      home: const AppNavigation(),
    );
  }
}