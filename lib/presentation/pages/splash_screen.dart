import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    User? user = _auth.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/prediction1.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
