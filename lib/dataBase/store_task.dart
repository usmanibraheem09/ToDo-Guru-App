import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class ToDoDataBase {
  List<dynamic> toDOList = [];
  List<dynamic> completedTasks = [];

  // Reference to the Hive box
  final taskBox = Hive.box('taskBox');

  // Create initial data
  void creatInitialDate() {
    toDOList = [];
    completedTasks = [];
    taskBox.put('TODOLIST', toDOList);
    taskBox.put('COMPLETEDTASKS', completedTasks);
  }

  // Load data from local storage
  void localData() {
    var savedData = taskBox.get('TODOLIST');
    var savedCompletedTasks = taskBox.get('COMPLETEDTASKS');
    if (savedData != null) {
      toDOList = List<dynamic>.from(savedData);
    } else {
      creatInitialDate();
    }
    if (savedCompletedTasks != null) {
      completedTasks = List<dynamic>.from(savedCompletedTasks);
    }
  }

  // Update data in local storage
  void updateDataBase() {
    taskBox.put('TODOLIST', toDOList);
    taskBox.put('COMPLETEDTASKS', completedTasks);
  }

  // Save completed task with completion time
  void saveCompletedTask(String task, String completionTime) {
    completedTasks.add([task, completionTime]);
    updateDataBase();
  }

  // Update task status
  static Future<void> updateTaskStatus(String taskId) async {
    final taskBox = Hive.box('taskBox');
    List<dynamic> toDOList = List<dynamic>.from(taskBox.get('TODOLIST') ?? []);
    int index = int.parse(taskId);
    if (index < toDOList.length) {
      toDOList[index][1] = true; // Mark the task as completed
      taskBox.put('TODOLIST', toDOList);
    }
  }

  // Get tasks from the previous week
  List<dynamic> getTasksFromPreviousWeek() {
    DateTime now = DateTime.now();
    DateTime oneWeekAgo = now.subtract(const Duration(days: 7));

    return completedTasks.where((task) {
      DateTime taskDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(task[1]);
      return taskDate.isAfter(oneWeekAgo) && taskDate.isBefore(now);
    }).toList();
  }
}
