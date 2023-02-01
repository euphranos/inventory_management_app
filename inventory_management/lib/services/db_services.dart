import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory_management/models/company_model.dart';
import 'package:inventory_management/models/order_model.dart';
import 'package:inventory_management/models/product_model.dart';
import 'package:inventory_management/models/user_model.dart';
import 'package:inventory_management/services/storage_services.dart';
import 'package:inventory_management/utils/constants.dart';

class DbServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> addProduct(
      ProductModel productModel, Uint8List? file, UserModel currentUser) async {
    var ref = await firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('products')
        .add(productModel.toMap());

    String downloadUrl =
        'https://lizetta.com.tr/wp-content/uploads/2020/08/slayt-22.jpg';
    if (file != null) {
      downloadUrl = await StorageServices()
          .uploadImageToStorage('productImages', file, ref.id);
    }
    productModel.productId = ref.id;
    productModel.productPhoto = downloadUrl;
    await firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('products')
        .doc(productModel.productId)
        .set(productModel.toMap());
  }

  Future<void> deleteProduct(
      ProductModel product, UserModel currentUser) async {
    await firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('products')
        .doc(product.productId)
        .delete();
  }

  Stream<List<ProductModel>> getProducts(UserModel user) {
    return firebaseFirestore
        .collection('companies')
        .doc(user.companyOfUser.companyId)
        .collection('products')
        .snapshots()
        .map((event) {
      List<ProductModel> allProducts = [];
      for (var doc in event.docs) {
        ProductModel productModel = ProductModel.fromMap(doc.data());
        allProducts.add(productModel);
      }
      return allProducts;
    });
  }

  Future<void> saveUser(UserModel user) async {
    await firebaseFirestore
        .collection('users')
        .doc(user.userId)
        .set(user.toMap());
  }

  Future<UserModel> getCurrentUser() async {
    User? currentUser = firebaseAuth.currentUser;
    var ref =
        await firebaseFirestore.collection('users').doc(currentUser!.uid).get();
    UserModel? user = UserModel.fromMap(ref.data()!);

    return user;
  }

  Future<List<ProductModel>> futureGetProducts(UserModel currentUser) async {
    var ref = await firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('products')
        .get();
    List<ProductModel> allProducts = [];
    for (var doc in ref.docs) {
      ProductModel productModel = ProductModel.fromMap(doc.data());
      allProducts.add(productModel);
    }
    return allProducts;
  }

  Future<void> addOrder(OrderModel order, UserModel currentUser) async {
    await firebaseFirestore
        .collection('companies')
        .doc(order.senderCompany.companyId)
        .collection('orders')
        .doc(order.orderId)
        .set(order.toMap());
    await firebaseFirestore
        .collection('companies')
        .doc(order.receiverCompany.companyId)
        .collection('orders')
        .doc(order.orderId)
        .set(order.toMap());
  }

  Stream<List<OrderModel>> getOrders(UserModel currentUser) {
    return firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('orders')
        .snapshots()
        .map((event) {
      List<OrderModel> allOrders = [];
      for (var doc in event.docs) {
        OrderModel orderModel = OrderModel.fromMap(doc.data());
        allOrders.add(orderModel);
      }
      return allOrders;
    });
  }

  Stream<List<UserModel>> getUsers() {
    return firebaseFirestore.collection('users').snapshots().map((event) {
      List<UserModel> allUsers = [];
      for (var doc in event.docs) {
        UserModel user = UserModel.fromMap(doc.data());
        allUsers.add(user);
      }
      return allUsers;
    });
  }

  Future<void> createCompany(
      UserModel user, CompanyModel company, Uint8List? file) async {
    String url = defaultCompanyPhoto;
    if (file != null) {
      url = await StorageServices()
          .uploadImageToStorage('companyPhoto', file, company.companyId);
      company.companyImageUrl = url;
    }

    //delete user from the company workers
    await firebaseFirestore
        .collection('companies')
        .doc(user.companyOfUser.companyId)
        .collection('users')
        .doc(user.userId)
        .delete();

    //create the company
    await firebaseFirestore
        .collection('companies')
        .doc(company.companyId)
        .collection('company')
        .doc(company.companyId)
        .set(company.toMap());
    //workers adding into  company users section
    await firebaseFirestore
        .collection('companies')
        .doc(company.companyId)
        .collection('users')
        .doc(user.userId)
        .set(user.toMap());

    //editing the user's company for change old company to new company
    await firebaseFirestore
        .collection('users')
        .doc(user.userId)
        .update({'companyOfUser': company.toMap()});
  }

  Stream<UserModel> getUserStream() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((event) {
      UserModel user = UserModel.fromMap(event.data()!);
      return user;
    });
  }

  Future<void> quitTheCompany(UserModel user) async {
    await firebaseFirestore
        .collection('companies')
        .doc(user.companyOfUser.companyId)
        .collection('users')
        .doc(user.userId)
        .delete();
    CompanyModel defaultCompany = CompanyModel(
      companyImageUrl: defaultCompanyPhoto,
      companyName: 'defaultCompanyName',
      companyId: 'defaultCompanyId',
    );

    await firebaseFirestore
        .collection('users')
        .doc(user.userId)
        .update({'companyOfUser': defaultCompany.toMap()});
  }

  Future<String> signInCompanyWithCode(UserModel user, String? code) async {
    String res = 'Some error occurred';
    try {
      if (code != null) {
        var mRef = await firebaseFirestore
            .collection('companies')
            .doc(code)
            .collection('company')
            .doc(code)
            .get();
        CompanyModel companyModel = CompanyModel.fromMap(mRef.data()!);

        await firebaseFirestore
            .collection('users')
            .doc(user.userId)
            .update({'companyOfUser': companyModel.toMap()});
        await firebaseFirestore
            .collection('companies')
            .doc(code)
            .collection('users')
            .doc(user.userId)
            .set(user.toMap());
        res = 'success';
      } else {
        res = 'Please fill the field';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addRelatedCompany(String? code, UserModel user) async {
    String res = 'Some error occurred';
    try {
      if (code == null) {
        res = 'Please fill the field';
      } else {
        //get targeted company object
        var targetRef = await firebaseFirestore
            .collection('companies')
            .doc(code)
            .collection('company')
            .doc(code)
            .get();
        CompanyModel targetCompanyModel =
            CompanyModel.fromMap(targetRef.data()!);
        await firebaseFirestore
            .collection('companies')
            .doc(user.companyOfUser.companyId)
            .collection('relatedCompanies')
            .doc(code)
            .set(targetCompanyModel.toMap());
        //get our company object
        var ourRef = await firebaseFirestore
            .collection('companies')
            .doc(user.companyOfUser.companyId)
            .collection('company')
            .doc(user.companyOfUser.companyId)
            .get();
        CompanyModel ourCompanyModel = CompanyModel.fromMap(ourRef.data()!);
        await firebaseFirestore
            .collection('companies')
            .doc(code)
            .collection('relatedCompanies')
            .doc(ourCompanyModel.companyId)
            .set(ourCompanyModel.toMap());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<CompanyModel>> getRelatedCompanies(UserModel currentUser) async {
    var ref = await firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('relatedCompanies')
        .get();
    List<CompanyModel> allRelatedCompanies = [];

    for (var ref in ref.docs) {
      CompanyModel company = CompanyModel.fromMap(ref.data());
      allRelatedCompanies.add(company);
    }
    return allRelatedCompanies;
  }

  Stream<List<CompanyModel>> getRelatedCompaniesStream(UserModel currentUser) {
    return firebaseFirestore
        .collection('companies')
        .doc(currentUser.companyOfUser.companyId)
        .collection('relatedCompanies')
        .snapshots()
        .map((event) {
      List<CompanyModel> allRelatedCompanies = [];
      for (var doc in event.docs) {
        CompanyModel company = CompanyModel.fromMap(doc.data());
        allRelatedCompanies.add(company);
      }
      return allRelatedCompanies;
    });
  }

  Future<CompanyModel?> getCompanyModel(UserModel user) async {
    try {
      var ref = await firebaseFirestore
          .collection('companies')
          .doc(user.companyOfUser.companyId)
          .collection('company')
          .doc(user.companyOfUser.companyId)
          .get();

      CompanyModel companyModel = CompanyModel.fromMap(ref.data()!);
      return companyModel;
    } catch (err) {
      return null;
    }
  }
}
