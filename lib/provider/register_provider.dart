import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../models/user_model.dart';
import '../reusable/routes.dart';
import 'init_user_provider.dart';

class RegisterProvider extends ChangeNotifier {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  File? img;

  late String imageUrl;

  String? emailValidator(String? value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
    if (value.isEmpty || !emailValid) {
      return "Please Enter valid Email Address";
    }
    return null;
  }

  String? validatePassword(String? value) {
    RegExp passwordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (value == null || value.isEmpty) {
      notifyListeners();
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'at least one uppercase letter, one lowercase letter, one number, and one special character';
    } else {
      return null;
    }
  }

  String? validateName(String? value) {
    RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+([a-zA-Z0-9\s\-.' ',]+)*\$');
    if (value == null || value.isEmpty) {
      return 'Please enter a valid name';
    } else {
      if (!nameRegex.hasMatch(value)) {
        return 'Name must contain only letters, numbers, spaces, hyphens, apostrophes, or periods';
      } else {
        return null;
      }
    }
  }

  String? validatePhoneNumber(String? value) {
    final RegExp phoneRegex = RegExp(
      r'^[+]*[(]?[0-9]{1,4}[)]?[-+\s/0-9]*$',
    );

    if (value == null || value.isEmpty) {
      return 'Please enter a valid phone number';
    } else if (!phoneRegex.hasMatch(value)) {
      notifyListeners();
      return 'Phone number must be in a valid format (e.g., +1-555-555-5555)';
    } else {
      return null;
    }
  }

  void createUserFireBase(InitUserProvider initUserProvider, context) async {
    if (registerFormKey.currentState!.validate()) {
      CollectionReference<UserModel> getUserCollection() {
        return FirebaseFirestore.instance.collection('Users').withConverter(
              fromFirestore: (snapshot, _) =>
                  UserModel.fromJson(snapshot.data()!),
              toFirestore: (user, options) => user.toJson(),
            );
      }

      Future<void> addUser(UserModel user) async {
        var collection = getUserCollection();
        var docRef = collection.doc(user.id);
        await docRef.set(user);
      }

      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        UserModel userModel = UserModel(
          id: credential.user!.uid,
          email: emailController.text,
          name: nameController.text,
          phone: phoneController.text,
          image: imageUrl,
          pushToken: '',
        );
        addUser(userModel).then(
          (value) => Navigator.pushReplacementNamed(context, Routes.login),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      img = File(image.path);
      notifyListeners();
      uploadImageToFirebaseStorage();
    }
  }

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      img = File(pickedFile.path);
      notifyListeners();

      uploadImageToFirebaseStorage();
    }
  }

  Future<void> uploadImageToFirebaseStorage() async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference firebaseStorageRef =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(img!);

      await uploadTask.whenComplete(() async {
        imageUrl = await firebaseStorageRef.getDownloadURL();

        print("Image uploaded to Firebase Storage: $imageUrl");

        notifyListeners();
      });
    } catch (error) {
      print("Error uploading image to Firebase Storage: $error");
    }
  }
}
