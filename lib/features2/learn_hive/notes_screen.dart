import 'package:buynow/features2/learn_hive/box.dart';
import 'package:buynow/features2/learn_hive/note_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final titleController = TextEditingController();
  final desController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Add Notes"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(controller: titleController),
                    SizedBox(height: 20),
                    TextFormField(controller: desController),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      titleController.clear();
                      desController.clear();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      final notes = NoteModel(
                        title: titleController.text,
                        descripton: desController.text,
                      );
                      final box = Boxs.getData();
                      box.add(notes);
                      notes.save();
                      titleController.clear();
                      desController.clear();
                      Get.back();
                    },
                    child: Text("Save"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("NoteScreen")),
      body: ValueListenableBuilder(
        valueListenable: Boxs.getData().listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(child: Text("No note please add notes"));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index) as NoteModel;
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.descripton),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        note.delete();
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            titleController.text = note.title;
                            desController.text = note.descripton;
                            return AlertDialog(
                              title: Text("Edit Notes"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(controller: titleController),
                                  SizedBox(height: 20),
                                  TextFormField(controller: desController),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    titleController.clear();
                                    desController.clear();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    note.title = titleController.text;
                                    note.descripton = desController.text;
                                    note.save();
                                    Get.back();
                                  },
                                  child: Text("Edit"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
