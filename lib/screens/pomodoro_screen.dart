import 'package:flutter/material.dart';
import 'dart:async';

enum PomodoroState { work, shortBreak, longBreak, custom }

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  PomodoroScreenState createState() => PomodoroScreenState();
}

class PomodoroScreenState extends State<PomodoroScreen> {
  static const workDuration = Duration(minutes: 25);
  static const shortBreakDuration = Duration(minutes: 5);
  static const longBreakDuration = Duration(minutes: 15);
  static const customDuration = Duration(minutes: 45);

  PomodoroState _currentState = PomodoroState.work;
  Duration _currentTime = workDuration;
  Timer? _timer;
  bool _isRunning = false;
  int _pomodoroCount = 0;

  @override
  void initState() {
    super.initState();
    _currentTime = workDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_currentTime.inSeconds > 0) {
          setState(() {
            _currentTime = _currentTime - const Duration(seconds: 1);
          });
        } else {
          _timer?.cancel();
          _isRunning = false;
          _nextState();
        }
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    setState(() {
      _currentState = PomodoroState.work;
      _currentTime = workDuration;
      _pomodoroCount = 0;
    });
  }

  void _nextState() {
    _pomodoroCount++;
    PomodoroState nextState;
    Duration nextDuration;

    if (_currentState == PomodoroState.work) {
      if (_pomodoroCount % 4 == 0) {
        nextState = PomodoroState.longBreak;
        nextDuration = longBreakDuration;
      } else {
        nextState = PomodoroState.shortBreak;
        nextDuration = shortBreakDuration;
      }
    } else {
      nextState = PomodoroState.work;
      nextDuration = workDuration;
    }

    setState(() {
      _currentState = nextState;
      _currentTime = nextDuration;
      _isRunning = false; // Ensure timer is marked as not running after state change
    });

    // Removed _startTimer(); to prevent automatic restart
    // Removed _vibrate(); // Remove vibration call
    // Removed _showTimerEndDialog(dialogMessage); // Remove dialog call
    // No notification now, timer just stops and state changes
  }

  void _setCustomTime(Duration duration) {
    _timer?.cancel();
    _isRunning = false;
    setState(() {
      _currentState = PomodoroState.custom;
      _currentTime = duration;
    });
  }

  String get _timerText {
    int minutes = _currentTime.inMinutes.remainder(60);
    int seconds = _currentTime.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  String get _stateText {
    switch (_currentState) {
      case PomodoroState.work:
        return "Pomodoro Timer";
      case PomodoroState.shortBreak:
        return "Short Break";
      case PomodoroState.longBreak:
        return "Long Break";
      case PomodoroState.custom:
        return "Pomodoro Timer";
    }
  }

  // Removed _vibrate() function
  // Removed _showTimerEndDialog() function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/main_bg2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _stateText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 20),
                Text(
                  _timerText,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _isRunning ? _pauseTimer : _startTimer,
                      child: Text(_isRunning ? 'Pause' : 'Start'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _resetTimer,
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () => _setCustomTime(workDuration),
                      child: const Text('25 min'),
                    ),
                    ElevatedButton(
                      onPressed: () => _setCustomTime(customDuration),
                      child: const Text('45 min'),
                    ),
                    ElevatedButton(
                      onPressed: () => _setCustomTime(shortBreakDuration),
                      child: const Text('5 min'),
                    ),
                    ElevatedButton(
                      onPressed: () => _setCustomTime(longBreakDuration),
                      child: const Text('15 min'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}