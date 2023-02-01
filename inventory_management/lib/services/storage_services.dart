import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageServices {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      String pathName, Uint8List file, String id) async {
    var ref = firebaseStorage.ref().child(pathName).child(id);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
