import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/models/company_model.dart';
import 'package:inventory_management/models/user_model.dart';
import 'package:inventory_management/screens/login_screen.dart';
import 'package:inventory_management/services/auth_services.dart';
import 'package:inventory_management/utils/constants.dart';
import 'package:inventory_management/utils/snackbar.dart';
import 'package:inventory_management/utils/utils.dart';
import 'package:inventory_management/widgets/custom_button.dart';
import 'package:inventory_management/widgets/text_field_input.dart';

import 'package:uuid/uuid.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  Uint8List? _img;
  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      if (image != null) {
        _img = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _img == null
                        ? CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            backgroundImage:
                                const AssetImage('assets/anon.png'),
                            radius: 64,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            backgroundImage: MemoryImage(_img!),
                            radius: 64,
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFieldInput(
                    controller: _name,
                    hintText: 'Name',
                    inputType: TextInputType.text),
                const SizedBox(height: 20),
                TextFieldInput(
                    controller: _surname,
                    hintText: 'Surname',
                    inputType: TextInputType.text),
                const SizedBox(height: 20),
                TextFieldInput(
                    controller: _emailController,
                    hintText: 'Email',
                    inputType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                TextFieldInput(
                    controller: _passwordController,
                    hintText: 'Password',
                    inputType: TextInputType.text,
                    isPassword: true),
                const SizedBox(height: 20),
                CustomButton(
                  child: isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Signup',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var cont = Navigator.of(context);

                    UserModel user = UserModel(
                      companyOfUser: CompanyModel(
                          companyImageUrl: defaultCompanyPhoto,
                          companyName: 'defaultCompanyName',
                          companyId: 'defaultCompanyId'),
                      isAdmin: true,
                      userId: const Uuid().v4(),
                      name: _name.text,
                      surName: _surname.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      userPhotoUrl: 'userPhotoUrl',
                      createdAt: DateTime.now(),
                    );
                    String res =
                        await AuthServices().createUserWithEmail(user, _img);
                    setState(() {
                      isLoading = false;
                    });
                    if (res == 'success') {
                    } else {
                      showSnackBar(res, context);
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: const Text(
                      'You have account ? Login',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
