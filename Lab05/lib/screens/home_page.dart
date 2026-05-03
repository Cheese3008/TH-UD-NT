import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'note_editor_screen.dart';

class HomePage extends StatelessWidget
{
  const HomePage({super.key});

  static const Color navyColor = Color(0xFF0F172A);
  static const Color textColor = Color(0xFF111827);
  static const Color mutedColor = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color cardColor = Colors.white;
  static const Color blueColor = Color(0xFF3B82F6);
  static const Color purpleColor = Color(0xFF7C3AED);

  void openEditor(BuildContext context, {Note? note})
  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(note: note),
      ),
    );
  }

  Future<void> confirmDelete(BuildContext context, Note note) async
  {
    final provider = context.read<NoteProvider>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext)
      {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete note?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'This note will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: ()
              {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: ()
              {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: navyColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true && note.id != null)
    {
      await provider.deleteNote(note.id!);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    final provider = context.watch<NoteProvider>();
    final notes = provider.notes;

    return Scaffold(
appBar: AppBar(
  titleSpacing: 24,
  toolbarHeight: 86,
  title: Row(
    children: [
      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              blueColor,
              purpleColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x443B82F6),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      const SizedBox(width: 16),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Smart Notes',
            style: TextStyle(
              color: textColor,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
          SizedBox(height: 3),
          Text(
            'Modern workspace for your ideas',
            style: TextStyle(
              color: mutedColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  ),
),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          openEditor(context);
        },
        backgroundColor: navyColor,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add note',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 36),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHero(context, notes.length),
                  const SizedBox(height: 34),
                  buildSectionHeader(notes.length),
                  const SizedBox(height: 18),

                  if (notes.isEmpty)
                    buildEmptyState(context),

                  if (notes.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes.length,
                      separatorBuilder: (_, __)
                      {
                        return const SizedBox(height: 16);
                      },
                      itemBuilder: (context, index)
                      {
                        final note = notes[index];

                        return NoteCard(
                          note: note,
                          onTap: ()
                          {
                            openEditor(context, note: note);
                          },
                          onDelete: ()
                          {
                            confirmDelete(context, note);
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHero(BuildContext context, int noteCount)
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: navyColor,
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22111827),
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints)
        {
          final isSmall = constraints.maxWidth < 760;

          final leftContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeroBadge(),
              const SizedBox(height: 26),
              const Text(
                'Capture ideas.\nOrganize tasks.\nStay focused.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.8,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create, edit, and store your notes locally with a clean and modern interface.',
                style: TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  buildFeatureChip(Icons.edit_note_rounded, 'Quick notes'),
                  buildFeatureChip(Icons.storage_rounded, 'Local storage'),
                  buildFeatureChip(Icons.update_rounded, 'Auto timestamp'),
                ],
              ),
              const SizedBox(height: 30),
              FilledButton.icon(
                onPressed: ()
                {
                  openEditor(context);
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Create a new note',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: navyColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ],
          );

          final rightContent = buildMockupCard(noteCount);

          if (isSmall)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftContent,
                const SizedBox(height: 28),
                rightContent,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: leftContent),
              const SizedBox(width: 34),
              rightContent,
            ],
          );
        },
      ),
    );
  }

  Widget buildHeroBadge()
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            color: Color(0xFFFACC15),
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            'Flutter Notes Demo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeatureChip(IconData icon, String label)
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF334155),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMockupCard(int noteCount)
  {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 8,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 34),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  blueColor,
                  purpleColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.notes_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Notes',
            style: TextStyle(
              color: textColor,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$noteCount saved notes',
            style: const TextStyle(
              color: mutedColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),
          buildMockupStatus(
            Icons.folder_rounded,
            'Storage',
            'SQLite',
            const Color(0xFFEFF6FF),
            blueColor,
          ),
          const SizedBox(height: 12),
          buildMockupStatus(
            Icons.sync_rounded,
            'State',
            'Provider',
            const Color(0xFFF5F3FF),
            purpleColor,
          ),
        ],
      ),
    );
  }

  Widget buildMockupStatus(
    IconData icon,
    String title,
    String value,
    Color background,
    Color color,
  )
  {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionHeader(int noteCount)
  {
    return Row(
      children: [
        const Text(
          'Recent notes',
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$noteCount',
            style: const TextStyle(
              color: blueColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEmptyState(BuildContext context)
  {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(42),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  blueColor,
                  purpleColor,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.note_add_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'No notes yet',
            style: TextStyle(
              color: textColor,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Start by creating your first note.',
            style: TextStyle(
              color: mutedColor,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: ()
            {
              openEditor(context);
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create first note'),
            style: FilledButton.styleFrom(
              backgroundColor: navyColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}