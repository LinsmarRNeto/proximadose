import 'package:flutter/material.dart';
import 'package:proximadose/pages/add_page.dart';
import 'package:proximadose/pages/home_page.dart';

class CustomDrawer extends StatelessWidget implements PreferredSizeWidget {
  const CustomDrawer({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu Principal'),
          ),
          ListTile(
            title: const Text('Home Page'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(
                            username: '',
                            isUserLoggedIn: true,
                          )));
            },
          ),
          ListTile(
            title: const Text('Adcionar Medicamentos'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMedicineForm()),
              );
            },
          ),
        ],
      ),
    );
  }
}
