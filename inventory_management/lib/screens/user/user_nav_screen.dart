import 'package:flutter/material.dart';
import 'package:inventory_management/screens/login_screen.dart';
import 'package:inventory_management/services/auth_services.dart';

class UserNavScreen extends StatelessWidget {
  const UserNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              var cont = Navigator.of(context);
              await AuthServices().signOut();
              cont.push(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: const Center(
        child: Text('user nav screen'),
      ),
    );
  }
}
