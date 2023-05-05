import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/constants/utils.dart';
import 'package:yourteam/methods/storage_methods.dart';
import 'package:yourteam/models/chat_model.dart';
import 'package:yourteam/models/group.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/screens/bottom_pages.dart/todo_screen.dart';
import 'package:yourteam/screens/drawer/drawer_files/drawer_file_screen.dart';
import 'package:yourteam/screens/drawer/drawer_files/drawer_media_screen.dart';
import 'package:yourteam/models/group.dart' as model;

class ChatProfileGroup extends StatefulWidget {
  final ChatContactModel chatContactModel;
  final List? people;
  const ChatProfileGroup({required this.chatContactModel,
  required this.people,
   super.key});


  @override
  State<ChatProfileGroup> createState() => _ChatProfileGroupState();
}

class _ChatProfileGroupState extends State<ChatProfileGroup> {
  final TextEditingController groupNameController = TextEditingController();
  bool isLoaded = false;
  File? image;
  List<String> peopleUid = [];
  Group? groupInfo;
  Future<String>? future;
    ValueNotifier<int> controlValue = ValueNotifier(0);
  // List people = [];
  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    String url = await StorageMethods()
        .storeFileToFirebase('group/${groupInfo!.groupId}', image!);
    await firebaseFirestore.collection('groups').doc(groupInfo!.groupId).update(
      {
        "groupPic": url,
      },
    );
    showToastMessage("Group Picture updated");
    setState(() {});
  }

  void refresh() async {
    // people = [];
    // for (var e in peopleUid) {
    //   UserModel userModel = UserModel.getValuesFromSnap(
    //       await firebaseFirestore.collection("users").doc(e).get());
    //   people.add(userModel);
    // }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  void createGroup() async {
    if (groupNameController.text.trim().isNotEmpty) {
      try {
        model.Group group = model.Group(
          lastMessageBy: groupInfo!.lastMessageBy,
          name: groupNameController.text.trim(),
          groupId: groupInfo!.groupId,
          lastMessage: groupInfo!.lastMessage,
          groupPic: groupInfo!.groupPic,
          membersUid: peopleUid,
          isSeen: groupInfo!.isSeen,
          timeSent: groupInfo!.timeSent,
        );

        await firebaseFirestore
            .collection('groups')
            .doc(groupInfo!.groupId)
            .update(group.toMap());
        Navigator.pop(context);
      } catch (e) {
        showToastMessage(e.toString());
      }
    }
  }

  getInfo() async {
    return await firebaseFirestore
        .collection('groups')
        .doc(widget.chatContactModel.contactId)
        .get()
        .then((value) {
      Group val = Group.fromMap(value.data()!);
      groupInfo = val;
      peopleUid = val.membersUid;
      groupNameController.text = val.name;
      setState(() {
        isLoaded = true;
      });
      future = getImage(groupInfo!.groupId, true);

      return val;
    });
  }


  void callBack(int val) {
    controlValue.value = val;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: peopleUid.isNotEmpty ? createGroup : null,
            icon: Icon(
              Icons.done,
              color: peopleUid.isEmpty ? Colors.grey : Colors.black,
            ),
          )
        ],
        title: const Text(
          "Group Info",
          style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:SizedBox(
        height: size.height,
        child: !isLoaded
          ? const Center(child: CircularProgressIndicator())
          : getWidget(size, groupInfo),
      ),
    );
  }
  // FutureBuilder<Group>(
  //           future: getInfo(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return const Center(
  //                 child: CircularProgressIndicator(),
  //               );
  //             }
  //             if (snapshot.data == null) {
  //               return const Center(
  //                 child: Text("Nothing to show you"),
  //               );
  //             }
  //             var data = snapshot.data!;

  //           }),
  getWidget(size, data) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Container(
              width: size.width / 1.2,
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            data.groupPic != "" || data.groupPic != null
                                ? FutureBuilder(
                                    future: future,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return CircleAvatar(
                                            radius: 80,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              snapshot.data!,
                                            ));
                                      }
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                            radius: 80,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                              snapshot.data!,
                                            ));
                                      } else {
                                        return const CircleAvatar(
                                            radius: 80,
                                            child: Icon(
                                              Icons.groups_outlined,
                                              size: 100,
                                            ));
                                      }
                                    })
                                : const CircleAvatar(
                                    radius: 80,
                                    child: Icon(
                                      Icons.groups_outlined,
                                      size: 100,
                                    )),
                            Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  elevation: 2.0,
                                  fillColor: const Color(0xFFF5F6F9),
                                  padding: const EdgeInsets.all(15.0),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: mainColor,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: TextField(
                            controller: groupNameController,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 20),
                            textAlign: TextAlign.center,
                            // overflow: TextOverflow.visible,
                            // style: const TextStyle(
                            //     fontWeight: FontWeight.w800,
                            //     fontSize: 20),
                          ),
                        ),
                      ),
                    ],
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
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: size.width / 1.2,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text(
                            "Members",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        onTap: () {
                          showPeopleForTask(context, peopleUid, refresh);
                        },
                        title: const Text("Add Group Members"),
                        trailing: Container(
                          decoration: BoxDecoration(
                              color: mainColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50)),
                          width: 45,
                          height: 45,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      child: ListTile(
                        onTap: () {
                          showPeopleForTask(context, peopleUid, refresh,
                              isForGroup: true, groupId: widget.chatContactModel.contactId);
                        },
                        title: const Text("See Group Members"),
                        trailing: Container(
                          decoration: BoxDecoration(
                              color: mainColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(50)),
                          width: 45,
                          height: 45,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: mainColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TopWidget(chatContactModel: widget.chatContactModel, size: size, data: data, isGroupChat: true, isTodo: controlValue.value, callBack: callBack),
          const SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    height: size.height/1.2,
                    child: ValueListenableBuilder(
                        valueListenable: controlValue,
                        builder: (context, value, check) {
                          return value == 0
                              ?  Expanded(
                                      child: TodoScreen(
                                      // id: widget.chatContactModel.contactId,
                                      isGroupChat: true,
                                      people: widget.people,
                                    ))
                                :value == 1
                                  ? Expanded(
                                      child: MediaScreen(
                                      id: widget.chatContactModel.contactId,
                                      isGroupChat: true,
                                    ))
                                    : Expanded(
                                      child: FileScreen(
                                      id: widget.chatContactModel.contactId,
                                      isGroupChat: true,
                                    ));
                               
                        }),
                  )
        ],
      ),
    );
  }
}
class TopWidget extends StatelessWidget {
  final ChatContactModel chatContactModel;
  final Size size;
  final Group data;
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
        width: size.width/1.2,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          
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
