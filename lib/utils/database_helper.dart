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

  Future<Database> get database async{

    if (_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for Android/iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "notes.db";

    //create the database to path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colDescription TEXT, $colTitle TEXT, $colPriority INTEGER, $colDate TEXT");
  }

  //Fetch Operation: Get all Note objects from database
  //Insert Operation: Insert a Note object to database
  //Update Operation: Update a Note object and save it to database
  //Delete Operation: Delete a Note object from database
  //Get number of Note object in database
}
