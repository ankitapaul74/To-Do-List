import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todooo/utils.dart';


import 'change_modifiers/new_note_controller.dart';
import 'change_modifiers/notesprovider.dart';
import 'fl_page.dart';
import 'models_note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.note,
    required this.isInGrid,
    super.key});
  final   Note note;
  final bool isInGrid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>ChangeNotifierProvider(
          create:(_)=>NewNoteController()..note=note,
          child: const flpage(
            isNewNote:false,
          ),
        )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(

          decoration:BoxDecoration(
              color:Colors.white,
              border:Border.all(color:Colors.deepPurpleAccent),
              borderRadius: BorderRadius.circular(12),
              boxShadow:[
                BoxShadow(color:Colors.deepPurpleAccent.withOpacity(0.2),
                  offset: Offset(4, 4),
                )
              ]
          ),
          padding: EdgeInsets.all(12),
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: [
              if(note.title!=null)...[
                Text
                  (
                  note.title!,
                  maxLines: 1,
                  overflow:TextOverflow.ellipsis ,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,
                      color:Colors.grey.shade900 ),),
                SizedBox(height: 4,),],
              if(note.content!=null)
                isInGrid?
                Expanded(child: Text(note.content!,
                  maxLines:3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color:Colors.grey.shade700),)
                ):
                Text(note.content!,style: TextStyle(color:Colors.grey.shade700),),
              if(isInGrid) Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    toShortDate(note.dateModified),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500
                  ),),
                  GestureDetector(
                      onTap:() {

                        _showDeleteConfirmationDialog(context,note);
                      },
                      child: Icon(Icons.delete_rounded,color:Colors.grey.shade500,size: 20,))
                ],
              )

            ],),
        ),
      ),
    );
  }
}
void _showDeleteConfirmationDialog(BuildContext context, Note note) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesProvider>().deleteNote(note);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}




