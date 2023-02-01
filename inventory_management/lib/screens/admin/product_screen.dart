// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:inventory_management/models/user_model.dart';
import 'package:inventory_management/screens/admin/product_add_screen.dart';
import 'package:inventory_management/services/db_services.dart';

import '../../models/product_model.dart';

class ProductScreen extends StatefulWidget {
  final UserModel currentUser;
  const ProductScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductAddScreen(
                    currentUser: widget.currentUser,
                  ),
                ));
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: DbServices().getProducts(widget.currentUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            List<ProductModel> allProducts = snapshot.data!;
            return ListView.builder(
              itemCount: allProducts.length,
              itemBuilder: (context, index) {
                ProductModel productModel = allProducts[index];
                return Card(
                  elevation: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 150,
                          child: Image.network(
                            productModel.productPhoto,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(productModel.productName),
                                Text(productModel.productCreatedAt.toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}
