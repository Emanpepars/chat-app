import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/user_model.dart';
import '../../reusable/utils/App_styles.dart';
import '../../reusable/utils/app_colors.dart';
class FriendProfileScreen extends StatelessWidget {
  final UserModel args;

  const FriendProfileScreen(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: AppColors.primary,
        ),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.onPrimary, // Background color
        ),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 85,
                backgroundImage: CachedNetworkImageProvider(args.image),
              ),
              const SizedBox(height: 20),
              Text(
                args.name,
                style: poppins20W600(AppColors.primary),
              ),
              SizedBox(height: 25.h),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    args.phone,
                    style: poppins14W400(),
                  ),
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    args.email,
                    style: poppins14W400(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
