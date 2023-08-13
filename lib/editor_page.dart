import 'package:flutter/material.dart';
import 'package:hello_sqflite/database.dart';
import 'package:hello_sqflite/note_repository.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NoteEditorPageState();
  }
}

class NoteEditorPageState extends State<NoteEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<Note> _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;
    return NoteRepository().create(title: title, content: content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("メモの編集"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveNote().then((note) {
                Navigator.pop(context, note);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "メモのタイトル",
              ),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "メモの内容",
              ),
            ),
          ],
        ),
      )
    );
  }
}
