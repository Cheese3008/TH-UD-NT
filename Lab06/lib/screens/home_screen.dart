import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/mini_player.dart';
import 'all_songs_screen.dart';
import 'playlist_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    AllSongsScreen(),
    PlaylistScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: IndexedStack(index: _selectedIndex, children: _screens)),
              const MiniPlayer(),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.soft,
        ),
        child: NavigationBar(
          height: 68,
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: AppColors.primary.withOpacity(0.22),
          selectedIndex: _selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.library_music_rounded),
              icon: Icon(Icons.library_music_outlined),
              label: 'Bài hát',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.queue_music_rounded),
              icon: Icon(Icons.queue_music_outlined),
              label: 'Playlist',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.tune_rounded),
              icon: Icon(Icons.tune_outlined),
              label: 'Cài đặt',
            ),
          ],
        ),
      ),
    );
  }
}
