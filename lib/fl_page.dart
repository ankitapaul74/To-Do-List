import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'change_modifiers/new_note_controller.dart';
import 'note_metadata.dart';

class flpage extends StatefulWidget {
  const flpage({
    required this.isNewNote,
    super.key,
  });

  final bool isNewNote;

  @override
  State<flpage> createState() => _flpageState();
}

class _flpageState extends State<flpage> {
  late final FocusNode focusNode;
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final NewNoteController newNoteController;

  @override
  void initState() {
    super.initState();

    newNoteController = context.read<NewNoteController>();
    titleController = TextEditingController(text: newNoteController.title);
    contentController = TextEditingController(text: newNoteController.content);
    focusNode = FocusNode();
    titleController.addListener(() {
      newNoteController.title = titleController.text;
    });

    contentController.addListener(() {
      newNoteController.content = contentController.text;
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isNewNote) {
        focusNode.requestFocus();
        newNoteController.readOnly = false;
      } else {
        newNoteController.readOnly = true;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!newNoteController.readOnly &&
            (newNoteController.title.isNotEmpty || newNoteController.content.isNotEmpty)) {
          bool? saveNote = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Save Note?"),
                content: const Text("Do you want to save the note before exiting?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Discard changes
                    },
                    child: const Text("Discard"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Save changes
                    },
                    child: const Text("Save"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(null); // Cancel exit
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );

          if (saveNote == true) {
            newNoteController.saveNote(context);
            return true; // Exit the page
          } else if (saveNote == false) {
            return true; // Exit the page without saving
          } else {
            return false; // Cancel the exit
          }
        } else {
          return true; // Allow exit if read-only or no changes
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isNewNote ? "New Note" : "Edit Note",
            style: const TextStyle(color: Colors.deepPurpleAccent),
          ),
          backgroundColor: Colors.white,
          actions: [
            Selector<NewNoteController, bool>(
              selector: (context, newNoteController) => newNoteController.readOnly,
              builder: (context, readOnly, child) => IconButton(
                onPressed: () {
                  newNoteController.readOnly = !readOnly;

                  if (newNoteController.readOnly) {
                    FocusScope.of(context).unfocus();
                  } else {
                    focusNode.requestFocus();
                  }
                },
                icon: Icon(readOnly ? Icons.edit : Icons.menu_book),
                color: Colors.deepPurpleAccent,
                iconSize: 30,
              ),
            ),
            Selector<NewNoteController, bool>(
              selector: (_, newNoteController) => newNoteController.canSaveNote,
              builder: (_, canSaveNote, __) => IconButton(
                onPressed: canSaveNote
                    ? () {
                  newNoteController.saveNote(context);
                  Navigator.pop(context);
                }
                    : null,
                icon: const Icon(Icons.check_box),
                color: Colors.deepPurpleAccent,
                iconSize: 30,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Selector<NewNoteController, bool>(
                selector: (context, controller) => controller.readOnly,
                builder: (context, readOnly, child) => TextField(
                  controller: titleController,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: InputBorder.none,
                  ),
                  canRequestFocus: !readOnly,
                  readOnly: readOnly, // Prevent editing if read-only
                ),
              ),
              NoteMetadata(note: newNoteController.note),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Colors.grey.shade500, thickness: 2),
              ),
              Expanded(
                child: Selector<NewNoteController, bool>(
                  selector: (_, controller) => controller.readOnly,
                  builder: (_, readOnly, __) => TextField(
                    controller: contentController,
                    decoration: const InputDecoration(hintText: "Note here.."),
                    focusNode: focusNode,
                    readOnly: readOnly,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
