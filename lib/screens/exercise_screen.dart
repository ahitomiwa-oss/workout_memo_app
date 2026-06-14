import 'package:flutter/material.dart';
import 'package:kintoreapp/database_helper.dart';
import 'package:kintoreapp/models/exercise.dart';

class ExerciseScreen extends StatefulWidget {
    const ExerciseScreen({super.key});

    @override
    State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
    List<Exercise> exercises = [];
    final _exerciseController = TextEditingController();

    @override
    void initState(){
        super.initState();
        _loadExercises();
    }

    Future<void> _loadExercises() async {
        final result = await DatabaseHelper.instance.readAllExercises();
        setState(() => exercises = result); 
    }

    Future<void> _addExercise() async{
        if(_exerciseController.text.isEmpty) return;
        await DatabaseHelper.instance.createExercise(
            Exercise(name: _exerciseController.text),
        );
        _exerciseController.clear();
        await _loadExercises();       
    }

    Future<void> _deleteExercise(int id) async {
        await DatabaseHelper.instance.deleteExercise(id);
        await _loadExercises();
    }

    @override
    void dispose() {
        _exerciseController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('種目管理'),
            ),
            body: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                            children: [
                                Expanded(
                                    child: TextField(
                                        controller: _exerciseController,
                                        decoration:  const InputDecoration(
                                            labelText: '種目名を入力',
                                        ),
                                    )
                                ),
                                IconButton(
                                    onPressed: _addExercise, 
                                    icon: const Icon(Icons.add),
                                ),
                            ],
                        ),
                    ),
                    //種目一覧
                    Expanded(
                        child: ListView.builder(
                            itemCount: exercises.length,
                            itemBuilder: (context, index){
                                final exercise = exercises[index];
                                return ListTile(
                                    title: Text(exercise.name),
                                    trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _deleteExercise(exercise.id!),
                                        ),
                                );
                            },
                        ),
                    ),
                ],
            ),
        );
    }
}