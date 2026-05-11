import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/audio_provider.dart';
import 'providers/playlist_provider.dart';
import 'screens/home_screen.dart';
import 'services/audio_player_service.dart';
import 'services/storage_service.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OfflineMusicPlayerApp());
}

class OfflineMusicPlayerApp extends StatelessWidget {
  const OfflineMusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>(create: (_) => StorageService()),
        ChangeNotifierProvider<AudioProvider>(
          create: (context) => AudioProvider(
            AudioPlayerService(),
            context.read<StorageService>(),
          ),
        ),
        ChangeNotifierProvider<PlaylistProvider>(
          create: (context) => PlaylistProvider(context.read<StorageService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Offline Music Player',
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.text,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface.withOpacity(0.9),
            hintStyle: const TextStyle(color: AppColors.mutedText),
            prefixIconColor: AppColors.mutedText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
