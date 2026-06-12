import 'package:kintoreapp/models/workoutSet.dart';

class WorkoutRecord {
  WorkoutRecord({
    this.id,
    //requiredは必ず値を渡す
    required this.exerciseId,
    required this.date,
    this.sets = const [],
  });
  //?がついているとnullでもOK ?がついていないとクラッシュする
  final int? id;
  final int exerciseId;
  final DateTime date;
  final List<WorkoutSet> sets;

//dynamic型はどんな型でもOK
Map<String, dynamic> toMap(){
  return{
    'id' : id,
    'exerciseId' : exerciseId,
    'date': date.toIso8601String(), //date型をStringに変換するメソッド
  };
}

//mapからWorkoutRecordを作るために必要
//toMapとfromMapはセット
  factory WorkoutRecord.fromMap(Map<String, dynamic> map, List<WorkoutSet> set) {
    return WorkoutRecord(
      id: map['id'] as int?,
      exerciseId: map['exerciseId'] as int,
      date: DateTime.parse(map['date'] as String),
      sets: sets,
    );
  }
}