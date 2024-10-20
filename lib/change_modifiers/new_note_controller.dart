import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models_note.dart';
import 'notesprovider.dart';

class NewNoteController extends ChangeNotifier {
  Note? _note;

  set note(Note? value) {
    _note = value;
    _title = _note?.title ?? ''; // Safely access title
    _content = _note?.contentJson ?? ''; // Initialize contentJson as content
    notifyListeners();
  }

  Note? get note => _note;

  bool _readOnly = false;

  set readOnly(bool value) {
    _readOnly = value;
    notifyListeners();
  }

  bool get readOnly => _readOnly;

  String _title = '';

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get title => _title.trim();

  String _content = '';

  set content(String value) {
    _content = value;
    notifyListeners();
  }

  String get content => _content;

  bool get isNewNote => _note == null;

  bool get canSaveNote {
    final String? newTitle = title.isNotEmpty ? title : null;
    final String? newContent = content
        .trim()
        .isNotEmpty ? content.trim() : null;

    bool canSave = newTitle != null || newContent != null;
    if (!isNewNote) {
      canSave &= newTitle != note!.title || newContent != note!.content?.trim();
    }
    return canSave;
  }

  Future<void> saveNote(BuildContext context) async {
    final String? newTitle = title.isNotEmpty ? title : null;
    final String? newContent = content
        .trim()
        .isNotEmpty ? content.trim() : null;


    final String contentJson = jsonEncode(newContent);


    final int now = DateTime
        .now()
        .microsecondsSinceEpoch;


    final note = Note(
      id: isNewNote ? '' : _note!.id,

      title: newTitle,
      content: newContent,
      contentJson: contentJson,
      dateCreated: isNewNote ? now : _note!.dateCreated,
      dateModified: now,
    );

    final notesProvider = context.read<NotesProvider>();

    if (isNewNote) {
      await notesProvider.addNote(note);
    } else {
      await notesProvider.updateNote(note);
    }
  }
}
