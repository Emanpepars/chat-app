import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../provider/chat_provider.dart';
import '../../reusable/utils/App_styles.dart';
import '../../reusable/utils/app_colors.dart';
import '../../reusable/widget/message.dart';
import '../friend_profile/friend_profile.dart';

class ChatScreen extends StatelessWidget {
  final UserModel args;

  const ChatScreen(this.args, {super.key});

  @override
  Widget build(BuildContext context) {
    var chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primary),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          args.name,
          style: poppins20W600(AppColors.primary),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FriendProfileScreen(args),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(args.image),
              radius: 20,
            ),
          ),


          SizedBox(
            width: 10.w,
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: chatProvider.getMessagesFromFireStore(),
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<MessageModel> messages =
                    snapshot.data!.docs.map((msg) => msg.data()).toList();
                return Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: chatProvider.controller,
                    itemBuilder: (context, index) {
                      return (messages[index].id ==
                                  FirebaseAuth.instance.currentUser!.uid &&
                              messages[index].friendId == args.id)
                          ? ChatBuble(messages[index].message)
                          : (messages[index].id == args.id &&
                                  messages[index].friendId ==
                                      FirebaseAuth.instance.currentUser!.uid)
                              ? ChatBubleFriend(messages[index].message)
                              : const SizedBox();
                    },
                    itemCount: messages.length,
                  ),
                );
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: chatProvider.messageController,
              onSubmitted: (value) {
                chatProvider.addMessageFireBase(value, args);
              },
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: "send Message",
                suffixIcon: IconButton(
                    onPressed: () {
                      chatProvider.addMessageFireBase(
                          chatProvider.messageController.text, args);
                    },
                    icon: const Icon(Icons.send, color: AppColors.primary)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
