import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../provider/init_user_provider.dart';
import '../../provider/login_provider.dart';
import '../../provider/profile_provider.dart';
import '../../reusable/utils/app_colors.dart';
import '../../reusable/utils/app_components.dart';
import '../../reusable/utils/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var initUserProvider = Provider.of<InitUserProvider>(context);
    var profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: AppColors.primary,
        ),
        //  automaticallyImplyLeading: false,
        title: Text(
          "Hello ${initUserProvider.userModel?.name}",
          style: poppins20W600(AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel?>(
        future: LoginProvider.readUser(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Error loading user data'));
          }

          UserModel user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              profileProvider.imageUrl ??
                                  initUserProvider.userModel!.image),
                          radius: 60.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        MyButton(
                                          onPressed: () {
                                            profileProvider.pickImage();
                                            profileProvider
                                                .updateUserImage(user);
                                            Navigator.pop(context);
                                          },
                                          text: 'Take Photo',
                                          sizeBoxHeight: 50.h,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        MyButton(
                                          onPressed: () {
                                            profileProvider.getImage();
                                            profileProvider
                                                .updateUserImage(user);
                                            Navigator.pop(context);
                                          },
                                          text: 'Choose Photo',
                                          sizeBoxHeight: 50.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(25.sp),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  const Text('Name'),
                  SizedBox(height: 10.h),
                  defaultFormField(
                    controller: profileProvider.nameController
                      ..text = user.name,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 16.h),
                  const Text('Email'),
                  SizedBox(height: 10.h),
                  defaultFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    controller: profileProvider.emailController
                      ..text = user.email,
                  ),
                  SizedBox(height: 16.h),
                  const Text('Phone'),
                  SizedBox(height: 10.h),
                  defaultFormField(
                    keyboardType: TextInputType.phone,
                    controller: profileProvider.phoneController
                      ..text = user.phone,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 30.h),
                  MyButton(
                      onPressed: () {
                        profileProvider.updateUserProfileInfo(user);
                        //print("success message");
                        initUserProvider.initUser();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Updated Successfully")),
                        );
                      },
                      text: 'Update Profile'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
