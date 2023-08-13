import 'package:flutter/material.dart';
import 'package:hello_sqflite/editor_page.dart';
import 'package:hello_sqflite/note_detail_page.dart';
import 'package:hello_sqflite/note_repository.dart';

import 'database.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State createState() {
    return NoteListPageState();
  }
}

class NoteListPageState extends State<NoteListPage> {
  List<Note> _notes = [];

  _getNotes() async {
    final notes = await NoteRepository().findAll();
    setState(() {
      _notes = notes;
    });
  }

  @override
  void initState() {
    _getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("メモ一覧"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            onTap: () async  {
              // 詳細画面に遷移している
              // 前の画面から戻ってくるのを待機する
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ),
              );
              // 前の画面から戻ってきたら画面の内容を更新する
              _getNotes();
            },
          );
        },
        itemCount: _notes.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final note = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditorPage(),
            ),
          );
          if (note != null) {
            // 編集画面から戻ってきたら再取得している
            _getNotes();
          }
        },
      ),
    );
  }
}
