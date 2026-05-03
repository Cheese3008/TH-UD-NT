import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteEditorScreen extends StatefulWidget
{
  final Note? note;

  const NoteEditorScreen({
    super.key,
    this.note,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen>
{
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  static const Color textColor = Color(0xFF0F172A);
  static const Color secondaryTextColor = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color chipColor = Color(0xFFF1F5F9);
  static const Color heroColor = Color(0xFF111827);
  static const Color cardColor = Colors.white;

  bool get isEditing => widget.note != null;

  @override
  void initState()
  {
    super.initState();

    titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );

    contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose()
  {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async
  {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter both title and content.'),
          backgroundColor: heroColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
      return;
    }

    final provider = context.read<NoteProvider>();
    final now = DateTime.now();

    if (isEditing)
    {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
        updatedAt: now,
      );

      await provider.updateNote(updatedNote);
    }
    else
    {
      final newNote = Note(
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      await provider.addNote(newNote);
    }

    if (mounted)
    {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 950),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  buildTopBar(context),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: borderColor),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 28,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: titleController,
                              style: const TextStyle(
                                color: textColor,
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Untitled note',
                                hintStyle: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 1,
                              color: borderColor,
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: TextField(
                                controller: contentController,
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  height: 1.7,
                                ),
                                decoration: const InputDecoration(
                                  hintText:
                                      'Write your note here...\n\nYou can add ideas, tasks, reminders or anything important.',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 17,
                                    height: 1.7,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: chipColor,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    isEditing ? 'Editing note' : 'New note',
                                    style: const TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                OutlinedButton(
                                  onPressed: ()
                                  {
                                    Navigator.pop(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: textColor,
                                    side: const BorderSide(color: borderColor),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 12),
                                FilledButton.icon(
                                  onPressed: saveNote,
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text('Save'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: heroColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopBar(BuildContext context)
  {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: ()
          {
            Navigator.pop(context);
          },
          style: IconButton.styleFrom(
            backgroundColor: chipColor,
            foregroundColor: textColor,
          ),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit note' : 'New note',
              style: const TextStyle(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              isEditing
                  ? 'Update your existing content'
                  : 'Create something new',
              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}