import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/location_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  debugPrint(
    'Has OPENWEATHER_API_KEY: ${dotenv.env.containsKey('OPENWEATHER_API_KEY')}',
  );
  debugPrint(
    'OPENWEATHER_API_KEY length: ${dotenv.env['OPENWEATHER_API_KEY']?.length ?? 0}',
  );

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherProvider>(
          create: (_) => WeatherProvider()..initialize(),
        ),
        ChangeNotifierProvider<LocationProvider>(
          create: (_) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          fontFamily: 'Roboto',
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
