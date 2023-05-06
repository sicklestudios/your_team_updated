import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/methods/task_methods.dart';
import 'package:yourteam/models/todo_model.dart';
import 'package:yourteam/screens/task/edit_task.dart';

class TodoScreen extends StatefulWidget {
  final String? id;
  final bool? isGroupChat;
  final List? people;
  final bool? isFromNotification;
  const TodoScreen(
      {this.id,
      this.isGroupChat,
      this.people,
      this.isFromNotification,
      super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoModel> onGoingTask = [];
  List<TodoModel> upComingTask = [];
  String uid = "";
  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.id != null) {
  //     uid = widget.id!;
  //   }
  //   log("uid = $uid");
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (widget.isFromNotification != null) {
      if (!widget.isFromNotification!) {
        if (widget.id != null) {
          uid = widget.id!;
        } else {
          uid = firebaseAuth.currentUser!.uid;
        }
      }
    }

    return Container(
      width: size.width,
      height: size.height,
      color: scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<TodoModel>>(
                  stream: TaskMethods().getTodos(
                      isGroupChat: widget.isGroupChat ?? false,
                      people: widget.people),
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
                    upComingTask = [];
                    onGoingTask = [];
                    for (var values in snapshot.data!) {
                      if (values.progress == 0) {
                        if (uid != "") {
                          if (values.people.contains(uid)) {
                            upComingTask.add(values);
                          }
                        } else {
                          upComingTask.add(values);
                        }
                      } else {
                        if (values.progress != 100) {
                          if (uid != "") {
                            if (values.people.contains(uid)) {
                              onGoingTask.add(values);
                            }
                          } else {
                            onGoingTask.add(values);
                          }
                        }
                      }
                    }
                    //adding the ongoing tasks in the upcoming list
                    upComingTask=[...onGoingTask];

                    return Column(
                      children: [
                        // Row(
                        //   children: const [
                        //     Padding(
                        //       padding: EdgeInsets.only(left: 15),
                        //       child: Text(
                        //         "Ongoing Task",
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.bold, fontSize: 20),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                         Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Upcoming Task",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                        // onGoingTask.isEmpty
                        //     ? const Center(
                        //         child: Text(
                        //           "Nothing to show",
                        //           style: TextStyle(fontWeight: FontWeight.bold),
                        //         ),
                        //       )
                        //     : SizedBox(
                        //         width: MediaQuery.of(context).size.width,
                        //         height: 190,
                        //         child: ListView.builder(
                        //             itemCount: onGoingTask.length,
                        //             shrinkWrap: true,
                        //             scrollDirection: Axis.horizontal,
                        //             itemBuilder: ((context, index) {
                        //               var data = onGoingTask[index];
                        //               log(data.todoTitle);
                        //               WidgetsBinding.instance
                        //                   .addPostFrameCallback((_) {
                        //                 moveScreen(data);
                        //               });
                        //               return InkWell(
                        //                 onTap: () {
                        //                   Navigator.of(context).push(
                        //                       MaterialPageRoute(
                        //                           builder: (context) =>
                        //                               EditTask(
                        //                                 isFromNotification: false,
                        //                                 model: data)));
                        //                 },
                        //                 child:
                        //                     getTodoCardOnGoing(data, context),
                        //               );
                        //             })),
                        //       ),
                        // const SizedBox(
                        //   height: 15,
                        // ),
                       
                        upComingTask.isEmpty
                            ? const Center(
                                child: Text(
                                  "Nothing to show",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width,
                                // height: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    itemCount: upComingTask.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    // scrollDirection: Axis.vertical,
                                    itemBuilder: ((context, index) {
                                      var data = upComingTask[index];
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        moveScreen(data);
                                      });

                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTask(
                                                        isFromNotification: false,
                                                        model: data)));
                                        },
                                        child:
                                            getTodoCardOnGoing(data, context),
                                      );
                                    })),
                              ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void moveScreen(element) {
    if (widget.isFromNotification != null) {
      if (widget.isFromNotification!) {
        if (element.todoId == widget.id) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => EditTask(
                isFromNotification:true,
                model: element)));
        }
      }
    }
  }
}
 //if the snapshot contains data
              // return ExpansionPanelList(
              //   expansionCallback: (int index, bool isExpanded) {
              //     setState(() {
              //       if (index == 0) {
              //         showOngoing = !showOngoing;
              //       } else if (index == 1) {
              //         // showOngoing = !showOngoing;
              //         showUpComing = !showUpComing;
              //       }
              //     });
              //   },
              //   children: [
              //     ExpansionPanel(
              //       backgroundColor: mainColorFaded,
              //       headerBuilder: (BuildContext context, bool isExpanded) {
              //         return const ListTile(
              //           title: Text("Ongoing Task"),
              //         );
              //       },
              //       canTapOnHeader: true,
              //       isExpanded: showOngoing,
              //       body: const ListTile(
              //         title: Text("Hey buddy"),
              //       ),
              //     ),
              //     ExpansionPanel(
              //       backgroundColor: mainColorFaded,
              //       headerBuilder: (BuildContext context, bool isExpanded) {
              //         return const ListTile(
              //           title: Text("Upcoming Task"),
              //         );
              //       },
              //       canTapOnHeader: true,
              //       isExpanded: showUpComing,
              //       body: const ListTile(
              //         title: Text("Hey buddy"),
              //       ),
              //     ),
              //   ],
              // );