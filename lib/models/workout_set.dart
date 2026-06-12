class WorkoutSet{
  WorkoutSet({
    this.id,
    required this.workoutId,
    required this.weight,
    required this.reps,
    required this.setNumber,
  });

  final int? id;
  final int workoutId;
  final double weight;
  final int reps;
  final int setNumber;

  Map<String, dynamic> toMap() {
    return{
      'id' : id,
      'workoutId': workoutId,
      'weight': weight,
      'reps': reps,
      'setNumber': setNumber,
    };
  }

  factory WorkoutSet.fromMap(Map<String,dynamic> map){
    return WorkoutSet(
      id: map['id'] as int?,
      workoutId: map['workoutId'] as int,
      weight: map['weight'] as double,
      reps: map['reps'] as int,
      setNumber: map['setNumber'] as int,
    );
  }
}