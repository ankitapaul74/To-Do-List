import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todooo/utils.dart';

import 'change_modifiers/new_note_controller.dart';
import 'models_note.dart';

class NoteMetadata extends StatelessWidget {
  const NoteMetadata({super.key, Note? note});

  @override
  Widget build(BuildContext context) {
    // Access NewNoteController using context.watch to listen for changes
    final newNoteController = context.watch<NewNoteController>();
    final note = newNoteController.note;

    // Only display metadata if the note is not null
    if (note == null) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Last Modified",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(toLongDate(note.dateModified)),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Created",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(toLongDate(note.dateCreated)),
            ),
          ],
        ),
      ],
    );
  }
}
