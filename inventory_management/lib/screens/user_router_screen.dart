import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/screens/admin/nav_screen.dart';
import 'package:inventory_management/screens/user/user_nav_screen.dart';
import 'package:inventory_management/services/db_services.dart';
import 'package:inventory_management/utils/snackbar.dart';

import '../models/user_model.dart';

class UserRouterScreen extends StatefulWidget {
  const UserRouterScreen({super.key});

  @override
  State<UserRouterScreen> createState() => _UserRouterScreenState();
}

class _UserRouterScreenState extends State<UserRouterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: DbServices().getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            UserModel user = snapshot.data!;
            if (user.isAdmin) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavScreen(currentUser: user),
                    ));
              });
            }
            if (user.isAdmin == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserNavScreen(),
                    ));
              });
            }
          }
          if (snapshot.hasError) {
            showSnackBar('error: ' + snapshot.error.toString(), context);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
