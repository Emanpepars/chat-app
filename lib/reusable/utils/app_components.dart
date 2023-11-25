import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import 'app_colors.dart';
import 'app_styles.dart';

Widget unDefineRoute() {
  return Scaffold(
    appBar: AppBar(
      title: const Text("data"),
    ),
  );
}

Widget defaultFormField({
  required TextEditingController controller,
  String? label,
  String? Function(String?)? validate,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  bool isPassword = false,
}) {
  return TextFormField(
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    controller: controller,
    validator: validate,
    obscureText: isPassword,
    decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        hintText: label,
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(12))),
  );
}

class ChatCard extends StatelessWidget {
  final UserModel userModel;

  const ChatCard(this.userModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userModel.image),
              radius: 20,
            ),
            SizedBox(
              width: 20.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.name,
                  // style: poppins18W500(),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Text(
                      userModel.phone,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double? sizeBoxHeight;

  const MyButton(
      {required this.onPressed,
      required this.text,
      this.sizeBoxHeight,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeBoxHeight ?? 64.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF040A1F),
        ),
        child: Text(text, style: poppins20W600(AppColors.onPrimary)),
      ),
    );
  }
}
