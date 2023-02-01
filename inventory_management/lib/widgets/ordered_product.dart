// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:inventory_management/models/products_order_model.dart';

class OrderedProduct extends StatelessWidget {
  ProductsOrderModel productOrder;
  OrderedProduct({
    Key? key,
    required this.productOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: Image.network(
                    productOrder.productModel.productPhoto,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          'Product name : ${productOrder.productModel.productName}'),
                      Text(
                        'Amount : ${productOrder.amount}',
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
