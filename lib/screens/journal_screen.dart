import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/journal_database.dart';
import 'dart:async';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> journalEntries = [];
  final dbHelper = JournalDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  Future<void> _loadJournalEntries() async {
    List<JournalEntry> entries = await dbHelper.getJournalEntries();
    setState(() => journalEntries = entries);
  }

  void _editJournalEntry(int index) async {
    JournalEntry? entry = index >= 0 ? journalEntries[index] : null;
    int? entryIdToUpdate = entry?.id;

    TextEditingController subjectController = TextEditingController(text: entry?.subject ?? "");
    TextEditingController textController = TextEditingController(text: entry?.text ?? "");

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenJournalEntry(
          subjectController: subjectController,
          textController: textController,
          isNewEntry: index == -1,
          entryIdToUpdate: entryIdToUpdate,
          onSave: (editedSubject, editedText, entryId) async {
            if (entryId != null) {
              JournalEntry updatedEntry = JournalEntry(
                id: entryId,
                subject: editedSubject,
                text: editedText,
                dateTime: DateTime.now(),
              );
              await dbHelper.updateJournalEntry(updatedEntry);
            } else {
              JournalEntry newEntry = JournalEntry(
                subject: editedSubject,
                text: editedText,
                dateTime: DateTime.now(),
              );
              await dbHelper.insertJournalEntry(newEntry);
            }
            _loadJournalEntries();
          },
        ),
      ),
    );
  }

  void _deleteJournalEntry(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this journal entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                int? entryIdToDelete = journalEntries[index].id;
                if (entryIdToDelete != null) {
                  await dbHelper.deleteJournalEntry(entryIdToDelete);
                }
                _loadJournalEntries();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        // Deletion logic moved inside the dialog's "Yes" button
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal 📝'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/journal_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: ListView.builder(
              itemCount: journalEntries.length,
              itemBuilder: (context, index) {
                final entry = journalEntries[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(entry.subject.isNotEmpty ? entry.subject : 'No Subject'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('MMM dd, yyyy - hh:mm a').format(entry.dateTime)),
                        Text(entry.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => _editJournalEntry(index)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteJournalEntry(index)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editJournalEntry(-1),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FullScreenJournalEntry extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController textController;
  final bool isNewEntry;
  final int? entryIdToUpdate;
  final Function(String, String, int?) onSave;

  const FullScreenJournalEntry({
    super.key,
    required this.subjectController,
    required this.textController,
    required this.isNewEntry,
    required this.entryIdToUpdate,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewEntry ? 'New Entry' : 'Edit Entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              onSave(subjectController.text, textController.text, entryIdToUpdate);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/main_bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(labelText: 'Subject'),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(labelText: 'Entry Text', border: InputBorder.none),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JournalEntry {
  int? id;
  String subject;
  String text;
  DateTime dateTime;

  JournalEntry({this.id, required this.subject, required this.text, required this.dateTime});
}