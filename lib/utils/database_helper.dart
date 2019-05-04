import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:note_app/models/note.dart';

class DatabaseHelper {
//Singelton DatabaseHelper - one instance
  static DatabaseHelper _databaseHelper;
  //Singelton Database - one instance
  static Database _database;

  String noteTable = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "prioity";
  String colDate = "date";

  //Named constructor to create instance of DatabaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // This is only executed ones - singleton object
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for Android/iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    //create the database to path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colDescription TEXT, $colTitle TEXT, $colPriority INTEGER, $colDate TEXT");
  }

  //Fetch Operation: Get all Note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC");

    return result;
  }

  //Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: "$colId = ?", whereArgs: [note.id]);
    return result;
  }

  //Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete("DELETE FROM $noteTable WHERE $colId = $id");
    return result;
  }
  //Get number of Note object in database
  Future<int>getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery("SELECT COUNT (*) from $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //Get Map list and convert into Note list
  Future<List<Note>> getNoteList() async{

    //Get Map List from database
    var noteMapList = await getNoteMapList();
    //count the number of map entries in db table
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    //for loop to create a "Note List" from "Map List"
    for (int i = 0; i < count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
