// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:inventory_management/models/order_model.dart';

class OrderWidget extends StatefulWidget {
  OrderModel order;
  OrderWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    Image.network(
                      widget.order.orderedProducts[0].productModel.productPhoto,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.order.orderTitle,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.order.orderDescribe),
                    Row(
                      children: List.generate(
                        widget.order.orderedProducts.length,
                        (index) => Text(
                            '${widget.order.orderedProducts[index].productModel.productName} ${widget.order.orderedProducts[index].amount} Adet || '),
                      ),
                    ),
                    Text(widget.order.orderDescribe),
                    Text(
                        'Sipariş Kabul Edildi mi : ${widget.order.isOrderAccepted}')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
