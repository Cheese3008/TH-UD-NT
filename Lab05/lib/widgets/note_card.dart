import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget
{
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  static const Color textColor = Color(0xFF111827);
  static const Color mutedColor = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color blueColor = Color(0xFF3B82F6);
  static const Color purpleColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context)
  {
    final dateFormat = DateFormat('dd MMM yyyy • HH:mm');
    final firstLetter =
        note.title.trim().isEmpty ? 'N' : note.title.trim()[0].toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAvatar(firstLetter),
                const SizedBox(width: 18),
                Expanded(
                  child: buildContent(dateFormat),
                ),
                const SizedBox(width: 14),
                buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatar(String letter)
  {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            blueColor,
            purpleColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x333B82F6),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget buildContent(DateFormat dateFormat)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          note.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: mutedColor,
            fontSize: 15,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            buildChip(
              Icons.schedule_rounded,
              dateFormat.format(note.updatedAt),
              const Color(0xFFEFF6FF),
              blueColor,
            ),
            buildChip(
              Icons.storage_rounded,
              'Local',
              const Color(0xFFF5F3FF),
              purpleColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildChip(
    IconData icon,
    String text,
    Color background,
    Color color,
  )
  {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActions()
  {
    return Column(
      children: [
        IconButton(
          onPressed: onDelete,
          tooltip: 'Delete note',
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Color(0xFFEF4444),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: textColor,
            size: 19,
          ),
        ),
      ],
    );
  }
}