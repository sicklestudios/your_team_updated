import 'dart:developer';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/methods/firestore_methods.dart';
import 'package:yourteam/methods/task_methods.dart';
import 'package:yourteam/models/todo_model.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/utils/helper_widgets.dart';

class AddTask extends StatefulWidget {
  final String? taskTitle;
  final bool? isFromGroup;
  final String? groupId;
  const AddTask({this.taskTitle, this.isFromGroup, this.groupId, super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String taskDeadline = "";
  bool showAddTaskField = false;
  List people = [];
  List tasksList = [];
  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDesc = TextEditingController();
  TextEditingController taskAssignBy = TextEditingController();

  ScrollController scrollController = ScrollController();
  TextEditingController taskController = TextEditingController();
  // TextEditingController taskAssignBy=TextEditingController();

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    // initializeDateFormatting('en');
    taskAssignBy.text = userInfo.username;
    taskDesc.text = widget.taskTitle ?? "";
    taskTitle.text =
        widget.taskTitle != null ? smallSentence(widget.taskTitle!) : "";
    taskDeadline = "";
    // taskDesc.text = "";
    people = [];
    tasksList = [];
    KeyboardVisibilityController().onChange.listen((isVisible) {
      if (isVisible == false && showAddTaskField) {
        setState(() {
          showAddTaskField = false;
        });
      }
    });
  }

  String smallSentence(String bigSentence) {
    if (bigSentence.length > 30) {
      return bigSentence.substring(0, 30);
    } else {
      return bigSentence;
    }
  }

  void refresh(List values) {
    setState(() {
      tasksList = values;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              taskTitle.text.isEmpty ||
                      taskAssignBy.text.isEmpty ||
                      taskDeadline.isEmpty
                  ? showToastMessage("Fields cannot be empty")
                  : uploadTask();
            },
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Add-Task",
          style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Task Name',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                // color: Color.fromRGBO(23, 35, 49, 1),
                                color: greyColor,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30),
                            ],
                            controller: taskTitle,
                            onFieldSubmitted: (value) {},
                            onChanged: (val) {
                              setState(() {});
                            },
                            autofocus: false,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              //   border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.all(
                              //       Radius.circular(15),
                              //     ),
                              //   ),
                              // filled: true,
                              border: InputBorder.none,
                              hintText: 'Enter the task name',
                              // filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(102, 124, 150, 1),
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            showUsersImage(userInfo.photoUrl == "",
                                picUrl: userInfo.photoUrl, size: 15),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Assigned by',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: greyColor,
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w400,
                                          height: 1),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      userInfo.username,
                                      // textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      // softWrap: true,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          height: 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          // dateMask: 'd MMM, yyyy - hh:mm a',
                          dateMask: 'd MMMM',
                          // use24HourFormat: false,

                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          icon: const Icon(FontAwesomeIcons.calendar),
                          dateLabelText: 'Due Date',
                          timeLabelText: "Time",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),

                          onChanged: (val) {
                            setState(() {
                              taskDeadline = val;
                            });
                          },
                          onSaved: (val) => log(val.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Description',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                // color: Color.fromRGBO(23, 35, 49, 1),
                                color: greyColor,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                                letterSpacing: 0,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            // margin: const EdgeInsets.all(12),
                            height: 5 * 24.0,
                            child: TextField(
                              controller: taskDesc,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Enter Description",
                                fillColor: Colors.grey[300],
                                filled: false,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                // border: const OutlineInputBorder(
                                //   borderRadius: BorderRadius.all(
                                //     Radius.circular(15),
                                //   ),
                                // ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                _getAddedPeople(people: people),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Text(
                        'Tasks',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: greyColor,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                            height: 1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: tasksList.length + 1,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemBuilder: ((context, index) {
                        if (index == tasksList.length) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                showAddTaskField = true;
                                focusNode.requestFocus();
                              });
                            },
                            child: const ListTile(
                              title: Text(
                                "+ Add Subtask",
                                style: TextStyle(
                                    color: greyColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }
                        // TaskModel data =
                        //     TaskModel.fromMap();
                        return InkWell(
                            child: getTaskCard(
                                tasksList[index],
                                context,
                                () => setState(() {
                                      tasksList.removeAt(index);
                                    })));
                      })),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Column(
                //     children: [
                //       Row(
                //         children: const [
                //           Text(
                //             'Assigned By',
                //             textAlign: TextAlign.left,
                //             style: TextStyle(
                //                 color: Color.fromRGBO(23, 35, 49, 1),
                //                 fontFamily: 'Poppins',
                //                 fontSize: 15,
                //                 letterSpacing: 0,
                //                 fontWeight: FontWeight.bold,
                //                 height: 1),
                //           ),
                //         ],
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: SizedBox(
                //           height: 70,
                //           child: TextFormField(
                //             controller: taskAssignBy,
                //             onFieldSubmitted: (value) {},
                //             onChanged: (val) {
                //               setState(() {});
                //             },
                //             autofocus: false,
                //             // obscureText: passObscure,
                //             decoration: const InputDecoration(
                //               //
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.all(
                //                   Radius.circular(15),
                //                 ),
                //               ),
                //               hintText: 'Assigned By',
                //               // filled: true,
                //               fillColor: Colors.white,
                //               hintStyle: TextStyle(
                //                   color: Color.fromRGBO(102, 124, 150, 1),
                //                   fontFamily: 'Poppins',
                //                   fontSize: 13,
                //                   letterSpacing: 0,
                //                   fontWeight: FontWeight.normal,
                //                   height: 1),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         showPeopleForTask(context, people, refresh);
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: mainColor,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //         minimumSize: Size(size.width / 2, 54),
                //       ),
                //       child: const Text(
                //         'Add People',
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             color: Color.fromRGBO(255, 255, 255, 1),
                //             fontFamily: 'Poppins',
                //             fontSize: 15,
                //             letterSpacing:
                //                 0 /*percentages not used in flutter. defaulting to zero*/,
                //             fontWeight: FontWeight.normal,
                //             height: 1),
                //       )),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //       onPressed: () {
                //         showTaskListAdd(context, tasksList, refresh);
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: mainColor,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //         minimumSize: const Size(306, 54),
                //       ),
                //       child: const Text(
                //         'Add tasks',
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             color: Color.fromRGBO(255, 255, 255, 1),
                //             fontFamily: 'Poppins',
                //             fontSize: 15,
                //             letterSpacing:
                //                 0 /*percentages not used in flutter. defaulting to zero*/,
                //             fontWeight: FontWeight.normal,
                //             height: 1),
                //       )),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //       onPressed: taskTitle.text.isEmpty ||
                //               taskAssignBy.text.isEmpty ||
                //               taskDeadline.isEmpty
                //           ? null
                //           : () {
                //               uploadTask();
                //             },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: mainColor,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         padding:
                //             const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                //         minimumSize: const Size(306, 54),
                //       ),
                //       child: const Text(
                //         'Save',
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             color: Color.fromRGBO(255, 255, 255, 1),
                //             fontFamily: 'Poppins',
                //             fontSize: 15,
                //             letterSpacing:
                //                 0 /*percentages not used in flutter. defaulting to zero*/,
                //             fontWeight: FontWeight.normal,
                //             height: 1),
                //       )),
                // ),
              ],
            ),
          ),
          if (showAddTaskField)
            Card(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      focusNode: focusNode,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Add a task",
                          suffixIcon: InkWell(
                              onTap: () {
                                if (taskController.text.isNotEmpty) {
                                  var messageId = const Uuid().v1();

                                  TaskModel taskModel = TaskModel(
                                    taskId: messageId.toString(),
                                    isCompleted: false,
                                    taskTitle: taskController.text,
                                  );
                                  tasksList.add(taskModel);
                                  taskController.text = "";
                                  setState(
                                    () {
                                      tasksList;
                                    },
                                  );
                                }
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  scrollController.jumpTo(scrollController
                                      .position.maxScrollExtent);
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  radius: 18,
                                  child: Icon(
                                    Icons.arrow_upward_sharp,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                              ))),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  uploadTask() async {
    showToastMessage("Uploading Task, Please Wait");
    List taskInMapForm = [];
    //generating the progress
    tasksList.forEach((element) {
      TaskModel model = element;
      taskInMapForm.add(model.toMap());
    });
    String res = await TaskMethods().setTask(
        taskAssignBy.text,
        taskTitle.text,
        taskDeadline.trim(),
        taskDesc.text,
        people,
        taskInMapForm,
        widget.isFromGroup ?? false,
        widget.groupId??""
        );
    if (res == "Success") {
      setState(() {
        taskAssignBy.text = "";
        taskTitle.text = "";
        taskDeadline = "";
        taskDesc.text = "";
        people = [];
        tasksList = [];
      });
    }
  }
}

class _getAddedPeople extends StatefulWidget {
  const _getAddedPeople({
    Key? key,
    required this.people,
  }) : super(key: key);

  final List people;

  @override
  State<_getAddedPeople> createState() => _getAddedPeopleState();
}

class _getAddedPeopleState extends State<_getAddedPeople> {
  List tempList = [];

  @override
  void initState() {
    super.initState();
    tempList = widget.people;
    tempList.remove(firebaseAuth.currentUser!.uid);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'People',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: greyColor,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    height: 1),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: mainColor),
                  borderRadius: BorderRadius.circular(15)),
              child: widget.people.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showPeopleForTask(context, widget.people, refresh);
                          },
                          child: const Card(
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Icon(Icons.add, size: 40),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tempList.length + 1,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        if (widget.people.isEmpty) {}
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showPeopleForTask(
                                    context, widget.people, refresh);
                              },
                              child: const Card(
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Icon(Icons.add, size: 40),
                                ),
                              ),
                            ),
                          );
                        }
                        // return AvatarStack(
                        //   height: 50,
                        //   avatars: [
                        //     for (var n = 0; n < 15; n++)
                        //       NetworkImage('https://i.pravatar.cc/150?img=$n'),
                        //   ],
                        // );
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: FutureBuilder<UserModel>(
                                  future: FirestoreMethods()
                                      .getUserInformationOther(
                                          widget.people[index - 1]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Card(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      snapshot.data!.photoUrl),
                                            ),
                                            Text(
                                              snapshot.data!.username,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ));
                                    }
                                    return const Text("Loading");
                                  })),
                        );
                      })),
            ),
          )
        ],
      ),
    );
  }
}
