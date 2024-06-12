import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ItemEntryDialog extends StatefulWidget {
  final Function(String, String) onAddSubject;

  const ItemEntryDialog({required this.onAddSubject, super.key});

  @override
  ItemEntryDialogState createState() => ItemEntryDialogState();
}

class ItemEntryDialogState extends State<ItemEntryDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  Logger logger = Logger();
  String? _errorMessage;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Subject Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _codeController,
          decoration: InputDecoration(
            labelText: 'Subject Code',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(fontSize: 18)),
          ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text;
                final code = _codeController.text;
                if (name.isNotEmpty && code.isNotEmpty) {
                  widget.onAddSubject(name, code);
                  setState(() {
                _errorMessage = null;
                  });
                } else {
                  logger.e('Both fields are required.');
                  setState(() {
                  _errorMessage = 'Both fields are required.';
                  });
                }
              },
              child: const Text('Add',style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        if(_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
