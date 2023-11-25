import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/init_user_provider.dart';
import '../../provider/register_provider.dart';
import '../../reusable/routes.dart';
import '../../reusable/utils/App_styles.dart';
import '../../reusable/utils/app_colors.dart';
import '../../reusable/utils/app_components.dart';
import '../../reusable/utils/app_images.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var initUserProvider = Provider.of<InitUserProvider>(context);
    var registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: registerProvider.registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: poppins20W600(AppColors.primary),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: registerProvider.img == null
                                ? Image.asset(AppImages.fakeLocalImage).image
                                : FileImage(registerProvider.img!),
                            radius: 70.sp,
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
                                        horizontal: 10.w, vertical: 10.h),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MyButton(
                                            onPressed: () {
                                              registerProvider.pickImage();
                                              Navigator.pop(context);
                                            },
                                            text: "Take Photo",
                                            sizeBoxHeight: 50.h,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          MyButton(
                                            onPressed: () {
                                              registerProvider.getImage();
                                              Navigator.pop(context);
                                            },
                                            text: "Choose Photo",
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
                    SizedBox(
                      height: 30.h,
                    ),
                    defaultFormField(
                      controller: registerProvider.nameController,
                      label: "Full name",
                      validate: (value) {
                        return registerProvider.validateName(value);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    defaultFormField(
                      controller: registerProvider.phoneController,
                      label: "Phone Number",
                      keyboardType: TextInputType.phone,
                      validate: (value) {
                        return registerProvider.validatePhoneNumber(value);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    defaultFormField(
                      controller: registerProvider.emailController,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validate: (value) {
                        return registerProvider.emailValidator(value);
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    defaultFormField(
                      controller: registerProvider.passwordController,
                      label: "Password",
                      validate: (value) {
                        return registerProvider.validatePassword(value);
                      },
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                    ),
                    SizedBox(
                      height: 56.h,
                    ),
                    MyButton(
                      onPressed: () {
                        registerProvider.createUserFireBase(
                            initUserProvider, context);
                      },
                      text: "Sign Up",
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "I Have an account?",
                          style: poppins18(
                            FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.login);
                          },
                          child: Text(
                            "Login",
                            style: poppins18(
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
