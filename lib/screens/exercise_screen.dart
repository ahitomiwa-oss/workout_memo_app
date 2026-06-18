import 'package:flutter/material.dart';
import 'package:kintoreapp/models/exercise.dart';
import 'package:kintoreapp/database_helper.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {

  List<Exercise> exercises = [];

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('種目管理'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                ),
              ),             
              ElevatedButton(
                onPressed: _addExercise, 
                child: Text('追加'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];

                return ListTile(
                  title:  Text(exercise.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (){
                      _deleteExercise(exercise.id!);
                    },
                  ),
                );
              }
            ),
          ),
        ],
      ),

    );
  }

 @override
  void initState() {
    super.initState();
    _loadExercises();
  } 

  Future _loadExercises() async {
    exercises =  await DatabaseHelper.instance.readAllExercises();
    setState(() => {});
  }

  Future _addExercise() async {
    if(_nameController.text.isEmpty) return;
    await DatabaseHelper.instance.createExercise(Exercise(name: _nameController.text));
    _nameController.clear();
    _loadExercises();
  }

  Future _deleteExercise(int id) async {
    await DatabaseHelper.instance.deleteExercise(id);
    _loadExercises();
  }

  @override
  void dispose(){
    _nameController.dispose();
	  super.dispose();
  }
}


