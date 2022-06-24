import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';

// database provider class
class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  Database? _database;

//creating getter database
  Future<Database> get database async {
//lets check the database already exists or not

    if (kDebugMode) {
      print("database $_database");
    }
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var dbPath = (path);

    return await openDatabase(join(dbPath, 'notesapp.db'),
        onCreate: (db, version) async {
// create first table
      await db.execute('''
CREATE TABLE notes(
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT,
description TEXT,
dateCreated DATE
)
''');
    }, version: 1);
  }

// function that will add new note to our variable
  addNewNote(NoteModel note) async {
    final db = await database;
    var res = await db.insert("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  updateNewNote(NoteModel note) async {
    final db = await database;
    var res = await db.update("notes", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

// function that will fetch our database and return all elements inside notes table
  Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db.query('notes');
    if (res.isEmpty) {
      return null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : null;
    }
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    var count = await db.rawDelete('DELETE FROM notes WHERE id = ?', [id]);
    return count;
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    var update = await db.rawUpdate(
      'UPDATE  notes SET  title = ?, description = ?, dateCreated = ? WHERE  id = ?',
      [note.title, note.description,note.dateCreated,note.id, ]
    );
    // var update = await db.update("notes", note.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    return update;
  }
}
