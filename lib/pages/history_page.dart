import 'package:flutter/material.dart';
import 'package:reminder_app/dataBase/store_task.dart';

class HistoryPage extends StatelessWidget {
  final ToDoDataBase db;

  const HistoryPage({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    List<dynamic> tasksFromPreviousWeek = db.getTasksFromPreviousWeek();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
      ),
      body: ListView.builder(
        itemCount: tasksFromPreviousWeek.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasksFromPreviousWeek[index][0]),
            subtitle: Text(tasksFromPreviousWeek[index][1]),
          );
        },
      ),
    );
  }
}
