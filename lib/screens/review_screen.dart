// review_screen.dart
import 'package:flutter/material.dart';
import '../models/date_grid.dart';
import '../database/habit_database.dart'; // Import HabitDatabaseHelper and Habit class
import 'habit_screen.dart'; // Import Habit class (for type definition - could be moved to models later)

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key}); // Removed 'habits' parameter

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<Habit> habits = []; // List to hold habits loaded from database
  final dbHelper = HabitDatabaseHelper(); // Instance of database helper

  @override
  void initState() {
    super.initState();
    _loadHabits(); // Load habits when screen initializes
  }

  _loadHabits() async {
    List<Habit> loadedHabits = await dbHelper.getHabits();
    setState(() {
      habits = loadedHabits;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ),
        title: Container( // White box for title
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Text(
            'Habit Review',
            style: TextStyle(color: Color.fromARGB(255, 89, 35, 133)),
          ),
        ),
      ),
      body:  _buildHabitReviewPage(),
    );
  }


  Widget _buildHabitReviewPage() {
    // Use the habits list loaded from the database
    // List<Habit> habits = widget.habits; // No longer getting habits from widget

    Map<String, List<DateTime>> habitCompletionDates = {};

    // Populate habitCompletionDates based on completionDate in habits list
    for (var habit in habits) {
      if (habit.isCompleted && habit.completionDate != null) {
        // If habit is completed and has a completionDate, add the date to the list
        habitCompletionDates[habit.name] = [habit.completionDate!]; // Use non-null assertion since we checked
      } else {
        // If not completed or no completionDate, initialize with an empty list
        habitCompletionDates[habit.name] = [];
      }
    }

    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        List<DateTime> completedDatesForHabit = habitCompletionDates[habit.name] ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * (2/3),
            child: DateGrid(
              title: 'Habit: ${habit.name}',
              highlightedDates: completedDatesForHabit, // Pass populated date list
            ),
          ),
        );
      },
    );
  }
}