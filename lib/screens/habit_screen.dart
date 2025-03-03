import 'package:flutter/material.dart';
import 'review_screen.dart'; // Import ReviewScreen to navigate to it
import '../database/habit_database.dart'; // Import your database helper
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  List<Habit> habits = []; // Initialize as empty list
  final dbHelper = HabitDatabaseHelper(); // Instance of database helper

  @override
  void initState() {
    super.initState();
    _loadHabits(); // Load habits when screen initializes
  }

  _loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastResetDateString = prefs.getString('lastResetDate');
    DateTime? lastResetDate;

    if (lastResetDateString != null) {
      lastResetDate = DateTime.parse(lastResetDateString);
    }

    DateTime now = DateTime.now();
    bool isNewDay = false;

    if (lastResetDate == null || lastResetDate.day != now.day || lastResetDate.month != now.month || lastResetDate.year != now.year) {
      isNewDay = true;
    }

    if (isNewDay) {
      // Reset habit completion status in the database
      for (var habit in habits) {
        if (habit.isCompleted) { // Only reset if it was completed
          habit.isCompleted = false;
          habit.completionDate = null; // Clear completion date as well
          await dbHelper.updateHabit(habit); // Update in database to reset
        }
      }
      await prefs.setString('lastResetDate', now.toIso8601String()); // Store today as last reset date
    }

    List<Habit> loadedHabits = await dbHelper.getHabits();
    setState(() {
      habits = loadedHabits; // Update habits from database, reflecting reset if happened
    });
  }

  void _deleteHabit(int index) async {
    bool? confirmedDelete = await showDialog<bool>( // Show confirmation dialog for delete
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to give up on this habit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No - do not delete
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),  // Yes - delete
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmedDelete == true) { // If user confirmed delete in the dialog
      int? habitIdToDelete = habits[index].id; // Get habit ID to delete
      if (habitIdToDelete != null) {
        await dbHelper.deleteHabit(habitIdToDelete); // Delete from database
      }
      _loadHabits(); // Reload habits from database
    }
    // If user cancelled delete (tapped 'No' or outside dialog), do nothing.
  }

  void _toggleHabitCompletion(int index, bool? newValue) async {
    setState(() {
      if (newValue != null && newValue == true) {
        habits[index].isCompleted = true;
        habits[index].completionDate = DateTime.now(); // Record completion date
        dbHelper.updateHabit(habits[index]); // Update in database
      }
      // Unchecking is prevented by the onChanged logic in Checkbox
    });
  }

  Future<void> _addNewHabit(BuildContext context) async {
    await showDialog<String>( // Removed 'final newHabitName ='
      context: context,
      builder: (BuildContext context) {
        TextEditingController habitController = TextEditingController();
        return AlertDialog(
          title: const Text('Add New Habit'),
          content: TextField(
            controller: habitController,
            decoration: const InputDecoration(hintText: "Enter habit name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async { // Make onPressed async
                if (habitController.text.isNotEmpty) {
                  String habitName = habitController.text;
                  Habit newHabit = Habit(name: habitName);
                  await dbHelper.insertHabit(newHabit); // Insert into database
                  _loadHabits(); // Reload habits from database - UI is updated here!
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(habitName); // Return habit name
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind app bar to show background
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: const Color.fromARGB(0, 207, 26, 26), // Make app bar transparent
        elevation: 0, // Remove app bar shadow
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack( // Use Stack to layer background and content
        children: [
          Positioned.fill( // Make image fill the entire screen
            child: Image.asset(
              'assets/images/habit_bg.jpg', // Path to your background image
              fit: BoxFit.cover, // cover the whole area
            ),
          ),
          ListView.builder( // Your existing habit list
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                leading: Checkbox(
                  value: habit.isCompleted,
                  onChanged: (bool? newValue) async { // Make onChanged async
                    if (newValue == true) {
                      bool? confirmed = await showDialog<bool>( // Show confirmation dialog
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Completion'),
                            content: const Text('Did you really complete this habit today?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false), // No - do not confirm
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),  // Yes - confirm
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmed == true) { // If user confirmed in the dialog
                        _toggleHabitCompletion(index, newValue); // Proceed to toggle completion
                      } else {
                        // If user cancelled, we need to revert the checkbox UI,
                        // but since we are in onChanged, it might be tricky to directly revert.
                        // A simple workaround is to reload habits to reflect actual state from DB.
                        _loadHabits(); // Reload habits to ensure checkbox reflects correct state
                      }
                    } else {
                      // Keep the SnackBar logic for "unchecking not allowed" if you still want it
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Habit completion can't be undone today!"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
                title: Text(habit.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteHabit(index);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewHabit(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Habit Class (Keep Habit class definition in habit_screen.dart)
class Habit {
  int? id; // Add id, make it nullable
  String name;
  bool isCompleted;
  DateTime? completionDate; // Track the date of completion

  Habit({
    this.id, // Add id to constructor, make it optional
    required this.name,
    this.isCompleted = false,
    this.completionDate,
  });
}