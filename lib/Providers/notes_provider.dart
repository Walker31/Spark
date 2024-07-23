import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spark/Database/notes_service.dart';
import 'package:spark/Models/notes_model.dart';

class NotesProvider with ChangeNotifier {
  final Logger logger = Logger();
  List<Notes> _notes = [];

  List<Notes> get notes => _notes;

  final NotesDatabase _notesDatabase = NotesDatabase.instance;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> fetchNotes() async {
    try {
      _notes = await _notesDatabase.getAllNotes();
      notifyListeners();
    } catch (e) {
      logger.e('Error fetching Notes: $e');
    }
  }

  Future<void> addNote(Notes note) async {
    try {
      await _notesDatabase.insertNote(note);
      await fetchNotes(); // Refresh the notes list
    } catch (e) {
      logger.e('Error adding Note: $e');
    }
  }

  Future<void> updateNote(Notes note) async {
    try {
      await _notesDatabase.updateNote(note);
      await fetchNotes(); // Refresh the notes list
    } catch (e) {
      logger.e('Error updating Note: $e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _notesDatabase.deleteNote(id);
      await fetchNotes(); // Refresh the notes list
    } catch (e) {
      logger.e('Error deleting Note: $e');
    }
  }

  void createEmptyNote(String title,String content) {
    final newNote = Notes(
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );
    addNote(newNote);
  }
}
