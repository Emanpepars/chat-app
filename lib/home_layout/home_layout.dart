import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/reusable/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../provider/init_user_provider.dart';
import '../provider/login_provider.dart';
import '../reusable/routes.dart';
import '../reusable/utils/app_colors.dart';
import '../reusable/utils/app_components.dart';
import '../screens/chat_screen/chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    var initUser = Provider.of<InitUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.profile);
          },
          icon: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(initUser.userModel?.image??AppImages.fakeImage),
            radius: 20,
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'chatty',
          style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.login);
              initUser.signOut();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: AppColors.primary,
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: StreamBuilder(
            stream: LoginProvider.getUsersFromFireStore(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    const Text("Something went wrong"),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Try Again'),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<UserModel> users =
                  snapshot.data!.docs.map((msg) => msg.data()).toList();
              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Oops! You don't",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "have any Friends yet",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  reverse: false,
                  controller: controller,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: ChatCard(users[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(users[index]),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: users.length,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
