import 'package:flutter/material.dart';
import 'package:spark/data/subject_details.dart';

class CreateSubjectWidget extends StatefulWidget {
  final Subject? subject;
  final ValueChanged<String> onSubmit;

  const CreateSubjectWidget({
    super.key,
    this.subject,
    required this.onSubmit,
  });

  @override
  State<CreateSubjectWidget> createState() => _CreateSubjectWidgetState();
}

class _CreateSubjectWidgetState extends State<CreateSubjectWidget> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.subject?.subName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.subject == null ? 'Create Subject' : 'Edit Subject'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Subject Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a subject name';
            }
            return null;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              widget.onSubmit(controller.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
