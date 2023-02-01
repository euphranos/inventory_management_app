// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:inventory_management/models/company_model.dart';
import 'package:inventory_management/models/products_order_model.dart';

import '../models/product_model.dart';
import 'custom_button.dart';

class OrderSelectWidget extends StatefulWidget {
  List<ProductModel>? allProducts;

  ProductModel? selected;
  final Function(ProductsOrderModel) callBack;
  Function(dynamic)? onChanged;

  OrderSelectWidget({
    Key? key,
    required this.allProducts,
    required this.selected,
    required this.callBack,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OrderSelectWidget> createState() => _OrderSelectWidgetState();
}

class _OrderSelectWidgetState extends State<OrderSelectWidget> {
  bool isAdded = false;
  TextEditingController _amountController = TextEditingController();

  List<ProductsOrderModel> orderedProducts = [];
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.allProducts == null) {
      if (widget.allProducts == null) {
        return const Center(
          child: Text('all products null'),
        );
      } else {
        return const Center(
          child: Text('user null'),
        );
      }
    } else {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton<ProductModel>(
                    hint: const Text('Lütfen ürün seçiniz'),
                    value: widget.selected,
                    items: List.generate(
                      widget.allProducts!.length,
                      (index) {
                        ProductModel product = widget.allProducts![index];
                        return DropdownMenuItem<ProductModel>(
                          value: widget.allProducts![index],
                          child: Row(
                            children: [
                              Image.network(
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                  product.productPhoto),
                              Text(widget.allProducts![index].productName),
                            ],
                          ),
                        );
                      },
                    ),
                    onChanged: widget.onChanged,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // burayi düzenle

              const SizedBox(height: 10),
              CustomButton(
                  onTap: () {
                    ProductsOrderModel productsOrderModel = ProductsOrderModel(
                      productModel: widget.selected!,
                      amount: int.parse(_amountController.text.trim()),
                    );

                    orderedProducts.add(productsOrderModel);
                    widget.callBack(productsOrderModel);

                    _amountController.clear();
                  },
                  child: const Text(
                    'Add the order list',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }
  }
}
