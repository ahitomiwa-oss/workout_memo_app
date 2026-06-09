class WorkoutRecord {
  WorkoutRecord({
    this.id,
    required this.exercise,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.date,
  });

  final int? id;
  final String exercise;
  final double weight;
  final int reps;
  final int sets;
  final DateTime date;


Map<String, dynamic> toMap(){
  return{
    'id' : id,
    'exercise' : exercise,
    'weight': weight,
    'reps': reps,
    'sets': sets,
    'date': date.toIso8601String(),
  };
}
  factory WorkoutRecord.fromMap(Map<String, dynamic> map) {
    return WorkoutRecord(
      id: map['id'] as int?,
      exercise: map['exercise'] as String,
      weight: map['weight'] as double,
      reps: map['reps'] as int,
      sets: map['sets'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }
}