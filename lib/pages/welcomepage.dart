import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reminder_app/Notification_handler/local_notification.dart';
import 'package:reminder_app/components/costum_outline.dart';
import 'package:reminder_app/components/dailog_box.dart';
import 'package:reminder_app/components/todo_list.dart';
import 'package:reminder_app/dataBase/store_task.dart';
import 'package:reminder_app/pages/change_avater.dart';
import 'package:reminder_app/pages/history_page.dart';
import 'package:reminder_app/pages/profile.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:fluttermoji/fluttermoji.dart';

class WelcomePage extends StatefulWidget {
  final String username;
  const WelcomePage({
    super.key,
    required this.username,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _username = ""; // Initialize _username variable
  Timer? _timer;

// reference the hive box
  final taskBox = Hive.box('taskBox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    _username = widget.username; // Set initial username

    // store the data

    if (taskBox.get("TODOLIST") == null) {
      db.creatInitialDate();
    } else {
      db.localData();
    }
    // Start the timer to check tasks every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      // checkTasks();
    });

    // Schedule the task to run at midnight
    scheduleMidnightTask();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void scheduleMidnightTask() {
    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    Duration timeUntilMidnight = midnight.difference(now);

    Timer(timeUntilMidnight, () {
      clearPreviousDayTasks();
      // Reschedule for the next midnight
      scheduleMidnightTask();
    });
  }

  // Method to clear tasks from the previous date
  void clearPreviousDayTasks() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    setState(() {
      db.toDOList.removeWhere((task) {
        DateTime taskDate = DateFormat('yyyy-MM-dd').parse(task[3]);
        return taskDate.isBefore(today);
      });
    });
    db.updateDataBase();
  }

  // Method to update username
  void updateUsername(String newUsername) {
    setState(() {
      _username = newUsername; // Update username
    });
  }

  //  checkbox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDOList[index][1] = !db.toDOList[index][1];
      if (db.toDOList[index][1]) {
        String completionTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        db.saveCompletedTask(db.toDOList[index][0], completionTime);
      }
    });
    db.updateDataBase();
  }

  // text controller
  final taskController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  // save new task

  void saveNewTask() {
    setState(() {
      db.toDOList.add([
        taskController.text,
        false,
        timeController.text,
        dateController.text,
      ]);

      // Schedule the notification
      scheduleTaskNotification(
        taskController.text,
        timeController.text,
        dateController.text,
        db.toDOList.length - 1,
      );
      taskController.clear();
      timeController.clear();
      dateController.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void scheduleTaskNotification(
      String task, String time, String date, int taskId) {
    final timeOfDay = TimeOfDay(
      hour: int.parse(time.split(':')[0]),
      minute: int.parse(time.split(':')[1].split(' ')[0]),
    );

    NotificationHelper notificationHelper = NotificationHelper();
    notificationHelper.scheduledNotification(
        timeOfDay.hour, timeOfDay.minute, task, taskId);
  }

  // Method to check and notify for tasks
  void checkTasks() {
    DateTime now = DateTime.now();
    String currentTime = DateFormat('HH:mm').format(now);
    String currentDate = DateFormat('yyyy-MM-dd').format(now);

    for (var task in db.toDOList) {
      String taskTime = task[2];
      String taskDate = task[3];

      if (taskTime == currentTime && taskDate == currentDate && !task[1]) {
        NotificationHelper().scheduledNotification(
          now.hour,
          now.minute + 1,
          task[0],
          db.toDOList.indexOf(task),
        );
      }
    }
  }
  //creat new task

  void creatNewTask() {
    showDialog(
        context: context,
        builder: (contex) {
          return DailogBox(
            taskController: taskController,
            timeController: timeController,
            dateController: dateController,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(contex).pop(),
          );
        });
  }

  // update a task
  void updateTask(int index) {
    taskController.text = db.toDOList[index][0];
    timeController.text = db.toDOList[index][2];
    dateController.text = db.toDOList[index][3];
    showDialog(
        context: context,
        builder: (context) {
          return DailogBox(
            taskController: taskController,
            timeController: timeController,
            dateController: dateController,
            onSave: () {
              setState(() {
                db.toDOList[index][0] = taskController.text;
                db.toDOList[index][2] = timeController.text;
                db.toDOList[index][3] = dateController.text;
                taskController.clear();
                timeController.clear();
                dateController.clear();
              });
              Navigator.of(context).pop();
            },
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  // delete a task

  void deleteTask(int index) {
    // Remove the task from the list without deleting from history
    setState(() {
      db.toDOList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    // SHow day, and year
    var time = DateTime.now();

    // Calculate completed and pending tasks
    int completedTasks = db.toDOList.where((task) => task[1] == true).length;
    int pendingTasks = db.toDOList.length - completedTasks;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -62,
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(62, 235, 214, 1),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 80,
                    sigmaY: 80,
                  ),
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 590,
              right: -100,
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 0, 143, 1),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 80,
                    sigmaY: 80,
                  ),
                  child: Container(
                    height: 200,
                    width: 200,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 10,
              child: CustomOutline(
                strokeWidth: 1,
                radius: 60,
                padding: const EdgeInsets.all(1),
                width: 400,
                height: 154,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 0, 143, 1),
                    Color.fromRGBO(255, 0, 143, 0),
                    Color.fromRGBO(62, 235, 214, 0),
                    Color.fromRGBO(62, 235, 214, 1)
                  ],
                  stops: [0, 0.3, 0.66, .99],
                  // stops: [0.2, 0.4, 0.6, 1],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60).copyWith(
                      topRight: const Radius.circular(0),
                      bottomRight: const Radius.circular(0),
                    ),
                    color: Colors.black,
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            child: Text(
                              "Tracking Task",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Completed: $completedTasks",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Pending: $pendingTasks",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomOutline(
                        strokeWidth: 3,
                        radius: 100,
                        padding: const EdgeInsets.all(3),
                        width: 100,
                        height: 100,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  db.toDOList.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Tasks',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                _username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                // ignore: unnecessary_string_interpolations
                                '${DateFormat('EEE, M/d/y').format(time)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangeAvater())),
                            child: FluttermojiCircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 240,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: db.toDOList.length,
                        itemBuilder: (context, index) {
                          return ToDOList(
                            taskName: db.toDOList[index][0],
                            taskCompleted: db.toDOList[index][1],
                            time: db.toDOList[index][2],
                            date: db.toDOList[index][3],
                            onChanged: (value) => checkBoxChanged(value, index),
                            deleteFunction: (context) => deleteTask(index),
                            updateFunction: (context) => updateTask(index),
                            index: index,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 450,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        // padding: const EdgeInsets.all(4),
        // margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(54, 226, 195, .2),
              Color.fromRGBO(239, 27, 167, .2),
            ],
          ),
        ),
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(54, 226, 195, 1),
                Color.fromRGBO(239, 27, 167, 1),
              ],
            ),
          ),
          child: RawMaterialButton(
            // creatNewTask,
            onPressed: creatNewTask,
            shape: const CircleBorder(),
            fillColor: const Color(0xff404c57),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: GlassmorphicContainer(
        width: 20,
        height: 70,
        borderRadius: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: 0,
        blur: 30,
        borderGradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(54, 226, 195, 1),
            Color.fromRGBO(239, 27, 167, 1),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          notchMargin: 4,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(username: _username),
                    ),
                  ).then((value) {
                    if (value != null) {
                      updateUsername(
                          value); // Update username when profile is updated
                    }
                  }),
                  icon: const Icon(
                    Icons.manage_accounts_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(db: db),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
