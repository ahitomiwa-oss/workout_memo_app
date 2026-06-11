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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        exercise TEXT NOT NULL,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        sets INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    //AUTOINCREMENTでデータを保存するたびに1,2,3と増える
  }

  //記録の保存
  Future<WorkoutRecord> create(WorkoutRecord record) async {
    final db = await instance.database;
    final id = await db.insert('workout_records', record.toMap());
    return WorkoutRecord(
      id: id,
      exercise: record.exercise,
      weight: record.weight, 
      reps: record.reps, 
      sets: record.sets, 
      date: record.date,
      );
  }

  //全記録の取得
  Future<List<WorkoutRecord>> readAllRecords() async {
    final db = await instance.database;
    final result = await db.query('workout_records', orderBy: 'date DESC'); // date（日付）の順番でデータを並べる DESC = 降順（新しい順）
    return result.map((map) => WorkoutRecord.fromMap(map)).toList();
  }

  //データベースを閉じる
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
