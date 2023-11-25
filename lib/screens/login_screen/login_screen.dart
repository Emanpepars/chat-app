import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../provider/init_user_provider.dart';
import '../../provider/login_provider.dart';
import '../../reusable/routes.dart';
import '../../reusable/utils/app_colors.dart';
import '../../reusable/utils/app_components.dart';
import '../../reusable/utils/app_strings.dart';
import '../../reusable/utils/app_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var initUserProvider = Provider.of<InitUserProvider>(context);
    var loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.onPrimary,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: loginProvider.loginFormKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 91.h,
                  ),
                  //logo
                  SizedBox(
                    height: 86.h,
                  ),
                  Text(
                    AppStrings.welcome,
                    style: poppinsPrimary(size: 24.sp, weight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    AppStrings.loginHint,
                    style: poppinsPrimary(size: 16.sp, weight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  defaultFormField(
                    controller: loginProvider.emailController,
                    label: "Email",
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validate: (value) {
                      return loginProvider.emailValidator(value);
                    },
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  defaultFormField(
                      controller: loginProvider.passwordController,
                      textInputAction: TextInputAction.done,
                      label: "Password",
                      validate: (value) {
                        return loginProvider.validatePassword(value);
                      },
                      isPassword: true),
                  SizedBox(
                    height: 8.h,
                  ),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        "Forget Password ?",
                        textAlign: TextAlign.end,
                        style: poppins18(FontWeight.w400),
                      )),
                  SizedBox(
                    height: 56.h,
                  ),
                  MyButton(
                    onPressed: () {
                      loginProvider.loginFireBase(context, initUserProvider);
                    },
                    text: "Login",
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Don't Have an account?",
                        style: poppinsW500Primary(17.5.sp),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.register);
                        },
                        child: Text(
                          "Create Account",
                          style: poppinsW500Primary(
                            18.sp,
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
