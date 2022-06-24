import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/screens/home_screen.dart';
import '../db/database.dart';
import '../models/models.dart';

class NoteDetail extends StatefulWidget {
  final NoteModel note;
  const NoteDetail({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late String title;
  late String description;
  late DateTime dateCreated;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool editable = true;

  updateNotes(NoteModel note) async {
    if (kDebugMode) {
      print('note ${note.toMap()}');
    }
    var res = await DatabaseProvider.db.updateNewNote(note);

    if (kDebugMode) {
      print('Note Added Successfully');
      print('res $res');

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note added Successfully")));
    }
  }

  @override
  void initState() {
    titleController.text = widget.note.title!;
    descriptionController.text = widget.note.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              DatabaseProvider.db.deleteNote(widget.note.id!);
              // Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(title: '')));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Created :${widget.note.dateCreated}"),
              TextField(
                onTap: () {
                  setState(() {
                    editable = false;
                  });
                },
                readOnly: editable,
                controller: titleController,
                style: const TextStyle(
                    fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                onTap: () {
                  setState(() {
                    editable = false;
                  });
                },
                maxLines: 10,
                readOnly: editable,
                controller: descriptionController,
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          NoteModel note = NoteModel(
            id: widget.note.id,
            title: titleController.text,
            description: descriptionController.text,
            dateCreated: DateTime.now().toString(),
          );
          // updateNote(note);
          await DatabaseProvider.db.updateNote(note);

          // now when we save it will automatically return to homepage
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen(
                        title: '',
                      )));
        },
        label: const Text('Update Note'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  // function to delete an item
  Future<int> deleteNote(int id) async {
    return await DatabaseProvider.db.deleteNote(id);
  }
}
