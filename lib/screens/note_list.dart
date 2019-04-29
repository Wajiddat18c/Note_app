import 'package:flutter/material.dart';
import 'package:note_app/screens/note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(onPressed: () {
         debugPrint("FAB clicked");

         navigateToDetail("Tilføj Notat");
      },
        tooltip: "Tilføj ny Notat",
        
        child: Icon(Icons.add),

      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.green,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.arrow_forward),
            ),
            title: Text(
              "Dummy Titel",
              style: titleStyle,
            ),
            subtitle: Text("Dummy date"),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              debugPrint("tap");
              navigateToDetail("Redigere Note");
            },
          ),
        );
      },
    );
  }


  //navigate between screens
  void navigateToDetail(String titel){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail(titel);
    }));

  }
}
