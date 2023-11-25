import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class ChatBuble extends StatelessWidget {
  final String message;

  const ChatBuble(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 15.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 25.h,
          vertical: 25.w,
        ),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: poppins16W500white(),
        ),
      ),
    );
  }
}

class ChatBubleFriend extends StatelessWidget {
  final String message;

  const ChatBubleFriend(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 15.h,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 25.h,
          vertical: 25.w,
        ),
        decoration: const BoxDecoration(
          color: AppColors.hintColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        child: Text(
          message,
          style: poppins16W500white(),
        ),
      ),
    );
  }
}
