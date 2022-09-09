import 'package:flutter/material.dart';
import 'package:wine_app/screens/home_screen.dart';
import 'package:wine_app/screens/sign_up_screen.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFCB343B), // focus
          onPrimary: Colors.white,

          background: Colors.white,
          onBackground: Colors.white, //text on buttons

          secondary: Color(0xFF4978B6),
          onSecondary: Colors.white,

          error: Colors.grey,
          onError: Colors.white,

          surface: Colors.white, // AppBar
          onSurface: Colors.white, //icons, inputs

          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/login',
      //Named routes (All possible initial screens)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
