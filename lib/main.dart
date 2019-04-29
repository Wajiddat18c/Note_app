import 'package:flutter/material.dart';
import 'package:note_app/screens/note_list.dart';

void main(){
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Husk Mine Noter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: NoteList()
    );
  }
}
