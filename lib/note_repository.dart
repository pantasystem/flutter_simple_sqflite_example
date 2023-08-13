
import 'package:hello_sqflite/database.dart';

class NoteRepository {
  // データベースのインスタンスを取得
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<Note> create({required String title, required String content}) async {
    final db = await _databaseHelper.database;
    db.insert(NoteTableInfo.tableName, {
      NoteTableInfo.columnTitle: title,
      NoteTableInfo.columnContent: content,
      NoteTableInfo.columnDate: DateTime.now().toIso8601String(),
    });
    // 最後に追加したデータのIDを取得
    final lastElement = await db.query(NoteTableInfo.tableName, orderBy: "${NoteTableInfo.columnId} DESC", limit: 1);
    // 最後に追加したデータを返す
    return Note.fromMap(lastElement.first);
  }

  /// データベースからnotesテーブルに関する全てのデータを取得する
  Future<List<Note>> findAll() async {
    final db = await _databaseHelper.database;
    final result = await db.query(NoteTableInfo.tableName, orderBy: "${NoteTableInfo.columnId} DESC");
    return result.map((json) => Note.fromMap(json)).toList();
  }

  /// idを指定してデータベースからデータを取得する
  Future<Note> findById(int id) async {
    final db = await _databaseHelper.database;

    /// ?はプレースホルダーと呼ばれるもので、SQL文の中に埋め込むことができる
    /// 使用する理由としては、SQLインジェクションという攻撃を防ぐためです。
    final result = await db.query(NoteTableInfo.tableName, where: "${NoteTableInfo.columnId} = ?", whereArgs: [id]);
    return Note.fromMap(result.first);
  }

  /// タイトルを指定してデータベースからデータを取得する
  Future<List<Note>> searchByTitle(String title) async {
    final db = await _databaseHelper.database;

    /// ?はプレースホルダーと呼ばれるもので、SQL文の中に埋め込むことができる
    /// 使用する理由としては、SQLインジェクションという攻撃を防ぐためです。
    ///
    /// %はワイルドカードと呼ばれるもので、任意の文字列を表します。
    /// この場合前方、後方に任意の文字列がある場合にマッチします。
    /// 例えば、titleが"Hello"の場合、"Hello World"や"Hello Flutter"にマッチします。
    /// LIKE演算子は大文字小文字を区別しないので、"hello"や"HELLO"にもマッチします。
    final result = await db.query(NoteTableInfo.tableName, where: "${NoteTableInfo.columnTitle} LIKE ?", whereArgs: ["%$title%"]);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  /// データベースからデータを削除する
  Future<void> delete(int id) async {
    final db = await _databaseHelper.database;
    await db.delete(NoteTableInfo.tableName, where: "${NoteTableInfo.columnId} = ?", whereArgs: [id]);
  }

  /// データベースのデータを更新する
  Future<Note> update(Note note) async {
    final db = await _databaseHelper.database;
    await db.update(NoteTableInfo.tableName, note.toMap(), where: "${NoteTableInfo.columnId} = ?", whereArgs: [note.id]);
    return note;
  }
}
