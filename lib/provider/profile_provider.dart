import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../models/user_model.dart';
import 'login_provider.dart';

class ProfileProvider extends ChangeNotifier {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  File? _updateImage;
  String? imageUrl;

  static Future<void> updateUserProfile(String userId, String name,
      String email, String phone, String image) async {
    var userCollection = LoginProvider.getUserCollection();
    var userDoc = userCollection.doc(userId);
    await userDoc.update({
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
    });
  }

  void updateUserProfileInfo(UserModel user) {
    updateUserProfile(
      user.id,
      nameController.text,
      emailController.text,
      phoneController.text,
      user.image,
    );
    notifyListeners();
  }

  void updateUserImage(UserModel user) {
    updateUserProfile(
      user.id,
      nameController.text,
      emailController.text,
      phoneController.text,
      imageUrl ?? user.image,
    );
    notifyListeners();
  }

  void pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      _updateImage = File(image.path);
      notifyListeners();

      uploadImageToFirebaseStorage();
    }
  }

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _updateImage = File(pickedFile.path);
      notifyListeners();

      uploadImageToFirebaseStorage();
    }
  }

  Future<void> uploadImageToFirebaseStorage() async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.putFile(_updateImage!);

      await uploadTask.whenComplete(() async {
        imageUrl = await firebaseStorageRef.getDownloadURL();

        print("Image uploaded to Firebase Storage: $imageUrl");
        notifyListeners();
      });
    } catch (error) {
      print("Error uploading image to Firebase Storage: $error");
      // Handle error as needed
    }
  }
}
