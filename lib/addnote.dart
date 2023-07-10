import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  final notetitleController = TextEditingController();
  final notedescriptionController = TextEditingController();

  bool loading = false;
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  final databaseRef = FirebaseDatabase.instance.ref('Note');

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        centerTitle: false,
        title: Text('Add List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),

            TextFormField(
              maxLines: 2,
              controller: notetitleController,
              onFieldSubmitted: (value){
                notetitleController.clear();
              },
              decoration: InputDecoration(
                hintText: 'Enter title here',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 10,
              controller: notedescriptionController,
              onFieldSubmitted: (value){
                notedescriptionController.clear();
              },
              decoration: InputDecoration(
                  hintText: 'Enter description here...',
                  border: OutlineInputBorder()
              ),

            ),
            SizedBox(
              height: 30,
            ),
        ElevatedButton(
                child: Text(
                    "Add List".toUpperCase(),
                    style: TextStyle(fontSize: 14)
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(color: Colors.blue)
                        )
                    )
                ),
                onPressed: () => databaseRef.child(id).set({
                  'id' : id,
                  'title' : notetitleController.text.toString(),
                  'description' : notedescriptionController.text.toString(),
                }).then((value){
                  notedescriptionController.clear();
                  notetitleController.clear();
                      var message = 'Note added';
                      message.toString();

                }).onError((error, stackTrace){
                      error.toString();
                }),
            )
          ],
        ),
      )

    );
  }

}
