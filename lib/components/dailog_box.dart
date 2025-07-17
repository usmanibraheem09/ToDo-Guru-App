import 'package:flutter/material.dart';
import 'package:reminder_app/components/dailog_buttons.dart';
import 'package:intl/intl.dart';

class DailogBox extends StatefulWidget {
  final TextEditingController taskController;
  final TextEditingController timeController;
  final TextEditingController dateController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DailogBox({
    super.key,
    required this.taskController,
    required this.timeController,
    required this.dateController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DailogBoxState createState() => _DailogBoxState();
}

class _DailogBoxState extends State<DailogBox> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final formattedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        widget.timeController.text = DateFormat('HH:mm').format(formattedTime);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.dateController.text = DateFormat('dd/MM/yy').format(picked);
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 350,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Create a Task',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: widget.taskController,
                decoration: const InputDecoration(hintText: "Add A Task"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Task field cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget.timeController,
                decoration: const InputDecoration(hintText: "Select Time"),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget.dateController,
                decoration: const InputDecoration(hintText: "Select Date"),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(text: "Save", onPressed: _onSave),
                  const SizedBox(width: 4),
                  MyButton(text: "Cancel", onPressed: widget.onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
