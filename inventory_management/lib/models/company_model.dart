import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CompanyModel {
  String companyName;
  String companyId;
  String companyImageUrl;
  CompanyModel({
    required this.companyName,
    required this.companyId,
    required this.companyImageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'companyName': companyName,
      'companyId': companyId,
      'companyImageUrl': companyImageUrl,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      companyName: map['companyName'] as String,
      companyId: map['companyId'] as String,
      companyImageUrl: map['companyImageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyModel.fromJson(String source) =>
      CompanyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
