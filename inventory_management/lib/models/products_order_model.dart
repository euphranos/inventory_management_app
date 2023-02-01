// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:inventory_management/models/product_model.dart';

class ProductsOrderModel {
  ProductModel productModel;
  int amount;
  ProductsOrderModel({
    required this.productModel,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productModel': productModel.toMap(),
      'amount': amount,
    };
  }

  factory ProductsOrderModel.fromMap(Map<String, dynamic> map) {
    return ProductsOrderModel(
      productModel:
          ProductModel.fromMap(map['productModel'] as Map<String, dynamic>),
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsOrderModel.fromJson(String source) =>
      ProductsOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
