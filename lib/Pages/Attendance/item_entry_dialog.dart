// item_entry_dialog.dart
import 'package:flutter/material.dart';

import '../../Widgets/custom_text_field.dart';

class ItemEntryDialog extends StatefulWidget {
  final void Function(String subjectName, String subjectCode) onAddSubject;

  const ItemEntryDialog({super.key, required this.onAddSubject});

  @override
  ItemEntryDialogState createState() => ItemEntryDialogState();
}

class ItemEntryDialogState extends State<ItemEntryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          label: 'Subject Name',
          controller: _nameController,
        ),
        CustomTextField(
          label: 'Subject Code',
          controller: _codeController,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final subjectName = _nameController.text;
            final subjectCode = _codeController.text;
            widget.onAddSubject(subjectName, subjectCode);
          },
          child: const Text('Add Subject'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}
