// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:reminder_app/components/costum_outline.dart';

class ToDOList extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String time;
  final String date;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? updateFunction;
  final int index;
  ToDOList({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.updateFunction,
    required this.index,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomOutline(
        strokeWidth: 1,
        radius: 60,
        padding: const EdgeInsets.all(1),
        width: 100,
        height: 70,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(255, 0, 143, 1),
            Color.fromRGBO(62, 235, 214, 1)
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.all(19.0),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: taskCompleted,
                      onChanged: onChanged,
                      activeColor: Colors.black,
                    ),
                    Row(
                      children: [
                        Text(
                          taskName,
                          style: TextStyle(
                            decoration: taskCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => updateFunction?.call(context),
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteFunction?.call(context),
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
