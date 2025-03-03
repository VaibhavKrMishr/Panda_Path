import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateGrid extends StatefulWidget {
  final List<DateTime> highlightedDates;
  final String title;

  const DateGrid({super.key, required this.highlightedDates, required this.title});

  @override
  State<DateGrid> createState() => _DateGridState();
}

class _DateGridState extends State<DateGrid> {
  late DateTime _currentMonth; // State variable to track the current month

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now(); // Initialize with the current month
  }

  void _goToPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    int daysInMonth = lastDayOfMonth.day;

    List<DateTime> datesInGrid = [];
    for (int i = 0; i < daysInMonth; i++) {
      datesInGrid.add(DateTime(firstDayOfMonth.year, firstDayOfMonth.month, i + 1));
    }

    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final gridWidth = screenWidth * (2/3);         // Calculate 2/3 of screen width

    return SizedBox( // Wrap the Column with SizedBox to control width
      width: gridWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _goToPreviousMonth,
                ),
                Text(
                  DateFormat('MMMM y').format(_currentMonth),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _goToNextMonth,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: datesInGrid.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              // You might need to adjust these cell sizes and spacing further
              // to make the grid look good within the 2/3 width
              // Consider making them responsive to gridWidth if needed
              // example: crossAxisSpacing: gridWidth * 0.01,
            ),
            itemBuilder: (context, index) {
              final date = datesInGrid[index];
              bool isHighlighted = widget.highlightedDates.any((highlightDate) =>
                  highlightDate.year == date.year &&
                  highlightDate.month == date.month &&
                  highlightDate.day == date.day);

              return Container(
                width: gridWidth / 7 - 6 , // Adjust cell width based on gridWidth and spacing. 7 columns, 6 spacing in between
                height: gridWidth / 7 - 6, // Make cells square - adjust height accordingly or use aspect ratio.
                decoration: BoxDecoration(
                  color: isHighlighted ? Colors.green.shade400 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Tooltip(
                  message: DateFormat('MMM dd, y').format(date),
                  child: const SizedBox.expand(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}