import 'package:flutter/material.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/pages/LandingPage/animation.dart';
import 'package:mobile/pages/bottonNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');

  User? user;
  if (userId != null) {
    try {
      user = users.firstWhere((u) => u.id_user == userId);
      User.currentUser = user;
    } catch (e) {
      user = null;
    }
  }

  runApp(MyApp(initialUser: user));
}

class MyApp extends StatelessWidget {
  final User? initialUser;
  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialUser != null
        ? BottonNavigation(currentUser: initialUser,)
        : AnimationFirst()
    );
  }
}
