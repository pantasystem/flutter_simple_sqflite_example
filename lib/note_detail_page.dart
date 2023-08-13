import 'package:flutter/material.dart';
import 'package:hello_sqflite/database.dart';
import 'package:hello_sqflite/note_repository.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({Key? key, required this.noteId}) : super(key: key);
  final int noteId;

  @override
  State<StatefulWidget> createState() {
    return NoteDetailPageState();
  }
}

class NoteDetailPageState extends State<NoteDetailPage> {

  Note? _note;

  void _getNote() async {
    // 指定されたnoteIdを元に、データーベースから該当するNoteを取得して、
    // 取得に成功したらsetStateで変数に反映した上で画面を更新している。
    final note = await NoteRepository().findById(widget.noteId);
    setState(() {
      _note = note;
    });
  }

  @override
  void initState() {
    _getNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_note?.title ?? ""),
        actions: [
          IconButton(onPressed: () {
            // 削除処理
            NoteRepository().delete(widget.noteId).then((value) {
              // 成功したら前の画面に戻る
              Navigator.of(context).pop();
            });
          } , icon: const Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_note?.content ?? ""),
        ),
      ),
    );
  }
}
