import 'package:flutter/material.dart';
import 'package:wine_app/screens/search_screen.dart';
import 'package:wine_app/screens/settings_screen.dart';
import 'package:wine_app/screens/specials_screen.dart';

///      H O M E   S C R E E N
///      This is the home screen from which all navigation redirects.
///      App screens including:
///      - History
///      - Reports
///      - New Entry
///      - Lifestyle
///      - Settings
///      can all be viewed by tapping the bottom navbar.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Initial screen index (New Entry Screen)
  int currentIndex = 2;

  // List of available screens to switch to
  final screens = [
    const SearchScreen(),
    const SpecialsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: null,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/Logo.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          'Specials',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: MediaQuery.of(context).size.height / 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      // Add container to give it rounded edges
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0), // adjust to your liking
            topRight: Radius.circular(30.0), // adjust to your liking
          ),
          color: Theme.of(context).colorScheme.primary, // put the color here
        ),
        child: BottomNavigationBar(
          //Tab bar at the bottom of the screen
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          iconSize: 55,
          selectedFontSize: 5,
          unselectedFontSize: 5,
          currentIndex: currentIndex,
          selectedItemColor: Colors.grey[200],
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: '',
            ),
          ],
          //Update screen index
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
      body: screens[currentIndex],
    );
  }
}
