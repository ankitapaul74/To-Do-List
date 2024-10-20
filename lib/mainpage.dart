import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'change_modifiers/new_note_controller.dart';
import 'change_modifiers/notesprovider.dart';
import 'fl_page.dart';
import 'models_note.dart';
import 'nonotes.dart';
import 'note_grid.dart';
import 'notes_list.dart'; // Import FirebaseAuth

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final List<String> dropdownOptions = ['Date Modified', 'Date Created'];
  String dropdownValue = 'Date Modified';
  bool isDescending = true;
  bool isGrid = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user

      if (currentUser != null) {
        await context.read<NotesProvider>().fetchNotes(); // Fetch notes for the logged-in user
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keep Notes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => NewNoteController(),
                child: flpage(isNewNote: true),
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white),
        ),
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {

          List<Note> notes = notesProvider.notes;


          List<Note> filteredNotes = notes.where((note) {
            final query = searchQuery.toLowerCase();
            final titleLower = note.title?.toLowerCase() ?? '';
            final contentLower = note.content?.toLowerCase() ?? '';
            return titleLower.contains(query) || contentLower.contains(query);
          }).toList();


          filteredNotes.sort((a, b) {
            int compare;
            if (dropdownValue == 'Date Modified') {
              compare = a.dateModified.compareTo(b.dateModified);
            } else {
              compare = a.dateCreated.compareTo(b.dateCreated);
            }
            return isDescending ? compare * -1 : compare;
          });


          if (notes.isEmpty) {
            return const Nonotes();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search notes",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isDescending = !isDescending;
                          });
                        },
                        icon: Icon(
                          isDescending ? Icons.arrow_downward : Icons.arrow_upward,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: BoxConstraints(),
                        iconSize: 18,
                      ),
                      SizedBox(width: 16),

                      DropdownButton(
                        value: dropdownValue,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_downward, size: 18),
                        ),
                        underline: SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(16),
                        isDense: true,
                        items: dropdownOptions
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Text(e),
                              if (e == dropdownValue) ...[
                                SizedBox(width: 8),
                                Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                              ],
                            ],
                          ),
                        ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                      Spacer(),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            isGrid = !isGrid;
                          });
                        },
                        icon: Icon(
                          isGrid ? Icons.table_chart : Icons.menu_outlined,
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        constraints: BoxConstraints(),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredNotes.isEmpty

                      ? Center(
                    child: Text(
                      'No notes found',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  )
                      : isGrid
                      ? NotesGrid(notes: filteredNotes)
                      : NotesList(notes: filteredNotes),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
