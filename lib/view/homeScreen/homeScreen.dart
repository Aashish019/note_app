import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/services/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //firestore
  final FireStoreService fireStoreService = FireStoreService();
  //text controller
  TextEditingController textController = TextEditingController();

  //open dialog box toadd note
  void openNoteBox({String? docId}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          decoration: InputDecoration(hintText: 'Add new note'),
          controller: textController,
        ),
        actions: [
          //button to save
          ElevatedButton(
            onPressed: () {
              //add note
              if (docId == null) {
                fireStoreService.addNote(textController.text);
              } else {
                fireStoreService.updateNote(docId, textController.text);
              }
              //clear note
              textController.clear();
              //close the box
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('NOTE APP',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getReadNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            //display as list
            return ListView.builder(
                itemCount: noteList.length,
                itemBuilder: (context, index) {
                  //get each insividual doc
                  DocumentSnapshot document = noteList[index];
                  String docId = document.id;

                  //get doc from each note
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  //display as a list tile
                  return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openNoteBox(docId: docId),
                            icon: const Icon(Icons.settings),
                          ),
                          IconButton(
                            onPressed: () => fireStoreService.deleteNote(docId),
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ],
                      ));
                });
          } else {
            return const Text('No notes..');
          }
        },
      ),
    );
  }
}
