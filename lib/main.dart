import 'package:flutter/material.dart';
import 'package:proximadose/pages/add_page.dart';
import 'package:proximadose/pages/home_page.dart';
import 'package:proximadose/pages/login_page.dart';
import 'package:proximadose/pages/register_page.dart';
import 'package:proximadose/pages/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Próxima Dose',
      initialRoute: '/',
      // Remova o NavigatorObserver se não for mais necessário
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) =>
            const HomePage(username: '', isUserLoggedIn: true),
        '/register': (context) => const RegisterPage(),
        '/add': (context) => const AddMedicineForm(),
        '/welcome': (context) => const WelcomePage(),
      },
    );
  }
}
