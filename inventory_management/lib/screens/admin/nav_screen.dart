// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:inventory_management/models/user_model.dart';
import 'package:inventory_management/screens/admin/order_add_screen.dart';
import 'package:inventory_management/screens/admin/order_screen.dart';
import 'package:inventory_management/screens/admin/product_screen.dart';
import 'package:inventory_management/screens/admin/profile_screen.dart';
import 'package:inventory_management/screens/login_screen.dart';
import 'package:inventory_management/services/auth_services.dart';

class NavScreen extends StatefulWidget {
  UserModel currentUser;
  NavScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  List bottomBarItems = [
    {
      'icon': const Icon(Icons.home_outlined),
      'activeIcon': const Icon(Icons.home),
      'label': 'Orders',
    },
    {
      'icon': const Icon(Icons.poll_rounded),
      'activeIcon': const Icon(Icons.poll_rounded),
      'label': 'Products',
    },
    {
      'icon': const Icon(Icons.add_circle_outline_outlined),
      'activeIcon': const Icon(Icons.add_circle),
      'label': 'Add order',
    },
    {
      'icon': const Icon(Icons.account_circle_outlined),
      'activeIcon': const Icon(Icons.account_circle),
      'label': 'Profile',
    },
  ];

  int selectedBottomBar = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> allScreens = [
      OrderScreen(currentUser: widget.currentUser),
      ProductScreen(currentUser: widget.currentUser),
      OrderAddScreen(currentUser: widget.currentUser),
      const ProfileScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin App'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async {
              var cont = Navigator.of(context);
              await AuthServices().signOut();
              cont.push(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedBottomBar,
          backgroundColor: Colors.blue,
          unselectedItemColor: Colors.black.withOpacity(0.7),
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              selectedBottomBar = value;
            });
          },
          items: List.generate(bottomBarItems.length, (index) {
            return BottomNavigationBarItem(
              icon: bottomBarItems[index]['icon'],
              activeIcon: bottomBarItems[index]['activeIcon'],
              label: bottomBarItems[index]['label'],
            );
          })),
      body: IndexedStack(
        index: selectedBottomBar,
        children: allScreens,
      ),
    );
  }
}
