// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:inventory_management/models/user_model.dart';
import 'package:inventory_management/services/db_services.dart';
import 'package:inventory_management/widgets/order_widget.dart';

import '../../models/order_model.dart';

class OrderScreen extends StatefulWidget {
  final UserModel currentUser;
  const OrderScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<OrderModel>>(
      stream: DbServices().getOrders(widget.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('error:${snapshot.error}'),
          );
        }
        List<OrderModel> allOrders = snapshot.data!;

        return ListView.builder(
          itemCount: allOrders.length,
          itemBuilder: (context, index) {
            OrderModel order = allOrders[index];
            return OrderWidget(order: order);
          },
        );
      },
    ));
  }
}
