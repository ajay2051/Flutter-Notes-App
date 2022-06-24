import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../db/database.dart';
import '../models/models.dart';
import 'home_screen.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  // lets create addNote function
  late String title;
  late String description;
  late DateTime dateCreated;
// create input controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addNote(NoteModel note) async {
    print('note ${note.toMap()}');
    var res = await DatabaseProvider.db.addNewNote(note);

    if (kDebugMode) {
      print('Note Added Successfully');
      print('res $res');

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note added Successfully")));
    }
  }

  Map<String, dynamic> formData = {};

  // final _formKey = GlobalKey<FormState>();

  // String title = '', description = '';

  static const String homeScreen = 'homeScreen';

  Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
            builder: (context) => const HomeScreen(
                  title: '',
                ));
      default:
        throw ('this route name does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(fontSize: 30),
              decoration: const InputDecoration(hintText: 'title'),
              controller: titleController,
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "description"),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            title = titleController.text;
            description = descriptionController.text;
            dateCreated = DateTime.now();
          });
          NoteModel note = NoteModel(
            title: title,
            description: description,
            dateCreated: dateCreated.toString(),
          );
          addNote(note);
          // now when we save it will automatically return to homepage
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomeScreen(
                        title: '',
                      )));
        },
        label: const Text('Save Note'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  // buttonClick() {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     // Navigator.pop(context, title);
  //
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => const HomeScreen(
  //                   title: '',
  //                 )));
  //     formData;
  //   }
  // }
}
