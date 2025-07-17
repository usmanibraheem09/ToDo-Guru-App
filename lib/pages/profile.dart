import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/pages/change_avater.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String username;
  const Profile({
    super.key,
    this.title,
    required this.username,
  });
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final usernameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username; // Set initial value for username
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const SizedBox(
            height: 80,
          ),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Spacer(flex: 2),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 35,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Customize"),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeAvater(),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              controller: usernameController,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: GradientButton(
              ontap: () async {
                String newUsername = usernameController.text;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(
                    'username', newUsername); // Save updated username
                Navigator.pop(
                    context, newUsername); // Pass updated username back
              },
              child: const Text(
                "Done",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
