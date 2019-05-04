import 'package:flutter/material.dart';
import 'dart:async';
import 'package:note_app/models/note.dart';
import 'package:note_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  static var _priorities = ["Høj", "Lav"];

  DatabaseHelper helper = DatabaseHelper();

  Note note;
  String appBarTitle;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                //first element in listview
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Text(
                          "Prioritering:",
                          style: textStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: DropdownButton(
                            items: _priorities.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            style: textStyle,
                            value: getPriorityAsString(note.priority),
                            onChanged: (valueSelectedByUser) {
                              setState(() {
                                debugPrint(
                                    "User selected $valueSelectedByUser");
                                updatePriorityAsInt(valueSelectedByUser);
                              });
                            }),
                      ),
                    ),
                  ],
                ),

                //second element in listview
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Somechanges in Titel field");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: "Titel",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                //Third element in listview

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Somechanges in description field");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: "Indhold",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                //Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Gem",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Save was clicked");
                              });
                            }),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Slet",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("slet was clicked");
                              });
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  //Convert the Sting priority as int before saving in database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case "Høj":
        note.priority = 1;
        break;
      case "Lav":
        note.priority = 2;
        break;
    }
  }

  //convert int to sting and display
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // "høj"
        break;
      case 2:
        priority = _priorities[1]; // "lav"
        break;
    }
    return priority;
  }

  //Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  //Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  //Save data to database
  void _save() async {



    int result;
    if (note.id != null) {
      //Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      //Case 2: Insert operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      //Success
      _showAlertDialog("Status", "Note blev gemt");
    } else {
      //Failure
      _showAlertDialog("Status", "Note blev ikke gemt");
    }
  }

  _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,builder: (_) => alertDialog);
  }
}
