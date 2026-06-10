import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kintoreapp/models/workoutRecord.dart';

class DatabaseHelper {
  //staticでインスタンスを作らずに使える→ずっと同じDBを使う
  //_でクラスの外から使えない→DBを複数個作れないように
  //instanceを使うとアクセスできる
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  //DBの取得
  Future<Database> get database async {
    if(_database != null) return _database!; //すでにDBがあれば返す
    _database = await _initDB('workout.db'); //ない場合作るのを待つ→await
    return _database!;                       //できたDBを返す
  }

  //DBの初期化
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath); //joinで完全なファイルパスを作る。どこにDBを置くかも決めている

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,//DBが存在しなかった場合,テーブルの作成
    );
  }

}