// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:reminder_app/Notification_handler/local_notification.dart';
import 'package:reminder_app/dataBase/person.dart';
import 'package:reminder_app/pages/welcomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dataBase/boxes.dart';
import 'pages/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();

  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<B_Person>('personBox');
  var boxTask = await Hive.openBox('taskBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: getUsername(),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: snapshot.data != null
                ? WelcomePage(username: snapshot.data!)
                : HomePage(),
          );
        });
  }
}
