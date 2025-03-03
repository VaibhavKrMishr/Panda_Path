import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'screens/journal_screen.dart';
import 'screens/habit_screen.dart';
import 'package:intl/intl.dart';
import 'screens/pomodoro_screen.dart';
import 'screens/review_screen.dart'; 
import 'screens/about_screen.dart'; 

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Panda App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String quote = "";
  final List<String> quotes = [
    "Eat. Sleep. Roll around. Repeat. Life sorted.",
    "Sometimes, doing nothing is the best thing to do.",
    "Be like a panda—black, white, and chill all over.",
    "Happiness is bamboo in one hand and a nap on the schedule.",
    "Stress less, nap more.🐼",
    "Even pandas gotta climb trees to get what they want. Keep climbing.",
    "Slow progress is still progress. Look at me, I barely move, and I'm still iconic.",
    "Work smarter, not harder. If food comes to you, why chase it?",
    "Don’t rush. Even a panda gets where it wants, eventually.",
    "Bamboo doesn’t grow in a day. Neither do dreams.",
    "Find someone who loves you like pandas love bamboo.",
    "Good friends share food. Great friends let you have the last bite.",
    "True love is napping together without disturbing each other.",
    "Some people are like pandas—rare, precious, and a little lazy.",
    "If they don’t appreciate your fluff, they don’t deserve your presence.",
    "Be calm like a panda, but when life gets tough, be ready to climb.",
    "Balance is key—50% food, 50% naps, 100% happiness.",
    "Life isn’t black and white, but pandas are, and they still thrive.",
    "Stay soft, but know when to bite.",
    "Not everything is worth your energy—sometimes, just roll away from the drama.",
    "Panda mode: Activated. Motivation: Deactivated.",
    "Your only limit is your mind.",
    "A year from now, you’ll wish you had started today.",
    "Don’t wait for opportunity, create it.",
    "Doubt kills more dreams than failure ever will.",
    "Discipline is choosing between what you want now and what you want most.",
    "Be stubborn about your goals, but flexible about your methods.",
    "Small steps every day lead to big changes.",
    "You don’t have to be great to start, but you have to start to be great.",
    "Success is 1% inspiration and 99% perspiration.",
    "Every master was once a beginner.",
    "Work hard in silence, let your success make the noise.",
    "Don’t stop when you’re tired, stop when you’re done.",
    "You become what you repeatedly do.",
    "Success is not final, failure is not fatal.",
    "Winners are not people who never fail, but people who never quit.",
    "Some people dream of success, while others wake up and work for it.",
    "The secret to success is to start before you are ready.",
    "Hustle beats talent when talent doesn’t hustle.",
    "Push yourself, because no one else is going to do it for you.",
    "What comes easy won’t last. What lasts won’t come easy.",
    "Confidence is silent. Insecurities are loud.",
    "Your value doesn’t decrease based on someone’s inability to see your worth.",
    "Be yourself; an original is worth more than a copy.",
    "Don’t shrink yourself to fit into places you’ve outgrown.",
    "You were born to stand out, not fit in.",
    "Love yourself first, and everything else falls into place.",
    "Stop comparing your Chapter 1 to someone else’s Chapter 20.",
    "No one can make you feel inferior without your consent.",
    "Don’t let the opinions of others define who you are.",
    "The strongest people are not those who show strength in front of us but those who win battles we know nothing about.",
    "Happiness is an inside job.",
    "Peace begins when expectations end.",
    "Stop chasing happiness and start enjoying the present.",
    "Gratitude turns what we have into enough.",
    "Happiness is not having what you want, but wanting what you have.",
    "The key to happiness is letting each situation be what it is, instead of what you think it should be.",
    "Do more things that make you forget to check your phone.",
    "Happiness is found when you stop comparing yourself to others.",
    "Worrying does not take away tomorrow’s troubles; it takes away today’s peace.",
    "Protect your peace at all costs.",
    "The right person will never make you feel like you have to fight for their attention.",
    "Love yourself enough to walk away from what no longer serves you.",
    "A strong relationship requires choosing to love each other even in the moments when you struggle to like each other.",
    "Some people come into your life as blessings, others as lessons.",
    "Respect is earned, honesty is appreciated, trust is gained, and loyalty is returned.",
    "The people who truly love you will never leave you for long.",
    "Love is not about finding the perfect person, but about seeing an imperfect person perfectly.",
    "People treat you how they feel about you, not how you feel about them.",
    "Actions will always tell you louder than words.",
    "Never beg for someone’s attention, affection, or love. If it isn’t given freely, it isn’t worth having.",
    "Fear is just excitement without breath.",
    "Feel the fear and do it anyway.",
    "Do what you fear and watch it disappear.",
    "Fear has two meanings: Forget Everything And Run or Face Everything And Rise. The choice is yours.",
    "Courage is not the absence of fear but the ability to act despite it.",
    "The only way to overcome fear is to go through it.",
    "Fear kills more dreams than failure ever will.",
    "It’s okay to be scared. Being scared means you’re about to do something really brave.",
    "Bravery is not the lack of fear, but the ability to move forward despite it.",
    "You never know how strong you are until being strong is your only choice.",
    "Every failure is a step closer to success.",
    "Fall seven times, stand up eight.",
    "The comeback is always stronger than the setback.",
    "Turn your wounds into wisdom.",
    "Success is not about never failing but about rising every time you do.",
    "Failure is not the opposite of success; it’s part of success.",
    "Sometimes you win, sometimes you learn.",
    "The only real failure is the failure to try.",
    "Mistakes are proof that you are trying.",
    "Don’t fear failure. Fear being in the same place next year as you are today.",
    "Live as if you were to die tomorrow. Learn as if you were to live forever.",
    "Your life is your message to the world. Make it inspiring.",
    "Don’t just exist. Live.",
    "The meaning of life is to find your gift. The purpose of life is to give it away.",
    "The best time to plant a tree was 20 years ago. The second-best time is now.",
    "Live a life that makes you excited to wake up in the morning.",
    "Your purpose in life is not just to survive, but to thrive.",
    "What you do today can improve all your tomorrows.",
    "You are not a drop in the ocean. You are the entire ocean in a drop.",
    "Life is short. Focus on what truly matters.",
    "The trouble is, you think you have time.",
    "Don’t waste time on things that don’t matter.",
    "Time is non-refundable. Use it with intention.",
    "Every second you spend wishing for the past is a second stolen from your future.",
    "If it won’t matter in five years, don’t spend more than five minutes worrying about it.",
    "Your future depends on what you do today.",
    "If it’s important, you’ll find a way. If not, you’ll find an excuse.",
    "Life is a collection of moments. Make them count.",
    "Spend more time on things that bring you joy.",
    "You either make time for your goals, or your excuses will make time for you.",
    "Simplicity is the ultimate sophistication.",
    "Do what is right, not what is easy.",
    "Knowledge speaks, but wisdom listens.",
    "The quieter you become, the more you can hear.",
    "A wise person learns more from a fool than a fool learns from a wise person.",
    "Be selective with your battles; sometimes peace is better than being right.",
    "Less ego, more soul.",
    "Your energy introduces you before you even speak.",
    "The best way to predict the future is to create it.",
    "What you think, you become. What you feel, you attract. What you imagine, you create.",
  ];

  @override
  void initState() {
    super.initState();
    updateQuote();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      updateQuote();
    });
  }

  void updateQuote() {
    final randomIndex = Random().nextInt(quotes.length);
    setState(() {
      quote = quotes[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('🐼 App', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        leading: Builder( // Use Builder to get context of Scaffold
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black), // Hamburger icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer on icon press
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      drawer: Drawer( // Left sidebar/navigation drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                ' ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Journal'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JournalScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_box),
              title: const Text('Habit Tracker'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HabitScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('Review'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewScreen()), // Navigate to ReviewScreen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Pomodoro'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PomodoroScreen()), // Navigate to PomodoroScreen
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()), // 
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/main_bg.jpg', // Ensure correct path to your image
              fit: BoxFit.cover,
            ),
          ),
          Column( // Changed Center to Column to allow adding widgets below
            children: [
              Expanded( // Added Expanded to push Center content to the center vertically
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          DateFormat('MMM dd,yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 27, 7, 10),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(seconds: 1),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Container(
                          key: ValueKey<String>(quote),
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          constraints: const BoxConstraints(
                            minHeight: 50, // Minimum height to ensure it's not too small
                            maxHeight: 150, // Maximum height - adjust as needed
                            minWidth: double.infinity, // Take up available horizontal space
                            maxWidth: double.infinity, // Take up available horizontal space
                          ),
                          child: Text(
                            quote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // **Horizontal Button Tiles**
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding around the row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space evenly between tiles
                          children: [
                            Expanded( // Use Expanded to make tiles take equal width
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.book, size: 32), // Journal Icon, increased size
                                label: const Text('Journal', style: TextStyle(fontSize: 18)), // Increased text size
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const JournalScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom( // Button styling
                                  padding: const EdgeInsets.symmetric(vertical: 24), // Increased vertical padding
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
                                ),
                              ),
                            ),
                            const SizedBox(width: 20), // Spacing between tiles
                            Expanded( // Use Expanded to make tiles take equal width
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check_box, size: 32), // Habit Tracker Icon, increased size
                                label: const Text('Habit Tracker', style: TextStyle(fontSize: 18)), // Increased text size
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HabitScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom( // Button styling
                                  padding: const EdgeInsets.symmetric(vertical: 24), // Increased vertical padding
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Rounded corners
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align( // Aligns the text to the bottom center
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0), // Add some bottom padding
                  child: Text(
                    "With ❤️ by 🐼.",
                    style: const TextStyle(
                      color: Color.fromARGB(179, 89, 0, 0), // Adjust color for visibility on background
                      fontSize: 12, // Adjust font size as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}