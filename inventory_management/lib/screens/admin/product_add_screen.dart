// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:inventory_management/models/product_model.dart';
import 'package:inventory_management/models/user_model.dart';
import 'package:inventory_management/services/db_services.dart';
import 'package:inventory_management/widgets/custom_button.dart';
import 'package:inventory_management/widgets/text_field_input.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../login_screen.dart';

class ProductAddScreen extends StatefulWidget {
  UserModel currentUser;
  ProductAddScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<ProductAddScreen> createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  TextEditingController _productNameController = TextEditingController();
  String url = 'https://lizetta.com.tr/wp-content/uploads/2020/08/slayt-22.jpg';
  Uint8List? _img;
  bool isLoading = false;
  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      if (image != null) {
        setState(() {
          _img = image;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin App'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () async {
              var cont = Navigator.of(context);
              await AuthServices().signOut();
              cont.push(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                selectImage();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: _img == null
                    ? Image.network(
                        url,
                        fit: BoxFit.fill,
                      )
                    : Image(
                        image: MemoryImage(_img!),
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldInput(
                  controller: _productNameController,
                  hintText: 'Product name',
                  inputType: TextInputType.text),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  ProductModel productModel = ProductModel(
                    productName: _productNameController.text,
                    productId: const Uuid().v4(),
                    productPhoto:
                        'https://lizetta.com.tr/wp-content/uploads/2020/08/slayt-22.jpg',
                    productCreatedAt: DateTime.now(),
                  );

                  await DbServices()
                      .addProduct(productModel, _img, widget.currentUser);

                  setState(() {
                    isLoading = false;
                  });
                },
                child: isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Add product',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
