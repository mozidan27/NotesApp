import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/note_database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text controller to access what the user typed

  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // on app startup , fetch existing notes
    readNote();
  }
  // create note

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // create button
          MaterialButton(
            onPressed: () {
              // add note to firebase
              context.read<NoteDatabase>().addNote(textController.text);

              //clear controller
              textController.clear();
              // close dialog

              Navigator.of(context).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  // read note

  void readNote() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update note

  // delete ntoe
  @override
  Widget build(BuildContext context) {
    // note db

    final noteDataBase = context.watch<NoteDatabase>();
    // list of notes
    List<Note> currentNote = noteDataBase.currentNNotes;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        backgroundColor: Colors.grey.shade800,
        elevation: 3,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNote.length,
        itemBuilder: (context, index) {
          // get individual note

          final note = currentNote[index];

          // list tile ui

          return ListTile(
            title: Text(note.text),
          );
        },
      ),
    );
  }
}
