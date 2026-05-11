import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../providers/playlist_provider.dart';
import '../services/playlist_service.dart';
import '../utils/constants.dart';
import '../widgets/playlist_card.dart';
import '../widgets/song_tile.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(context),
                const SizedBox(height: 18),
                Consumer<PlaylistProvider>(
                  builder: (context, provider, child) {
                    final totalSongs = provider.playlists.fold<int>(
                      0,
                      (sum, playlist) => sum + playlist.songIds.length,
                    );
                    return _buildSummaryCard(provider.playlists.length, totalSongs);
                  },
                ),
                const SizedBox(height: 18),
                const Text(
                  'Danh sách phát',
                  style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
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
          sliver: Consumer<PlaylistProvider>(
            builder: (context, provider, child) {
              if (!provider.isLoaded) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (provider.playlists.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) {
                      return const SizedBox(height: 12);
                    }

                    final playlistIndex = index ~/ 2;
                    final playlist = provider.playlists[playlistIndex];
                    return PlaylistCard(
                      playlist: playlist,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaylistDetailScreen(playlistId: playlist.id),
                          ),
                        );
                      },
                      onRename: () => _showRenameDialog(context, playlist),
                      onDelete: () => provider.deletePlaylist(playlist.id),
                    );
                  },
                  childCount: provider.playlists.length * 2 - 1,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Playlist',
                style: TextStyle(color: AppColors.text, fontSize: 32, height: 1, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 6),
              Text('Tạo bộ sưu tập nhạc theo tâm trạng', style: TextStyle(color: AppColors.mutedText)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: AppGradients.warm,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.soft,
          ),
          child: IconButton(
            onPressed: () => _showCreateDialog(context),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(int playlistCount, int totalSongs) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.86),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppGradients.warm,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bộ sưu tập cá nhân',
                  style: TextStyle(color: AppColors.text, fontSize: 17, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  '$playlistCount playlist • $totalSongs bài hát đã lưu',
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.84),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.queue_music_rounded, color: AppColors.accent, size: 38),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có playlist',
              style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tạo playlist để gom các bài hát yêu thích của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tạo playlist'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Tạo playlist'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Tên playlist'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            FilledButton(
              onPressed: () {
                context.read<PlaylistProvider>().createPlaylist(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Tạo'),
            ),
          ],
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context, PlaylistModel playlist) {
    final controller = TextEditingController(text: playlist.name);
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Đổi tên playlist'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Tên mới'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
            FilledButton(
              onPressed: () {
                context.read<PlaylistProvider>().renamePlaylist(playlist.id, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
}

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final PlaylistService _playlistService = PlaylistService();
  List<SongModel> _allSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final songs = await _playlistService.getAllSongs();
    if (!mounted) return;
    setState(() {
      _allSongs = songs;
      _isLoading = false;
    });
  }

  Future<void> _importSongs() async {
    final picked = await _playlistService.pickAudioFiles();
    if (!mounted) return;
    setState(() {
      final existing = _allSongs.map((song) => song.filePath).toSet();
      _allSongs = [
        ..._allSongs,
        ...picked.where((song) => !existing.contains(song.filePath)),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.background),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Consumer<PlaylistProvider>(
            builder: (context, provider, child) {
              final playlist = provider.getPlaylistById(widget.playlistId);
              return Text(playlist?.name ?? 'Playlist');
            },
          ),
          actions: [
            IconButton(
              onPressed: _importSongs,
              icon: const Icon(Icons.upload_file_rounded),
              tooltip: 'Import songs',
            ),
            IconButton(
              onPressed: () => _showAddSongSheet(context),
              icon: const Icon(Icons.playlist_add_rounded),
              tooltip: 'Add songs',
            ),
          ],
        ),
        body: Consumer<PlaylistProvider>(
          builder: (context, playlistProvider, child) {
            final playlist = playlistProvider.getPlaylistById(widget.playlistId);
            if (playlist == null) {
              return const Center(child: Text('Không tìm thấy playlist'));
            }

            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final songs = _allSongs.where((song) => playlist.songIds.contains(song.id)).toList();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  sliver: SliverToBoxAdapter(child: _buildPlaylistHero(context, playlist, songs)),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  sliver: songs.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyPlaylist(context),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index.isOdd) {
                                return const SizedBox(height: 10);
                              }

                              final songIndex = index ~/ 2;
                              final song = songs[songIndex];
                              return Dismissible(
                                key: ValueKey(song.id),
                                background: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                                ),
                                onDismissed: (_) {
                                  playlistProvider.removeSongFromPlaylist(playlist.id, song.id);
                                },
                                child: SongTile(
                                  song: song,
                                  onTap: () => context.read<AudioProvider>().setPlaylist(songs, songIndex),
                                ),
                              );
                            },
                            childCount: songs.length * 2 - 1,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistHero(BuildContext context, PlaylistModel playlist, List<SongModel> songs) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppGradients.warm,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.album_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
                  style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text('${songs.length} bài hát', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: songs.isEmpty ? null : () => context.read<AudioProvider>().setPlaylist(songs, 0),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Phát'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaylist(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.84),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.playlist_add_rounded, color: AppColors.secondary, size: 62),
            const SizedBox(height: 12),
            const Text(
              'Playlist đang trống',
              style: TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bấm nút thêm để đưa bài hát vào playlist này.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => _showAddSongSheet(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Thêm bài hát'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSongSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        if (_allSongs.isEmpty) {
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.all(14),
              height: 240,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: FilledButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _importSongs();
                  },
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Import bài hát trước'),
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.78,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(99)),
                ),
                const SizedBox(height: 14),
                const Row(
                  children: [
                    Icon(Icons.playlist_add_rounded, color: AppColors.secondary),
                    SizedBox(width: 10),
                    Text('Thêm bài hát', style: TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _allSongs.length,
                    itemBuilder: (context, index) {
                      final song = _allSongs[index];
                      return ListTile(
                        leading: const Icon(Icons.music_note_rounded, color: AppColors.secondary),
                        title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                          onPressed: () {
                            context.read<PlaylistProvider>().addSongToPlaylist(widget.playlistId, song.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã thêm ${song.title}')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
