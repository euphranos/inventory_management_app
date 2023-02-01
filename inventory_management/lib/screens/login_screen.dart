import 'package:flutter/material.dart';
import 'package:inventory_management/screens/admin/nav_screen.dart';
import 'package:inventory_management/screens/sign_in_screen.dart';
import 'package:inventory_management/screens/user_router_screen.dart';
import 'package:inventory_management/widgets/custom_button.dart';
import 'package:inventory_management/widgets/text_field_input.dart';

import '../services/auth_services.dart';
import '../utils/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isAdmin = false;
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                Image.asset(
                  'assets/login.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                ),
                TextFieldInput(
                    controller: _emailController,
                    hintText: 'email',
                    inputType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                TextFieldInput(
                  controller: _passwordController,
                  hintText: 'password',
                  inputType: TextInputType.text,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  child: isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                  onTap: () async {
                    var cont = Navigator.of(context);
                    setState(() {
                      isLoading = true;
                    });
                    String res = await AuthServices().loginWithEmail(
                        _emailController.text, _passwordController.text);
                    if (res == 'success') {
                      cont.push(MaterialPageRoute(
                        builder: (context) => UserRouterScreen(),
                      ));
                    } else {
                      showSnackBar(res, context);
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ));
                    },
                    child: const Text(
                      'You dont have account ? Sign up',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
