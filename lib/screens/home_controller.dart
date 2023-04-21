import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:cached_network_image/cached_network_image.dart';
// import 'package:callkeep/callkeep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:yourteam/call_constants_global.dart';
import 'package:yourteam/call_ongoing_notification.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/methods/auth_methods.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/navigation_service.dart';
import 'package:yourteam/screens/auth/login_screen.dart';
import 'package:yourteam/screens/bottom_pages.dart/contacts_screen.dart';
import 'package:yourteam/screens/bottom_pages.dart/profile/profile_screen.dart';
import 'package:yourteam/screens/bottom_pages.dart/todo_screen.dart';
import 'package:yourteam/screens/drawer/drawer_files/drawer_menu-controller.dart';
import 'package:yourteam/screens/drawer/drawer_todo_controller.dart';
import 'package:yourteam/screens/group/screens/create_group_screen.dart';
import 'package:yourteam/screens/notifications_screen.dart';
import 'package:yourteam/screens/search_screen.dart';
import 'package:yourteam/screens/task/add_task.dart';
import 'package:yourteam/screens/toppages/call_screen_list.dart';
import 'package:yourteam/screens/toppages/chat/chat_list_screen.dart';
import 'package:yourteam/service/fcmcallservices/fcmcallservices.dart';
import 'package:yourteam/service/local_push_notification.dart';
import 'package:yourteam/utils/helper_widgets.dart';
import 'package:yourteam/utils/voice_search_textfield.dart';

// // //message handler
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   var notification = message.data;

//   var data = await jsonDecode(notification['content']);
//   if (data['body'] == "oye its a message" || data['body'] == "oye its a task") {
//     log('SHowing notification from home');
//     LocalNotificationService.display(
//       message,
//     );
//   } else {
//     await FcmCallServices.showFlutterNotification(message);
//   }
// }

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  /// For fcm background message handler.
  ///
  //TextField search controller
  final TextEditingController _textEditingController = TextEditingController();

  //value to get from text field
  String value = "";
  int pageIndex = 0;
  int bottomIndex = 0;
  var topPages = [];
  var bottomPages = [];
  FocusNode searchFieldFocusNode = FocusNode();
  initvariables() async {
    await storeNotificationToken();
    await fetchUserInfo();
    ISOPEN = true;
    CURRENT_CONTEXT = context;

    await FcmCallServices.forgroundnotify();
    FirebaseMessaging.onBackgroundMessage(
        FcmCallServices.firebaseMessagingBackgroundHandler);
  }

  _getText() {
    if (bottomIndex == 0) {
      if (pageIndex == 0) {
        return "Chats";
      }
      return "Calls";
    } else if (bottomIndex == 1) {
      return "To Do";
    } else if (bottomIndex == 2) {
      return "Contact";
    } else {
      return "Profile";
    }
  }

  _getBottomItem(IconData icon, String label, color) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: color,
        size: 28,
      ),
      label: label,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      bottomIndex = index;
      value = "";
      showSearchBar = false;
    });
  }

  // Animation controller
  late AnimationController _animationController;

  // // This is used to animate the icon of the main FAB
  // late Animation<double> _buttonAnimatedIcon;

  // This is used for the child FABs
  late Animation<double> _translateButton;

  // This variable determines whether the child FABs are visible or not
  bool _isExpanded = false;
  String? _currentUuid;

  bool showSearchBar = false;
  T? _ambiguate<T>(T? value) => value;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10))
      ..addListener(() {
        setState(() {});
      });

    // _buttonAnimatedIcon =
    //     Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: 200,
      end: -5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AuthMethods().setUserState(true);
    //setting up fcm

    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(
    //     event,
    //   );
    // });
    //Check call when open app from terminated
    checkAndNavigationCallingPage();
    initvariables();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    LocalNotificationService.initialize();
    initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      // if (await FlutterForegroundTask.isRunningService) {
      //   final newReceivePort = await FlutterForegroundTask.receivePort;
      //   _registerReceivePort(newReceivePort);
      // }
    });
    // FlutterBackgroundService().invoke("setAsForeground");
    // _callKeep.setup(context, callSetup);
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  checkAndNavigationCallingPage() async {
    appValueNotifier.setToInitial();
    appValueNotifier.setCallAccepted();
    callValueNotifiers.setToInitial();
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      setState(() {
        appValueNotifier.globalisCallOnGoing.value = true;
      });
      NavigationService.instance
          .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
    } else {
      if (mounted) {
        setState(() {
          appValueNotifier.globalisCallOnGoing.value = false;
        });
      }
    }
  }

  //Notification related work

  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  // dispose the animation controller
  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
    _textEditingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        fetchUserInfoWithoutSetState();
        AuthMethods().setUserState(true);
        checkAndNavigationCallingPage();
        break;
      case AppLifecycleState.inactive:
        AuthMethods().setUserState(false);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        AuthMethods().setUserState(false);
        break;
    }
  }

  _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _isExpanded = !_isExpanded;
  }

  //getting the userInfo
  fetchUserInfo() async {
    {
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser?.uid)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            userInfo = UserModel.getValuesFromSnap(value);
          });
        }
      });
    }
  }

  //getting the userInfo
  fetchUserInfoWithoutSetState() async {
    {
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser?.uid)
          .get()
          .then((value) {
        userInfo = UserModel.getValuesFromSnap(value);
      });
    }
  }

  void search(val) {
    setState(() {
      value = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      fetchUserInfo();
    }
    topPages = [
      ChatContactsListScreen(
        value: value,
      ),
      const CallScreenList(),
    ];
    bottomPages = [
      ChatContactsListScreen(
        value: value,
      ),
      const CallScreenList(),
      const TodoScreen(),
      ContactsScreen(
        value: value,
        isChat: true,
      ),
      const ProfileScreen(),
    ];
    var size = MediaQuery.of(context).size;
    return WithForegroundTask(
      child: WillPopScope(
        onWillPop: () async {
          if (value != "") {
            setState(() {
              value = "";
              _textEditingController.text = "";
            });
            searchFieldFocusNode.unfocus();
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: GestureDetector(
              onTap: () {
                // if (value != "") {
                //   setState(() {
                //     value = "";
                //     _textEditingController.text = "";
                //   });
                // }
              },
              child: Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: appValueNotifier.globalisCallOnGoing,
                      builder: (context, value, widget) {
                        if (appValueNotifier.globalisCallOnGoing.value) {
                          return getCallNotifierWidget(context);
                        }
                        return Container();
                      }),
                  Expanded(
                    child: Scaffold(
                      // backgroundColor: scaffoldBackgroundColor,
                      floatingActionButton: bottomIndex == 0 || bottomIndex == 2
                          ? _getFloatingButton()
                          : const SizedBox(),

                      bottomNavigationBar: BottomNavigationBar(
                          backgroundColor: bottomNavigationBarColor,
                          showSelectedLabels: true,
                          showUnselectedLabels: true,
                          items: <BottomNavigationBarItem>[
                            _getBottomItem(
                                FontAwesomeIcons.commentDots,
                                "Chats",
                                bottomIndex == 0 ? whiteColor : greyColor),
                            _getBottomItem(Icons.call, "Calls",
                                bottomIndex == 1 ? whiteColor : greyColor),
                            _getBottomItem(
                                FontAwesomeIcons.circleCheck,
                                "To Do",
                                bottomIndex == 2 ? whiteColor : greyColor),
                            _getBottomItem(
                                FontAwesomeIcons.peopleGroup,
                                "Contacts",
                                bottomIndex == 3 ? whiteColor : greyColor),
                            _getBottomItem(Icons.person, "Profile",
                                bottomIndex == 4 ? whiteColor : greyColor),
                          ],
                          type: BottomNavigationBarType.fixed,
                          currentIndex: bottomIndex,
                          selectedItemColor: whiteColor,
                          unselectedItemColor: greyColor,
                          iconSize: 35,
                          onTap: _onItemTapped,
                          elevation: 5),
                      appBar:
                          //  showSearchBar
                          //     ? AppBar(
                          //         automaticallyImplyLeading: false,
                          //         backgroundColor: Colors.transparent,
                          //         toolbarHeight: 100,
                          //         foregroundColor: Colors.black,
                          //         leading: IconButton(
                          //             onPressed: () {
                          //               setState(() {
                          //                 showSearchBar = !showSearchBar;
                          //               });
                          //             },
                          //             icon: const Icon(Icons.arrow_back_ios)),
                          //         elevation: 0,
                          //         title: TextField(
                          //           onChanged: (val) {
                          //             setState(() {
                          //               value = val;
                          //             });
                          //           },
                          //           decoration: const InputDecoration(
                          //               border: InputBorder.none,
                          //               hintText: 'Search'),
                          //         ))
                          //     :

                          AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: whiteColor,
                        toolbarHeight: 70,
                        elevation: 1.5,
                        leading: bottomIndex == 0
                            ? Builder(builder: (context) {
                                return IconButton(
                                  onPressed: () {
                                    // showSimpleDialog(context)
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: getIcon(Icons.menu),
                                  // icon: Image.asset('assets/group.png'),
                                );
                              })
                            : null,
                        title: Builder(builder: (context) {
                          if (bottomIndex == 0) {
                            return const Text(
                              "Chats",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            );
                          } else if (bottomIndex == 1) {
                            return const Text(
                              "Calls",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            );
                          } else if (bottomIndex == 2) {
                            return Row(
                              children: [
                                if (userInfo != null)
                                  showUsersImage(userInfo.photoUrl == "",
                                      picUrl: userInfo.photoUrl, size: 20),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "My Tasks",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            );
                          } else if (bottomIndex == 3) {
                            return const Text(
                              "Contacts",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            );
                          } else {
                            return const Text(
                              "Account",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            );
                          }
                        }),
                        centerTitle: true,
                        actions: [
                          // if (bottomIndex != 1 &&
                          //     bottomIndex != 3 &&
                          //     pageIndex != 1)
                          //   IconButton(
                          //     onPressed: () {
                          //       setState(() {
                          //         showSearchBar = !showSearchBar;
                          //       });
                          //     },
                          //     icon: getIcon(Icons.search),
                          //   ),
                          if (bottomIndex == 3)
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchScreen()));
                                },
                                child: const Text("Add New")),
                          if (bottomIndex != 3)
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationsScreen()));
                              },
                              icon: getIcon(Icons.notifications),
                            ),
                        ],
                      ),
                      drawer: SafeArea(
                        child: Drawer(
                          backgroundColor: mainColor,
                          width: size.width / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     IconButton(
                              //         onPressed: () {
                              //           Navigator.pop(context);
                              //         },
                              //         icon: const Icon(
                              //           Icons.close_rounded,
                              //           color: Colors.red,
                              //         )),
                              //   ],
                              // ),
                              ListTile(
                                leading: SizedBox(
                                  width: 60,
                                  child: CircleAvatar(
                                    radius: 45,
                                    backgroundImage: userInfo == null
                                        ? const AssetImage(
                                            'assets/user.png',
                                          )
                                        : userInfo!.photoUrl == ""
                                            ? const AssetImage(
                                                'assets/user.png',
                                              )
                                            : CachedNetworkImageProvider(
                                                userInfo!.photoUrl,
                                              ) as ImageProvider,
                                  ),
                                ),
                                title: Text(
                                  userInfo == null
                                      ? "Loading"
                                      : userInfo!.username,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(
                                      userInfo == null
                                          ? "Loading"
                                          : userInfo!.email,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                ),
                                // trailing: IconButton(
                                //     onPressed: () {
                                //       Navigator.pop(context);
                                //     },
                                //     icon: const Icon(
                                //       Icons.close_rounded,
                                //       color: Colors.red,
                                //     )),
                              ),
                              const SizedBox(height: 50),
                              Expanded(
                                child: Container(
                                  // height: size.height / 1.6,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25),
                                          topRight: Radius.circular(25))),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            ListTile(
                                              dense: true,
                                              leading: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  width: 45,
                                                  height: 45,
                                                  child: const Center(
                                                      child: Icon(
                                                    Icons.folder,
                                                    size: 30,
                                                    color: Color.fromARGB(
                                                        255, 85, 164, 88),
                                                  ))),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DrawerMenuController()));
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => const MyDoctors()));
                                              },
                                              title: const Text(
                                                "Files",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // ListTile(
                                            //   onTap: () {
                                            //     Navigator.pop(context);
                                            //     // Navigator.push(
                                            //     //     context,
                                            //     //     MaterialPageRoute(
                                            //     //         builder: (context) => const AllRecords()));
                                            //   },
                                            //   leading: Container(
                                            //     decoration: BoxDecoration(
                                            //         color: Colors.blue.withOpacity(0.3),
                                            //         borderRadius: BorderRadius.circular(50)),
                                            //     width: 45,
                                            //     height: 45,
                                            //     child: const Center(
                                            //         child: Icon(
                                            //       Icons.notes_outlined,
                                            //       size: 35,
                                            //       color: Colors.blue,
                                            //     )),
                                            //   ),
                                            //   title: const Text(
                                            //     "Notes",
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontWeight: FontWeight.bold),
                                            //   ),
                                            //   trailing: const Icon(
                                            //     Icons.arrow_forward_ios,
                                            //     size: 18,
                                            //     color: Colors.black,
                                            //   ),
                                            // ),
                                            ListTile(
                                              leading: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                width: 45,
                                                height: 45,
                                                child: const Center(
                                                    child: Icon(
                                                  Icons.note_alt,
                                                  size: 35,
                                                  color: Color.fromARGB(
                                                      255, 171, 70, 70),
                                                )),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DrawerTodoController()));
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) => const PaymentScreen()));
                                              },
                                              title: const Text(
                                                "To Do",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // ListTile(
                                        //   leading: Container(
                                        //     decoration: BoxDecoration(
                                        //         color:
                                        //             const Color.fromARGB(255, 249, 236, 122)
                                        //                 .withOpacity(0.3),
                                        //         borderRadius: BorderRadius.circular(50)),
                                        //     width: 45,
                                        //     height: 45,
                                        //     child: Center(
                                        //         child: Icon(
                                        //       Icons.lock_clock,
                                        //       size: 35,
                                        //       color: Colors.yellow.shade900,
                                        //     )),
                                        //   ),
                                        //   onTap: () {
                                        //     Navigator.pop(context);
                                        //     // Navigator.push(
                                        //     //     context,
                                        //     //     MaterialPageRoute(
                                        //     //         builder: (context) => const PaymentScreen()));
                                        //   },
                                        //   title: const Text(
                                        //     "Reminder",
                                        //     style: TextStyle(
                                        //         color: Colors.black,
                                        //         fontWeight: FontWeight.bold),
                                        //   ),
                                        //   trailing: const Icon(
                                        //     Icons.arrow_forward_ios,
                                        //     size: 18,
                                        //     color: Colors.black,
                                        //   ),
                                        // ),
                                        Column(
                                          children: [
                                            ListTile(
                                              leading: Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                            255, 249, 236, 122)
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                width: 45,
                                                height: 45,
                                                child: Center(
                                                    child: Icon(
                                                  Icons.logout_rounded,
                                                  size: 35,
                                                  color: Colors.yellow.shade900,
                                                )),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                AuthMethods()
                                                    .setUserState(false);
                                                AuthMethods().signOut();
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen(),
                                                    ),
                                                    ModalRoute.withName(
                                                        '/login'));
                                              },
                                              title: const Text(
                                                "Logout",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: bottomIndex == 0
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20),
                                    child: SizedBox(
                                        height: 50,
                                        child: VoiceSearchTextField(
                                            searchFieldFocusNode:
                                                searchFieldFocusNode,
                                            textEditingController:
                                                _textEditingController,
                                            onChanged: search)),
                                  ),
                                  // _TabSwitch(
                                  //   value: pageIndex,
                                  //   callBack: () {
                                  //     setState(() {
                                  //       if (pageIndex == 0) {
                                  //         pageIndex = 1;
                                  //       } else {
                                  //         pageIndex = 0;
                                  //       }
                                  //     });
                                  //   },
                                  // ),
                                  topPages[pageIndex],
                                ],
                              ),
                            )
                          : bottomIndex == 3
                              ? Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20),
                                    child: SizedBox(
                                        height: 50,
                                        child: VoiceSearchTextField(
                                            searchFieldFocusNode:
                                                searchFieldFocusNode,
                                            textEditingController:
                                                _textEditingController,
                                            onChanged: search)),
                                  ),
                                  bottomPages[bottomIndex]
                                ])
                              : bottomPages[bottomIndex],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _getFloatingButton() {
    return bottomIndex == 2
        ? FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddTask()));
            },
            label: const Text("Add Task"),
            icon: const Icon(Icons.add),
          )
        : DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              customButton: Card(
                elevation: 8,
                color: mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: const Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              items: [
                ...MenuItemsHome.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItemsHome.buildItem(item),
                  ),
                ),
                // const DropdownMenuItem<Divider>(
                //     enabled: false, child: Divider()),
              ],
              onChanged: (value) {
                MenuItemsHome.onChanged(
                    context, value as MenuItem, showNewMessage, showNewCall);
              },
              dropdownStyleData: DropdownStyleData(
                width: 180,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: mainColor,
                ),
                elevation: 8,
                offset: const Offset(0, 8),
              ),
            ),
          );
  }
}

class MenuItemsHome {
  static List<MenuItem> firstItems = [newChat, newCall, newContact, newGroup];
  // static List<MenuItem> secondItems = [logout];

  static var newChat = const MenuItem(
    text: "New Chat",
    icon: FontAwesomeIcons.commentDots,
  );
  static var newCall = const MenuItem(
    text: "New Call",
    icon: Icons.call,
  );
  static var newContact =
      const MenuItem(text: 'New Contact', icon: Icons.people);

  static var newGroup =
      const MenuItem(text: "New Group", icon: Icons.groups_rounded);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(
    BuildContext context,
    MenuItem item,
    Function newChatCallBack,
    Function newCallCallBack,
  ) {
    if (item == MenuItemsHome.newChat) {
      newChatCallBack(context);
    } else if (item == MenuItemsHome.newCall) {
      newCallCallBack(context);
    } else if (item == MenuItemsHome.newContact) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SearchScreen()));
    } else if (item == MenuItemsHome.newGroup) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateGroupScreen()));
    }
  }
}

class _TabSwitch extends StatefulWidget {
  int value;
  VoidCallback callBack;
  _TabSwitch({Key? key, required this.value, required this.callBack})
      : super(key: key);

  @override
  State<_TabSwitch> createState() => _TabSwitchState();
}

class _TabSwitchState extends State<_TabSwitch> {
  bool isPlay = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (widget.value == 0) {
      isPlay = true;
    } else {
      isPlay = false;
    }
    return GestureDetector(
      onTap: widget.callBack,
      child: Container(
        height: 50,
        width: size.width / 1.2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(35)),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: isPlay ? 0 : size.width / 1.2 * 0.5,
              child: Container(
                height: 50,
                width: size.width / 1.2 * 0.5,
                decoration: BoxDecoration(
                    color: mainColor, borderRadius: BorderRadius.circular(35)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                          color: isPlay ? Colors.white : mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Calls",
                      style: TextStyle(
                          color: isPlay ? mainColor : Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
