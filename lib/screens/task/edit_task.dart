import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/methods/firestore_methods.dart';
import 'package:yourteam/methods/task_methods.dart';
import 'package:yourteam/models/todo_model.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/utils/helper_widgets.dart';

class EditTask extends StatefulWidget {
  final TodoModel model;
  const EditTask({required this.model, super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TodoModel model;
  String taskDeadline = "";
  int progress = 0;
  List tasksList = [];
  bool updatedStarted = false;
  List people = [];
  bool showAddTaskField = false;

  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDesc = TextEditingController();
  TextEditingController taskAssignBy = TextEditingController();
  ScrollController scrollController = ScrollController();
  TextEditingController taskController = TextEditingController();

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    model = widget.model;
    taskDeadline = model.deadline;
    progress = model.progress;
    //Converting the values in map to normal format
    model.taskList.forEach((element) {
      TaskModel model = TaskModel.fromMap(element);
      tasksList.add(model);
    });
    taskTitle.text = model.todoTitle;
    taskDesc.text = model.taskDescription;
    taskAssignBy.text = model.assignedBy;
    KeyboardVisibilityController().onChange.listen((isVisible) {
      if (isVisible == false && showAddTaskField) {
        setState(() {
          showAddTaskField = false;
        });
      }
    });
  }

  void refresh(List values) {
    setState(() {
      tasksList = values;
    });
    int completedTasks = 0;
    tasksList.forEach((element) {
      TaskModel model = element;
      if (model.isCompleted) {
        completedTasks++;
      }
    });
    progress = ((completedTasks / tasksList.length) * 100).toInt();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return !updatedStarted;
      },
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Scaffold(
          // backgroundColor: scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            actions: [
              if (model.createrUid == firebaseAuth.currentUser!.uid)
                IconButton(
                  onPressed: () {
                    TaskMethods().deleteTodo(model.todoId).then((value) {
                      showToastMessage("Deleted Successfully");
                      Navigator.pop(context);
                    });
                  },
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              IconButton(
                onPressed: () {
                  taskTitle.text.isEmpty ||
                          taskAssignBy.text.isEmpty ||
                          taskDeadline.isEmpty ||
                          updatedStarted
                      ? showToastMessage("Fields cannot be empty")
                      : updateTask();
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.black,
                ),
              ),
            ],
            centerTitle: true,
            title: const Text(
              "Edit-Task",
              style:
                  TextStyle(color: mainTextColor, fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(
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
                        SizedBox(
                          height: 50,
                          child: TextFormField(
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // showUsersImage(userInfo.photoUrl == "",
                              //     picUrl: userInfo.photoUrl, size: 15),
                              Padding(
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
                                      model.assignedBy,
                                      textAlign: TextAlign.left,
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
                            ],
                          ),
                        ),
                        Expanded(
                          child: DateTimePicker(
                            type: DateTimePickerType.dateTime,
                            // dateMask: 'd MMM, yyyy - hh:mm a',
                            dateMask: 'd MMMM',
                            // use24HourFormat: false,

                            initialValue:
                                DateTime.parse(model.deadline).toString(),
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
                    Column(
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
                        SizedBox(
                          // margin: const EdgeInsets.all(12),
                          height: 5 * 22.0,
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
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
                            CircularPercentIndicator(
                              radius: 28.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: progress / 100,
                              center: Text(
                                "$progress%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Colors.black),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              reverse: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 237, 236, 236),
                              progressColor: mainColor,
                            )
                          ],
                        ),
                      ],
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
                                        }),
                                    refresh: refresh,
                                    tasksList: tasksList));
                          })),
                    ),
                    _getAddedPeople(
                      people: model.people,
                    ),
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
        ),
      ),
    );
  }

  updateTask() async {
    showToastMessage('Updating Todo, Please Wait');
    setState(() {
      updatedStarted = true;
    });
    List taskInMapForm = [];
    // int completedTasks = 0;
    //generating the progress
    tasksList.forEach((element) {
      // TaskModel model = element;
      // if (model.isCompleted) {
      //   completedTasks++;
      // }
      taskInMapForm.add(element.toMap());
    });
    model.todoTitle = taskTitle.text.trim();
    model.taskDescription = taskDesc.text.trim();

    String res = await TaskMethods().updateTask(
        // ((completedTasks / tasksList.length) * 100).toInt(),
        progress,
        model.createrUid,
        model.assignedBy,
        model.todoTitle,
        taskDeadline,
        model.taskDescription,
        model.todoId,
        model.people,
        taskInMapForm);
    if (res == "Success") {
      Navigator.pop(context);
    } else {
      updatedStarted = false;
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
      padding: const EdgeInsets.all(16.0),
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
                    fontSize: 20,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    height: 1),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
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
                              child: Icon(Icons.add, size: 60),
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
                                  child: Icon(Icons.add, size: 60),
                                ),
                              ),
                            ),
                          );
                        }
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
                                      if (snapshot.hasData) {
                                        return Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        snapshot
                                                            .data!.photoUrl),
                                              ),
                                              Text(snapshot.data!.username),
                                            ],
                                          ),
                                        ));
                                      } else {
                                        return const SizedBox();
                                      }
                                    }
                                    return const Text("Loading");
                                  })),
                        );
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
