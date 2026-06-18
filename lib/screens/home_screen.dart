import 'package:flutter/material.dart';
import 'package:kintoreapp/screens/exercise_screen.dart';
import 'package:kintoreapp/screens/history_screen.dart';
import 'package:kintoreapp/screens/record_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('筋トレメモ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 記録ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecordScreen(),
                    ),
                  );
                },
                child: const Text('記録する'),
              ),
            ),
            const SizedBox(height: 16),
            // 履歴ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                child: const Text('履歴を見る'),
              ),
            ),
            const SizedBox(height: 16),
            // 種目管理ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExerciseScreen(),
                    ),
                  );
                },
                child: const Text('種目を管理する'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}