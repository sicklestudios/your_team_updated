import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/methods/chat_methods.dart';
import 'package:yourteam/models/chat_model.dart';
import 'package:yourteam/models/group.dart';

class ChatContactsListScreen extends StatefulWidget {
  String value;
  ChatContactsListScreen({required this.value, super.key});

  @override
  State<ChatContactsListScreen> createState() => _ChatContactsListScreenState();
}

class _ChatContactsListScreenState extends State<ChatContactsListScreen> {
  bool isShown = false;
  String previousTime = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<Group>>(
                stream: ChatMethods().getChatGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text(""),
                    );
                  }
                  List<Group> tempGroups = [];

                  tempGroups = [];
                  // if (snapshot.data == null) {
                  //   return getNewChatPrompt(context);
                  // }
                  if (widget.value != "") {
                    for (var element in snapshot.data!) {
                      if (element.name.contains(widget.value)) {
                        tempGroups.add(element);
                      }
                    }
                  } else {
                    tempGroups = snapshot.data!;
                  }
                  // if (temp.isEmpty) {
                  //   // return const Center(
                  //   //   child: Text("Nothing to show"),
                  //   // );
                  //   return getNewChatPrompt(context);
                  // }
                  return StreamBuilder<List<ChatContactModel>>(
                      stream: ChatMethods().getChatContacts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data == null) {
                          return getNewChatPrompt(context);
                        }
                        List temp = [...tempGroups];
                        if (widget.value != "") {
                          for (var element in snapshot.data!) {
                            if (element.name.contains(widget.value)) {
                              temp.add(element);
                            }
                          }
                        } else {
                          temp += snapshot.data!;
                        }
                        if (temp.isEmpty) {
                          // return const Center(
                          //   child: Text("Nothing to show"),
                          // );
                          return getNewChatPrompt(context);
                        }

                        // sorting the chats list
                        temp.sort((a, b) {
                          var adate;
                          var bdate;
                          try {
                            ChatContactModel model1 = a;
                            adate = model1.timeSent;
                          } catch (e) {
                            Group group1 = a;
                            adate = group1.timeSent;
                          }
                          try {
                            ChatContactModel model2 = b;
                            bdate = model2.timeSent;
                          } catch (e) {
                            Group group2 = b;
                            bdate = group2.timeSent;
                          }

                          return adate.compareTo(bdate);
                        });
                        temp = temp.reversed.toList();

                        return ListView.builder(
                            itemCount: temp.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: ((context, index) {
                              var data = temp[index];

                              //getting the dates
                              var dateInList =
                                  DateFormat.MMMMEEEEd().format(data.timeSent);
                              if (previousTime != dateInList) {
                                previousTime = dateInList;
                                isShown = false;
                              } else {
                                isShown = true;
                              }
                              try {
                                ChatContactModel model = data;
                                return Column(
                                  children: [
                                    if (!isShown) getDateWithLines(dateInList),
                                    getMessageCard(model, context)
                                  ],
                                );
                              } catch (e) {
                                Group group = data;
                                return Column(
                                  children: [
                                    if (!isShown) getDateWithLines(dateInList),
                                    getMessageCard(group, context,
                                        isGroupChat: true)
                                  ],
                                );
                              }
                              // log((data == Group).toString());
                            }));
                      });
                }),
          ],
        ),
      ),
    );
  }
  //showing the time
}

// ListView.builder(
//                       itemCount: temp.length,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: ((context, index) {
//                         var data = temp[index];
//                         return getMessageCard(data, context, isGroupChat: true);
//                       }));

 