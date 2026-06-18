import 'package:flutter/material.dart';
import 'package:kintoreapp/database_helper.dart';
import 'package:kintoreapp/models/exercise.dart';
import 'package:kintoreapp/models/workout_record.dart';
import 'package:kintoreapp/models/workout_set.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Exercise> exercises = [];
  Exercise? selectedExercise;  // 選択中の種目
  List<Map<String, String>> sets = [];  // 入力中のセット一覧
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final result = await DatabaseHelper.instance.readAllExercises();
    setState(() => exercises = result);
  }

  // セットを追加
  void _addSet() {
    if (_weightController.text.isEmpty || _repsController.text.isEmpty) return;
    setState(() {
      sets.add({
        'weight': _weightController.text,
        'reps': _repsController.text,
      });
    });
    _weightController.clear();
    _repsController.clear();
  }

  // 記録を保存
  Future<void> _saveRecord() async {
    if (selectedExercise == null || sets.isEmpty) return;

    // 記録を保存
    final record = await DatabaseHelper.instance.createRecord(
      WorkoutRecord(
        exerciseId: selectedExercise!.id!,
        date: DateTime.now(),
      ),
    );

    // セットを保存
    for (int i = 0; i < sets.length; i++) {
      await DatabaseHelper.instance.createSet(
        WorkoutSet(
          workoutId: record.id!,
          weight: double.parse(sets[i]['weight']!),
          reps: int.parse(sets[i]['reps']!),
          setNumber: i + 1,
        ),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('記録を追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 種目選択
            DropdownButton<Exercise>(
              hint: const Text('種目を選択'),
              value: selectedExercise,
              items: exercises.map((exercise) {
                return DropdownMenuItem<Exercise>(
                  value: exercise,
                  child: Text(exercise.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedExercise = value);
              },
            ),
            const SizedBox(height: 16),
            // 重量・回数入力
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: '重量(kg)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: const InputDecoration(labelText: '回数'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  onPressed: _addSet,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // セット一覧
            Expanded(
              child: ListView.builder(
                itemCount: sets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'セット${index + 1}: ${sets[index]['weight']}kg × ${sets[index]['reps']}回',
                    ),
                  );
                },
              ),
            ),
            // 保存ボタン
            ElevatedButton(
              onPressed: _saveRecord,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}