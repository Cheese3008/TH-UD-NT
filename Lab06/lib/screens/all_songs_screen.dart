import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../services/permission_service.dart';
import '../services/playlist_service.dart';
import '../utils/constants.dart';
import '../widgets/song_tile.dart';

class AllSongsScreen extends StatefulWidget {
  const AllSongsScreen({super.key});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  final PlaylistService _playlistService = PlaylistService();
  final PermissionService _permissionService = PermissionService();
  final TextEditingController _searchController = TextEditingController();

  List<SongModel> _songs = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  String _sortMode = 'title';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final hasPermission = await _permissionService.requestAudioPermission();
    final songs = hasPermission ? await _playlistService.getAllSongs() : <SongModel>[];

    if (!mounted) return;
    setState(() {
      _hasPermission = hasPermission;
      _songs = songs;
      _sortSongs();
      _isLoading = false;
    });
  }

  Future<void> _importSongs() async {
    final pickedSongs = await _playlistService.pickAudioFiles();
    if (pickedSongs.isEmpty || !mounted) {
      return;
    }

    setState(() {
      final existingPaths = _songs.map((song) => song.filePath).toSet();
      final newSongs = pickedSongs.where((song) => !existingPaths.contains(song.filePath));
      _songs = [..._songs, ...newSongs];
      _sortSongs();
      _hasPermission = true;
    });
  }

  void _sortSongs() {
    if (_sortMode == 'artist') {
      _songs.sort((a, b) => a.artist.toLowerCase().compareTo(b.artist.toLowerCase()));
    } else {
      _songs.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
  }

  List<SongModel> get _displaySongs {
    final query = _searchController.text;
    return _playlistService.searchSongs(_songs, query);
  }

  @override
  Widget build(BuildContext context) {
    final displaySongs = _displaySongs;
    final artistCount = _songs.map((song) => song.artist).toSet().length;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.screenPadding,
            AppSpacing.screenPadding,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 18),
                _buildHeroCard(displaySongs.length, artistCount),
                const SizedBox(height: 18),
                _buildSearchBar(),
                const SizedBox(height: 14),
                _buildActionRow(displaySongs),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            0,
            AppSpacing.screenPadding,
            12,
          ),
          sliver: _buildContent(displaySongs),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thư viện nhạc',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 32,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Nghe nhạc offline và quản lý bài hát cục bộ',
                style: TextStyle(color: AppColors.mutedText, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.soft,
          ),
          child: IconButton(
            onPressed: _importSongs,
            icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
            tooltip: 'Thêm bài hát',
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(int visibleSongCount, int artistCount) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.headphones_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offline Music Player',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tìm kiếm, sắp xếp, phát nhạc và tạo playlist',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildStatBox('$visibleSongCount', 'Đang hiển thị'),
              const SizedBox(width: 10),
              _buildStatBox('${_songs.length}', 'Tổng bài hát'),
              const SizedBox(width: 10),
              _buildStatBox('$artistCount', 'Nghệ sĩ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Tìm bài hát, nghệ sĩ, album...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
      ),
    );
  }

  Widget _buildActionRow(List<SongModel> displaySongs) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Theo tên'),
                selected: _sortMode == 'title',
                onSelected: (_) => _changeSortMode('title'),
              ),
              ChoiceChip(
                label: const Text('Theo nghệ sĩ'),
                selected: _sortMode == 'artist',
                onSelected: (_) => _changeSortMode('artist'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: displaySongs.isEmpty
              ? null
              : () => context.read<AudioProvider>().setPlaylist(displaySongs, 0),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Phát'),
        ),
      ],
    );
  }

  void _changeSortMode(String mode) {
    setState(() {
      _sortMode = mode;
      _sortSongs();
    });
  }

  Widget _buildContent(List<SongModel> displaySongs) {
    if (_isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_hasPermission && _songs.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildMessage(
          icon: Icons.lock_rounded,
          title: 'Cần quyền truy cập nhạc',
          message: 'Hãy cấp quyền audio hoặc chọn file nhạc thủ công bằng nút Import.',
          buttonText: 'Chọn file nhạc',
          onPressed: _importSongs,
        ),
      );
    }

    if (_songs.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildMessage(
          icon: Icons.music_off_rounded,
          title: 'Chưa có bài hát',
          message: 'Thêm file nhạc từ thiết bị để bắt đầu nghe offline.',
          buttonText: 'Thêm bài hát',
          onPressed: _importSongs,
        ),
      );
    }

    if (displaySongs.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildMessage(
          icon: Icons.search_off_rounded,
          title: 'Không tìm thấy',
          message: 'Thử nhập từ khóa khác hoặc xóa bộ lọc tìm kiếm.',
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) {
            return const SizedBox(height: 10);
          }

          final songIndex = index ~/ 2;
          final song = displaySongs[songIndex];
          return SongTile(
            song: song,
            onTap: () => context.read<AudioProvider>().setPlaylist(displaySongs, songIndex),
          );
        },
        childCount: displaySongs.length * 2 - 1,
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.86),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedText),
            ),
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.upload_file_rounded),
                label: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
