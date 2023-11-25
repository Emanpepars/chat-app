import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../reusable/routes.dart';
import 'init_user_provider.dart';

class LoginProvider extends ChangeNotifier {
   var emailController = TextEditingController();

   var passwordController = TextEditingController();

   final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  static CollectionReference<UserModel> getUserCollection() {
    return FirebaseFirestore.instance.collection('Users').withConverter(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, options) => user.toJson(),
        );
  }
   static Stream<QuerySnapshot<UserModel>> getUsersFromFireStore() {
     var collection = getUserCollection();
     return collection
         .where("id", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
         .snapshots();
   }

  static Future<UserModel?> readUser(String id) async {
    DocumentSnapshot<UserModel> userQuery =
        await getUserCollection().doc(id).get();
    UserModel? userModel = userQuery.data();
    return userModel;
  }

   void loginFireBase(context, InitUserProvider initUserProvider) async {
    if (loginFormKey.currentState!.validate()) {
      getUserCollection();
      try {
        var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        readUser(credential.user!.uid).then(
          (userModel) {
            initUserProvider.initUser();
            Navigator.pushReplacementNamed(
              context,
              Routes.home,
              arguments: userModel,
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Wrong Username or password")));
        }
      }
    }
  }


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
}
