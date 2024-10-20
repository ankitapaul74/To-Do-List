
import 'package:flutter/material.dart';

import 'models_note.dart';
import 'note_card.dart';

class NotesList extends StatelessWidget {
  const NotesList({
    required this.notes,
    super.key});
  final List<Note> notes;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:notes.length,itemBuilder:(context,index){

      return NoteCard(
        note: notes[index],
        isInGrid: false,);
    },);
  }
}
