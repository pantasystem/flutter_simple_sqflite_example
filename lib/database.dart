
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static get _databaseName => "MyDatabase.db";
  static get _databaseVersion => 1;

  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }


  /// 初期化する時に呼び出される
  Future _onCreate(Database db, int version) async {

    // noteテーブルを作成している
    // AUTOINCREMENTは自動でIDを割り振るためのもの
    // この場合はidという名前のカラムが自動で作成され、1から始まる連番が割り振られる
    // テーブルを作成する場合CREATE TABLE テーブル名()という形で記述する
    await db.execute('''
      CREATE TABLE ${NoteTableInfo.tableName} (
        ${NoteTableInfo.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${NoteTableInfo.columnTitle} TEXT NOT NULL,
        ${NoteTableInfo.columnContent} TEXT NOT NULL,
        ${NoteTableInfo.columnDate} TEXT NOT NULL
      )
    ''');
  }

}

/// 作成したメモの情報を保持するためのテーブルの情報を定数として定義している
class NoteTableInfo {
  static get tableName => "notes";
  static get columnId => "id";
  static get columnTitle => "title";
  static get columnContent => "content";
  static get columnDate => "date";
}

/// メモの情報を保持するためのクラス
/// メモの情報をクラスとして保持した方が扱いやすくなるため、
/// データベースから読み出した情報をこのNoteクラスに変換して扱う
class Note {
  int? id;
  String title;
  String content;
  String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  // データベースから取得したデータをNoteクラスに変換するためのメソッド
  // Map<String, dynamic>型のデータを引数に取り、Noteクラスのインスタンスを返す
  factory Note.fromMap(Map<String, dynamic> json) => Note(
    id: json[NoteTableInfo.columnId],
    title: json[NoteTableInfo.columnTitle],
    content: json[NoteTableInfo.columnContent],
    date: json[NoteTableInfo.columnDate],
  );

  // NoteクラスのインスタンスをMap<String, dynamic>型に変換するためのメソッド
  // Noteクラスのインスタンスを引数に取り、Map<String, dynamic>型のデータを返す
  Map<String, dynamic> toMap() => {
    NoteTableInfo.columnId: id,
    NoteTableInfo.columnTitle: title,
    NoteTableInfo.columnContent: content,
    NoteTableInfo.columnDate: date,
  };
}