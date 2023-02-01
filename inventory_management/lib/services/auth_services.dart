import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory_management/services/db_services.dart';
import 'package:inventory_management/services/storage_services.dart';

import '../models/user_model.dart';

class AuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> createUserWithEmail(UserModel user, Uint8List? file) async {
    String res = 'Some error occurred';
    try {
      if (user.email.isNotEmpty &&
          user.name.isNotEmpty &&
          user.surName.isNotEmpty &&
          user.password.isNotEmpty) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
        user.userId = cred.user!.uid;
        String downloadUrl =
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
        if (file != null) {
          downloadUrl = await StorageServices()
              .uploadImageToStorage('profileImage', file, user.userId);
          user.userPhotoUrl = downloadUrl;
        }

        await DbServices().saveUser(user);
        res = 'success';
      } else {
        res = 'Please fill the fields';
      }
    } on FirebaseAuthException catch (err) {
      res = err.code.toString();
    }
    return res;
  }

  Future<String> loginWithEmail(String email, String password) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fill the fields ';
      }
    } on FirebaseAuthException catch (err) {
      res = err.code.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
