import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kintoreapp/database_helper.dart';
import 'package:kintoreapp/models/exercise.dart';
import 'package:kintoreapp/models/workout_record.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<WorkoutRecord> records = [];
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final recordResult = await DatabaseHelper.instance.readAllRecords();
    final exerciseResult = await DatabaseHelper.instance.readAllExercises();
    setState(() {
      records = recordResult;
      exercises = exerciseResult;
    });
  }

  // exerciseIdから種目名を取得
  String _getExerciseName(int exerciseId) {
    final exercise = exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => Exercise(name: '不明'),
    );
    return exercise.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('履歴'),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('yyyy/MM/dd').format(record.date),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    _getExerciseName(record.exerciseId),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...record.sets.map((set) => Text(
                    'セット${set.setNumber}: ${set.weight}kg × ${set.reps}回',
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}