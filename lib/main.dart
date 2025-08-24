import 'package:campix/screens/CampusNavigationScreen.dart';
import 'package:campix/screens/EventsHubScreen.dart';
import 'package:campix/screens/FeedbackComplaintScreen.dart';
import 'package:campix/screens/FoodOrderScreen.dart';
import 'package:campix/screens/GamificationScreen.dart';
import 'package:campix/screens/marketplace_screen.dart';
import 'package:campix/screens/marketplace_screen.dart';
import 'package:campix/widgets/student_profile_card.dart';

import 'package:campix/widgets/student_profile_card.dart';
import 'package:flutter/material.dart';
import 'models/student_model.dart';
import 'screens/Screen1.dart';
import 'screens/Screen2.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campix',
      theme: ThemeData(
        primaryColor: const Color(0xFF5B3CC4),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5B3CC4),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF5B3CC4)),
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/page1': (context) => Page1(),
        '/page2': (context) => Page2(),
        '/page3': (context) => Page3(),
        '/page4': (context) => Page4(),
        '/lost-found': (context) => Screen1(),
        '/queue-tracker': (context) =>
        const QueueStatusScreen(currentLevel: QueueLevel.low),
        '/food-order': (context) => const FoodOrderScreen(), // ✅ New route added here
        '/feedback': (context) => const FeedbackComplaintScreen(),
        '/gamification': (context) => const GamificationScreen(),
        '/events': (context) => const EventsHubScreen(),
        '/campus-navigation': (context) => CampusNavigationScreen(),
        '/marketplace': (context) => const MarketplaceScreen(),
      },

      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name!);
        if (uri.pathSegments.length == 1 &&
            uri.pathSegments[0].startsWith('screen')) {
          final screenNumber =
          uri.pathSegments[0].replaceFirst('screen', '');
          return MaterialPageRoute(
            builder: (context) => ScreenPage(title: 'Screen $screenNumber'),
          );
        }
        return null; // Unknown route
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/Search icon.png',
    'assets/Traffic light.png',
    'assets/map icon.webp',
    'assets/Feedback.png',
    'assets/Star.jpg',
    'assets/Events.png',
  ];

  final List<String> buttonNames = [
    'Lost & Found',
    'Cafeteria Queue Tracker',
    'Campus Navigation',
    'Feedback and Complaints',
    'Gamification/Points',
    'Events Hub',
  ];

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/page1');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/page2');
            },
          ),
          IconButton(
            icon: const Icon(Icons.storefront, color: Colors.white), // 🛒 Marketplace icon
            onPressed: () {
              Navigator.pushNamed(context, '/marketplace'); // Directly to MarketplaceScreen
            },
          ),

          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/page4');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Hub'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: List.generate(6, (index) {
            final buttonNumber = index + 1;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                if (index == 0) {
                  Navigator.pushNamed(context, '/lost-found');
                } else if (index == 1) {
                  Navigator.pushNamed(context, '/queue-tracker');
                } else if (index == 2) {
                  Navigator.pushNamed(context, '/campus-navigation'); // ✅ This!
                } else if (index == 3) {
                  Navigator.pushNamed(context, '/feedback');
                } else if (index == 4) {
                  Navigator.pushNamed(context, '/gamification');
                } else if (index == 5) {
                  Navigator.pushNamed(context, '/events');
                }
              },




              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePaths[index],
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    buttonNames[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: buildBottomAppBar(context),
    );
  }
}

class ScreenPage extends StatelessWidget {
  final String title;

  const ScreenPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Welcome to $title')),
    );
  }
}

// Page 1
class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: const Center(child: Text('Welcome to Page 1')),
    );
  }
}

// Page 2
class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: const Center(child: Text('Welcome to Page 2')),
    );
  }
}

// Page 3
class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to marketplace')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarketplaceScreen()),
            );
          },
          child: const Text('Open Campus Marketplace'),
        ),
      ),
    );
  }
}

// Page 4
class Page4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create a sample student instance
    final student = StudentModel(
      name: 'Alice',
      studentId: '123456',
      email: 'alice@example.com',
      points: 100,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: SingleChildScrollView(
        child: StudentProfileCard(student: student),
      ),
    );
  }
}

