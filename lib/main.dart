import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/feeding_tracker_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evcil Hayvan Takip Uygulaması',
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/feeding_tracker': (context) => const FeedingTrackerScreen(),
      },
    );
  }
}
