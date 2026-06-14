class Exercise {
  Exercise({
    this.id,
    required this.name,
  });

  final int? id;
  final String name;

  Map<String,dynamic> toMap() {
    return{
      'id': id,
      'name': name,
    };
  }
  
  factory Exercise.fromMap(Map<String, dynamic> map){
    return Exercise(
      id: map['id'] as int?,
      name: map['name'] as String,
    );
  }
}