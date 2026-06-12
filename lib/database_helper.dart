import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kintoreapp/models/exercise.dart';
import 'package:kintoreapp/models/workout_record.dart';
import 'package:kintoreapp/models/workout_set.dart';

class DatabaseHelper {
  //static→インスタンスを作らず使う。ずっと同じDBを使う クラス→設計図、インスタンス→実物
  //_でクラスの外から使えない→DBを複数個作れないように
  //instanceを使うとアクセスできる
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();//staticでインスタンスを作らない代わりにここで一回宣言する

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
      CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exerciseId INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutId INTEGER NOT NULL,
        weight REAL NOT NULL,
        reps INTEGER NOT NULL,
        setNumber INTEGER NOT NULL
      )
    ''');
    //AUTOINCREMENTでデータを保存するたびに1,2,3と増える
  }
  //種目の追加
  Future<Exercise> createExercise(Exercise exercise) async {
    final db = await instance.database;
    final id = await db.insert('exercises', exercise.toMap());
    return Exercise(id: id, name: exercise.name);
  }

  //種目の全取得
  Future<List<Exercise>> readAllExercises() async {
    final db = await instance.database;
    final result = await db.query('exercises');
    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  //種目の削除
  Future deleteExercise(int id) async {
    final db = await instance.database;
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //セットの保存
  Future<WorkoutSet> createSet(WorkoutSet set) async {
    final db = await instance.database;
    final id = await db.insert('workout_sets',set.toMap());
    return WorkoutSet(
      id: id,
      workoutId: set.workoutId, 
      weight: set.weight, 
      reps: set.reps, 
      setNumber: set.setNumber,
      );
  }

  //セットの取得
  Future<List<WorkoutSet>> readSets(int workoutId) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_sets',
      where: 'workoutId = ?',
      whereArgs: [workoutId],
      orderBy: 'setNumber ASC',
    );
    return result.map((map) => WorkoutSet.fromMap(map)).toList();
  }

  //記録の保存
  Future<WorkoutRecord> createRecord(WorkoutRecord record) async {
    final db = await instance.database;
    final id = await db.insert('workout_records', record.toMap());
    return WorkoutRecord(
      id: id,
      exerciseId: record.exerciseId, 
      date: record.date,
      sets: record.sets, 
      );
  }

  //全記録の取得
  Future<List<WorkoutRecord>> readAllRecords() async {
    final db = await instance.database;
    final records = await db.query('workout_records', orderBy: 'date DESC'); // date（日付）の順番でデータを並べる DESC = 降順（新しい順）
    return Future.wait(records.map((map) async{
      final sets = await readSets(map['id'] as int);
      return WorkoutRecord.fromMap(map,sets);
    }).toList());
  }

  //データベースを閉じる
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
