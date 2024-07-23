import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark/Models/notes_model.dart';
import 'package:spark/color_schemes.dart';
import 'package:spark/fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../Providers/notes_provider.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  NoteState createState() => NoteState();
}

class NoteState extends State<Note> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotesProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                _showAddNoteDialog(context);
              },
              icon: const Icon(Icons.add, color: Colors.blue, size: 28))
        ],
        title: const Text(
          'N O T E S',
          style: appBarTitleStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: const NotesGrid(),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          title: const Text('Add Note'),
          content: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style:
                        const TextStyle(fontSize: 24, color: dialogTextColor),
                    controller: titleController,
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Title'),
                  ),
                  const Divider(),
                  TextField(
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Start Typing...'),
                    maxLines: 8,
                    maxLength: 400,
                    controller: contentController,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: dialogButtonColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Add', style: TextStyle(color: dialogButtonColor)),
              onPressed: () {
                final title = titleController.text.trim();
                final content = contentController.text;
                if (title.isNotEmpty) {
                  Provider.of<NotesProvider>(context, listen: false)
                      .createEmptyNote(title, content);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate(notesProvider.notes.length, (index) {
          final note = notesProvider.notes[index];
          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () => _showNoteDialog(context, note),
              child: Card(
                color: Colors.grey.shade600,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        note.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content.length > 100
                            ? '${note.content.substring(0, 100)}...'
                            : note.content,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          _formatTimestamp(note.timestamp),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day) {
      return DateFormat.jm().format(timestamp); // Show time if it's today
    } else {
      return DateFormat.yMMMd().format(timestamp); // Show date otherwise
    }
  }

  void _showNoteDialog(BuildContext context, Notes note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          title: TextField(
            controller: titleController,
            style: const TextStyle(color: dialogTextColor, fontSize: 24),
            decoration: const InputDecoration.collapsed(hintText: 'Title'),
          ),
          content: SingleChildScrollView(
            child: TextFormField(
              decoration:
                  const InputDecoration.collapsed(hintText: 'Start Typing ...'),
              controller: contentController,
              style: const TextStyle(color: dialogTextColor),
              maxLines: 10,
              maxLength: 400,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Provider.of<NotesProvider>(context, listen: false)
                          .deleteNote(note.id!);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: dialogButtonColor,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancel',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: dialogButtonColor)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Save',
                          style: TextStyle(color: dialogButtonColor)),
                      onPressed: () {
                        final updatedTitle = titleController.text.trim();
                        final updatedContent = contentController.text.trim();
                        if (updatedTitle.isNotEmpty) {
                          Notes updatedNote = Notes(
                              id: note.id,
                              title: updatedTitle,
                              content: updatedContent,
                              timestamp: DateTime.now());
                          Provider.of<NotesProvider>(context, listen: false)
                              .updateNote(updatedNote);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
