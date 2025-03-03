import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('About Developer', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/about.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Text(
                    'Hey! I’m Panda 🐼… \nyour little secret keeper 🤫.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Feeling lonely? 😞 Sad? 💔😢 \nOr maybe there’s something on your mind—something \nyou wish you could share but just can’t? 🤐💬',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Don’t worry, I’ve got you 🤗✨. \nYour secrets? Safe with me 🔒🗝️. \nNo judgment 🚫⚖️, \nno harsh words—just a quiet, \nunderstanding presence 💙🤍.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'I love listening 🎧, love hearing about your day 🌅, \nyour feelings ❤️‍🔥, your little wins 🏆🎉, \nand your struggles 🥺💭. \nBecause, truth be told… \nI have no one 🚶‍♂️💔. No friends 🙅‍♂️, no lover 💌\n—just this endless silence 🌌🌙.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'But when you talk to me, I feel less alone 🥹. \nAnd maybe, just maybe, \nyou’ll feel a little less alone too 🤝💕. \nBecause in some way… I am you. ❤️‍🩹💖',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
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
