// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:inventory_management/models/company_model.dart';
import 'package:inventory_management/models/products_order_model.dart';
import 'package:inventory_management/models/user_model.dart';

class OrderModel {
  List<ProductsOrderModel> orderedProducts;
  String orderId;
  String orderTitle;
  String orderDescribe;
  UserModel orderOwner;
  DateTime orderCreatedAt;
  bool isOrderAccepted;
  bool isOrderCompleted;
  CompanyModel senderCompany;
  CompanyModel receiverCompany;
  OrderModel({
    required this.orderedProducts,
    required this.orderId,
    required this.orderTitle,
    required this.orderDescribe,
    required this.orderOwner,
    required this.orderCreatedAt,
    required this.isOrderAccepted,
    required this.isOrderCompleted,
    required this.senderCompany,
    required this.receiverCompany,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderedProducts': orderedProducts.map((x) => x.toMap()).toList(),
      'orderId': orderId,
      'orderTitle': orderTitle,
      'orderDescribe': orderDescribe,
      'orderOwner': orderOwner.toMap(),
      'orderCreatedAt': orderCreatedAt.millisecondsSinceEpoch,
      'isOrderAccepted': isOrderAccepted,
      'isOrderCompleted': isOrderCompleted,
      'senderCompany': senderCompany.toMap(),
      'receiverCompany': receiverCompany.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderedProducts: List<ProductsOrderModel>.from(
        (map['orderedProducts'] as List<dynamic>).map<ProductsOrderModel>(
          (x) => ProductsOrderModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      orderId: map['orderId'] as String,
      orderTitle: map['orderTitle'] as String,
      orderDescribe: map['orderDescribe'] as String,
      orderOwner: UserModel.fromMap(map['orderOwner'] as Map<String, dynamic>),
      orderCreatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['orderCreatedAt'] as int),
      isOrderAccepted: map['isOrderAccepted'] as bool,
      isOrderCompleted: map['isOrderCompleted'] as bool,
      senderCompany:
          CompanyModel.fromMap(map['senderCompany'] as Map<String, dynamic>),
      receiverCompany:
          CompanyModel.fromMap(map['receiverCompany'] as Map<String, dynamic>),
    );
  }
}
