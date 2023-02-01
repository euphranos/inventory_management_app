// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  String productName;
  String productId;
  String productPhoto;
  DateTime productCreatedAt;
  ProductModel({
    required this.productName,
    required this.productId,
    required this.productPhoto,
    required this.productCreatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productId': productId,
      'productPhoto': productPhoto,
      'productCreatedAt': productCreatedAt.millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productName: map['productName'] as String,
      productId: map['productId'] as String,
      productPhoto: map['productPhoto'] as String,
      productCreatedAt:
          DateTime.fromMillisecondsSinceEpoch(map['productCreatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
