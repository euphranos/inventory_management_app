// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/models/company_model.dart';
import 'package:uuid/uuid.dart';

import 'package:inventory_management/models/order_model.dart';
import 'package:inventory_management/models/products_order_model.dart';
import 'package:inventory_management/services/db_services.dart';
import 'package:inventory_management/widgets/order_select_widget.dart';
import 'package:inventory_management/widgets/ordered_product.dart';

import '../../models/product_model.dart';
import '../../models/user_model.dart';

class OrderAddScreen extends StatefulWidget {
  UserModel currentUser;
  OrderAddScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<OrderAddScreen> createState() => _OrderAddScreenState();
}

class _OrderAddScreenState extends State<OrderAddScreen> {
  ProductModel? selected;

  CompanyModel? selectedCompanyModel;
  UserModel? user;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  List<ProductModel>? allProducts;
  CompanyModel? myCompany;
  List<CompanyModel>? allRelatiedCompanies;
  List<ProductsOrderModel> allOrderedProducts = [];

  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products =
        await DbServices().futureGetProducts(widget.currentUser);
    setState(() {
      allProducts = products;
    });
    return allProducts!;
  }

  Future<CompanyModel?> getUserCompanyModel() async {
    var company = await DbServices().getCompanyModel(widget.currentUser);
    setState(() {
      myCompany = company;
    });
    return myCompany;
  }

  Future<List<CompanyModel>> getRelatedCompanies() async {
    List<CompanyModel> relatedCompanies =
        await DbServices().getRelatedCompanies(widget.currentUser);

    setState(() {
      allRelatiedCompanies = relatedCompanies;
    });
    return allRelatiedCompanies!;
  }

  @override
  void initState() {
    super.initState();
    getAllProducts();
    getRelatedCompanies();
    getUserCompanyModel();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: FutureBuilder<UserModel>(
        future: DbServices().getCurrentUser(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            UserModel userModel = snapshot.data!;
            return Column(
              children: [
                OrderSelectWidget(
                  callBack: (p0) {
                    setState(() {
                      allOrderedProducts.add(p0);
                      print(allOrderedProducts[0].toString());
                    });
                  },
                  allProducts: allProducts,
                  selected: selected,
                  onChanged: (p0) {
                    setState(() {
                      selected = p0;
                    });
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: allOrderedProducts.length,
                  itemBuilder: (context, index) {
                    ProductsOrderModel productOrder = allOrderedProducts[index];
                    return OrderedProduct(productOrder: productOrder);
                  },
                ),
                allOrderedProducts.isNotEmpty && myCompany != null
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Sipariş Başlığı',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    maxLines: 3,
                                    controller: _descController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Sipariş için notlarinizi yaziniz',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownButton<CompanyModel>(
                            hint: const Text(
                                'Lütfen sipariş verilecek şirketi seçiniz'),
                            value: selectedCompanyModel,
                            items: List.generate(
                              allRelatiedCompanies!.length,
                              (index) {
                                CompanyModel senderCompany =
                                    allRelatiedCompanies![index];

                                return DropdownMenuItem<CompanyModel>(
                                  value: allRelatiedCompanies![index],
                                  child: Row(
                                    children: [
                                      Image.network(
                                          senderCompany.companyImageUrl,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill),
                                      Text(senderCompany.companyName),
                                    ],
                                  ),
                                );
                              },
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedCompanyModel = value;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              OrderModel orderModel = OrderModel(
                                  senderCompany: selectedCompanyModel!,
                                  receiverCompany: myCompany!,
                                  orderedProducts: allOrderedProducts,
                                  orderId: const Uuid().v4(),
                                  orderTitle: _titleController.text,
                                  orderDescribe: _descController.text,
                                  orderOwner: userModel,
                                  orderCreatedAt: DateTime.now(),
                                  isOrderAccepted: false,
                                  isOrderCompleted: false);
                              await DbServices()
                                  .addOrder(orderModel, userModel);
                              allOrderedProducts.clear();
                              _titleController.clear();
                              _descController.clear();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                width: double.infinity,
                                alignment: Alignment.center,
                                color: Colors.green,
                                child: _isLoading == true
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Siparişi ver',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          return const Center(
            child: Text('Some error occurred!'),
          );
        },
      ),
    ));
  }
}
