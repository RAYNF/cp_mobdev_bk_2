import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/service/firebase_options.dart';
import 'package:mobile_inventory/presentation/pages/add_categori_screen.dart';
import 'package:mobile_inventory/presentation/pages/add_product_screen.dart';
import 'package:mobile_inventory/presentation/pages/dashboard_screen.dart';
import 'package:mobile_inventory/presentation/pages/login_screen.dart';
import 'package:mobile_inventory/presentation/pages/register_screen.dart';
import 'package:mobile_inventory/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Apps',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/addproduct': (context) => AddproductScreen(),
        '/addkategori': (context) => AddcategoriScreen()
      },
    );
  }
}
