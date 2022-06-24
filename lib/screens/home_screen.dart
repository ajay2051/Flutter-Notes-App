import 'package:flutter/material.dart';
import 'package:notes_app/models/models.dart';
import '../db/database.dart';
import 'add_note.dart';
import 'noteDetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required String title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // function to get all notes stored in database
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  static const String addNote = 'addNote';
  // static const String noteDetails = 'noteDetails';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // String? firstNoteTitle;
  // String? firstNoteDescription;

  Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case addNote:
        return MaterialPageRoute(builder: (context) => const AddNote());
      default:
        throw ('this route name does not exist');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
        centerTitle: true,
        title: const Text('All Notes'),
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (context, AsyncSnapshot noteData) {
          switch (noteData.connectionState) {
            case ConnectionState.waiting:
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            case ConnectionState.done:
              {
                if (noteData.data == null) {
                  return const Center(
                    child: Text('No Notes Added'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: noteData.data?.length,
                      itemBuilder: (context, index) {
                        NoteModel item = NoteModel.fromJson(noteData.data[index]);
                        String title = item.title??"";
                        String description =
                            noteData.data[index]['description'];
                        // String dateCreated =
                        //     noteData.data[index]['dateCreated'];
                        // int id = noteData.data![index]['id'];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoteDetail(
                                          note: item)));
                            },
                            title: Text(title),
                            subtitle: Text(description, overflow: TextOverflow.ellipsis,),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
          }
          return Container();
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "Ajay",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("ajay@gmail.com"),
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' My Course '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text(' Go Premium '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Saved Videos '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ), //Drawer
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNote()));
        },
        child: const Icon(
          Icons.save,
          size: 30,
        ),
      ),
    );
  }
}
