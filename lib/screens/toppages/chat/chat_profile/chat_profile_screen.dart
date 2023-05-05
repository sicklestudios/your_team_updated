import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/models/chat_model.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/screens/bottom_pages.dart/todo_screen.dart';
import 'package:yourteam/screens/drawer/drawer_files/drawer_file_screen.dart';
import 'package:yourteam/screens/drawer/drawer_files/drawer_media_screen.dart';
import 'package:yourteam/utils/helper_widgets.dart';

class ChatProfileScreen extends StatefulWidget {
  final ChatContactModel chatContactModel;
  const ChatProfileScreen({required this.chatContactModel, super.key});

  @override
  State<ChatProfileScreen> createState() => _ChatProfileScreenState();
}

class _ChatProfileScreenState extends State<ChatProfileScreen> {
  bool isGroupChat = false;
  ValueNotifier<int> controlValue = ValueNotifier(0);
  Future<UserModel> getUserInfo() async {
    return firebaseFirestore
        .collection('users')
        .doc(widget.chatContactModel.contactId)
        .get()
        .then((value) {
      return UserModel.getValuesFromSnap(value);
    });
  }

  void callBack(int val) {
    controlValue.value = val;
  }

  @override
  Widget build(BuildContext context) {
    log("Value = " + controlValue.value.toString());
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "User Profile",
          style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
          future: getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child: Text("Nothing to show you"),
              );
            }
            var data = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TopWidget(
                    chatContactModel: widget.chatContactModel,
                    isGroupChat: isGroupChat,
                    isTodo: controlValue.value,
                    size: size,
                    data: data,
                    callBack: callBack),
                const SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder(
                    valueListenable: controlValue,
                    builder: (context, value, check) {
                      return value == 0
                          ? isGroupChat
                              ? Expanded(
                                  child: TodoScreen(
                                  // id: widget.contactModel.contactId,
                                  isGroupChat: isGroupChat,
                                  // people: widget.people,
                                ))
                              : Expanded(
                                  child: TodoScreen(
                                  id: widget.chatContactModel.contactId,
                                ))
                          : value == 1
                              ? Expanded(
                                  child: MediaScreen(
                                  id: widget.chatContactModel.contactId,
                                  isGroupChat: isGroupChat,
                                ))
                              : Expanded(
                                  child: FileScreen(
                                  id: widget.chatContactModel.contactId,
                                  isGroupChat: isGroupChat,
                                ));
                    })

            
              ],
            );
          }),
    );
  }
}

class TopWidget extends StatelessWidget {
  final ChatContactModel chatContactModel;
  final Size size;
  final UserModel data;
  final bool isGroupChat;
  int isTodo;
  Function callBack;
  TopWidget(
      {required this.chatContactModel,
      required this.size,
      required this.data,
      required this.isGroupChat,
      required this.isTodo,
      required this.callBack,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.width,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  getAvatarWithStatus(isGroupChat, chatContactModel, size: 50),
                  // showUsersImage(data.photoUrl == "",
                  //     size: 50,
                  //     picUrl: data.photoUrl != ""
                  //         ? data.photoUrl
                  //         : "assets/user.png"),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            data.username == ""
                                ? "Nothing to show"
                                : data.username,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            data.email == "" ? "Nothing to show" : data.email,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Center(
            //   child: Text(
            //     data.bio == "" ? "Nothing to show" : data.bio,
            //     textAlign: TextAlign.center,
            //     overflow: TextOverflow.visible,
            //     style:
            //         const TextStyle(fontWeight: FontWeight.w500),
            //   ),
            // ),
            StatefulBuilder(builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isTodo = 0;
                        });
                        callBack(0);
                      },
                      child: Text(
                        "To-do",
                        style: TextStyle(
                            color: isTodo == 0 ? mainColor : Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isTodo = 1;
                        });
                        callBack(1);
                      },
                      child: Text(
                        "Media",
                        style: TextStyle(
                            color: isTodo == 1 ? mainColor : Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isTodo = 2;
                        });
                        callBack(2);
                      },
                      child: Text(
                        "Files",
                        style: TextStyle(
                            color: isTodo == 2 ? mainColor : Colors.black),
                      )),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
