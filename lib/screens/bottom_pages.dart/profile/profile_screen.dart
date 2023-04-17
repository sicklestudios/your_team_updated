import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/methods/auth_methods.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/screens/auth/login_screen.dart';
import 'package:yourteam/screens/bottom_pages.dart/profile/profile_view_screen.dart';
import 'package:yourteam/screens/delete_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    fetchUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    fetchUserInfo();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      fetchUserInfo();
      setState(() {});
    }
  }

  //getting the userInfo
  fetchUserInfo() async {
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      color: scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 15,
            ),
            // Center(
            //   child: Container(
            //     width: size.width / 1.2,
            //     height: 200,
            //     decoration: BoxDecoration(
            //         color: Colors.white, borderRadius: BorderRadius.circular(15)),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Column(
            //           children: [
            //             CircleAvatar(
            //               radius: 50,
            //               backgroundImage: userInfo.photoUrl != ""
            //                   ? CachedNetworkImageProvider(userInfo.photoUrl)
            //                   : const AssetImage("assets/user.png")
            //                       as ImageProvider,
            //             ),
            //           ],
            //         ),
            //         Text(
            //           userInfo.bio == "" ? "Nothing to show" : userInfo.bio,
            //           style: const TextStyle(fontWeight: FontWeight.w500),
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Icon(
            //               Icons.location_on,
            //               color: mainColor,
            //             ),
            //             Text(
            //               userInfo.location == ""
            //                   ? "Nothing to show"
            //                   : userInfo.location,
            //               style: const TextStyle(fontWeight: FontWeight.bold),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 50,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 130,
                      width: 130,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  CachedNetworkImageProvider(userInfo.photoUrl))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        userInfo.username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 21),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfileViewScreen()));
                      },
                      child: const Text(
                        "View Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ],
            ),
            // const ProfileUpdateScreen(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text(
                            "Support",
                            style: TextStyle(fontSize: 18, color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: ListTile(
                          onTap: () {
                            _launchUrl("https://yourteam.chat");
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15)),
                            width: 45,
                            height: 45,
                            child: const Icon(
                              FontAwesomeIcons.commentDots,
                              color: mainColor,
                            ),
                          ),
                          title: const Text(
                            "Contact Support",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // subtitle: const Text(
                          //   "Have any confusion? Consult us",
                          //   style: TextStyle(fontWeight: FontWeight.normal),
                          // ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Text(
                            "More",
                            style: TextStyle(fontSize: 18, color: greyColor),
                          ),
                        ],
                      ),
                    ),
                    // ListTile(
                    //   onTap: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) =>
                    //             const ProfileUpdateScreen()));
                    //   },
                    //   leading: Container(
                    //     decoration: BoxDecoration(
                    //         color: mainColor.withOpacity(0.1),
                    //         borderRadius: BorderRadius.circular(15)),
                    //     width: 45,
                    //     height: 45,
                    //     child: const Icon(
                    //       Icons.person,
                    //       color: mainColor,
                    //     ),
                    //   ),
                    //   title: const Text(
                    //     "Account",
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    //   subtitle: const Text(
                    //     "Update your account details",
                    //     style: TextStyle(fontWeight: FontWeight.normal),
                    //   ),
                    //   trailing: const Icon(
                    //     Icons.arrow_forward_ios,
                    //     color: mainColor,
                    //   ),
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Divider(
                    //     color: Colors.black45,
                    //   ),
                    // ),
                    // Column(
                    //   children: [
                    //     ListTile(
                    //       leading: Container(
                    //         decoration: BoxDecoration(
                    //             color: mainColor.withOpacity(0.1),
                    //             borderRadius: BorderRadius.circular(15)),
                    //         width: 45,
                    //         height: 45,
                    //         child: const Icon(
                    //           Icons.chat,
                    //           color: mainColor,
                    //         ),
                    //       ),
                    //       title: const Text(
                    //         "Chat",
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       subtitle: const Text(
                    //         "Control your chat backup",
                    //         style: TextStyle(fontWeight: FontWeight.normal),
                    //       ),
                    //       trailing: const Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: mainColor,
                    //       ),
                    //     ),
                    //     const Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20),
                    //       child: Divider(
                    //         color: Colors.black45,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Column(
                    //   children: [
                    //     ListTile(
                    //       leading: Container(
                    //         decoration: BoxDecoration(
                    //             color: mainColor.withOpacity(0.1),
                    //             borderRadius: BorderRadius.circular(15)),
                    //         width: 45,
                    //         height: 45,
                    //         child: const Icon(
                    //           Icons.send_rounded,
                    //           color: mainColor,
                    //         ),
                    //       ),
                    //       title: const Text(
                    //         "Integration",
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       subtitle: const Text(
                    //         "Sync your other social account",
                    //         style: TextStyle(fontWeight: FontWeight.normal),
                    //       ),
                    //       trailing: const Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: mainColor,
                    //       ),
                    //     ),
                    //     const Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20),
                    //       child: Divider(
                    //         color: Colors.black45,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Container(
                            width: size.width,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: ListTile(
                                onTap: () {
                                  reviewApp();
                                },
                                leading: Container(
                                  decoration: BoxDecoration(
                                      color: mainColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15)),
                                  width: 45,
                                  height: 45,
                                  child: const Icon(
                                    Icons.star_border,
                                    color: mainColor,
                                  ),
                                ),
                                title: const Text(
                                  "Rate the app",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // subtitle: const Text(
                                //   "Have any confusion? Consult us",
                                //   style: TextStyle(fontWeight: FontWeight.normal),
                                // ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: ListTile(
                                onTap: () {
                                  _launchUrl(
                                      "https://yourteam.chat/privacy-policy/");
                                },
                                leading: Container(
                                  decoration: BoxDecoration(
                                      color: mainColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15)),
                                  width: 45,
                                  height: 45,
                                  child: const Icon(
                                    Icons.remove_red_eye,
                                    color: mainColor,
                                  ),
                                ),
                                title: const Text(
                                  "Privacy Policy",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // subtitle: const Text(
                                //   "Have any confusion? Consult us",
                                //   style: TextStyle(fontWeight: FontWeight.normal),
                                // ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                      color: mainColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15)),
                                  width: 45,
                                  height: 45,
                                  child: const Icon(
                                    FontAwesomeIcons.mobile,
                                    color: mainColor,
                                  ),
                                ),
                                title: const Text(
                                  "Version",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                // subtitle: const Text(
                                //   "",
                                //   style: TextStyle(fontWeight: FontWeight.normal),
                                // ),
                                trailing: Text(appVersion),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: size.width,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        onTap: () {
                          showDeleteDialog(
                              context: context,
                              title: "Delete Account",
                              content:
                                  "Are you sure you want to delete your account?",
                              cancelActionText: 'Cancel',
                              defaultActionText: "OK");
                        },
                        leading: Container(
                          decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15)),
                          width: 45,
                          height: 45,
                          child: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                          ),
                        ),
                        title: const Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "Delete your account",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            minimumSize: Size(size.width / 1.2, 50)),
                        onPressed: () {
                          AuthMethods().setUserState(false);
                          AuthMethods().signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              ModalRoute.withName('/login'));
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showDeleteDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String cancelActionText,
    required String defaultActionText,
  }) async {
    if (!Platform.isIOS) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(defaultActionText),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DeleteScreen()));
              },
            ),
            ElevatedButton(
              child: Text(cancelActionText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }

    // todo : showDialog for ios
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(defaultActionText),
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DeleteScreen()));
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(cancelActionText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
  // void showDeleteDialog(){
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) =>  CupertinoAlertDialog(
  //         title:  Text("Dialog Title"),
  //         content:  Text("This is my content"),
  //         actions: [
  //            CupertinoDialogAction(
  //             isDestructiveAction: true,
  //             child: Text("Yes"),
  //              onPressed: (){
  //               showDeleteDialog();
  //              },
  //           ),
  //            CupertinoDialogAction(
  //             isDefaultAction: true,
  //
  //             child: Text("No"),
  //           )
  //         ],
  //       )
  //   );
  // }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch');
  }
}



// ///
// ///import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:yourteam/constants/colors.dart';
// import 'package:yourteam/constants/constants.dart';
// import 'package:yourteam/models/user_model.dart';
// import 'package:yourteam/screens/bottom_pages.dart/profile/profile_update_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with WidgetsBindingObserver {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//     fetchUserInfo();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);

//     fetchUserInfo();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       //do your stuff
//       fetchUserInfo();
//       setState(() {});
//     }
//   }

//   //getting the userInfo
//   fetchUserInfo() async {
//     {
//       await firebaseFirestore
//           .collection("users")
//           .doc(firebaseAuth.currentUser?.uid)
//           .get()
//           .then((value) {
//         userInfo = UserModel.getValuesFromSnap(value);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Center(
//             child: Container(
//               width: size.width / 1.2,
//               height: 200,
//               decoration: BoxDecoration(
//                   color: Colors.white, borderRadius: BorderRadius.circular(15)),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(
//                     children: [
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.end,
//                       //   children: [
//                       //     IconButton(
//                       //       onPressed: () {},
//                       //       icon: const Icon(Icons.edit),
//                       //     )
//                       //   ],
//                       // ),
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: userInfo.photoUrl != ""
//                             ? CachedNetworkImageProvider(userInfo.photoUrl)
//                             : const AssetImage("assets/user.png")
//                                 as ImageProvider,
//                       ),
//                     ],
//                   ),
//                   Text(
//                     userInfo.bio == "" ? "Nothing to show" : userInfo.bio,
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         color: mainColor,
//                       ),
//                       Text(
//                         userInfo.location == ""
//                             ? "Nothing to show"
//                             : userInfo.location,
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           // ProfileUpdateScreen(),
//           Center(
//             child: Container(
//                 width: size.width / 1.2,
//                 height: 170,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ListTile(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => const ProfileUpdateScreen()));
//                       },
//                       leading: Container(
//                         decoration: BoxDecoration(
//                             color: mainColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(15)),
//                         width: 45,
//                         height: 45,
//                         child: const Icon(
//                           Icons.person,
//                           color: mainColor,
//                         ),
//                       ),
//                       title: const Text(
//                         "Account",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: const Text(
//                         "Update your account details",
//                         style: TextStyle(fontWeight: FontWeight.normal),
//                       ),
//                       trailing: const Icon(
//                         Icons.arrow_forward_ios,
//                         color: mainColor,
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Divider(
//                         color: Colors.black45,
//                       ),
//                     ),
//                     // Column(
//                     //   children: [
//                     //     ListTile(
//                     //       leading: Container(
//                     //         decoration: BoxDecoration(
//                     //             color: mainColor.withOpacity(0.1),
//                     //             borderRadius: BorderRadius.circular(15)),
//                     //         width: 45,
//                     //         height: 45,
//                     //         child: const Icon(
//                     //           Icons.chat,
//                     //           color: mainColor,
//                     //         ),
//                     //       ),
//                     //       title: const Text(
//                     //         "Chat",
//                     //         style: TextStyle(fontWeight: FontWeight.bold),
//                     //       ),
//                     //       subtitle: const Text(
//                     //         "Control your chat backup",
//                     //         style: TextStyle(fontWeight: FontWeight.normal),
//                     //       ),
//                     //       trailing: const Icon(
//                     //         Icons.arrow_forward_ios,
//                     //         color: mainColor,
//                     //       ),
//                     //     ),
//                     //     const Padding(
//                     //       padding: EdgeInsets.symmetric(horizontal: 20),
//                     //       child: Divider(
//                     //         color: Colors.black45,
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     // Column(
//                     //   children: [
//                     //     ListTile(
//                     //       leading: Container(
//                     //         decoration: BoxDecoration(
//                     //             color: mainColor.withOpacity(0.1),
//                     //             borderRadius: BorderRadius.circular(15)),
//                     //         width: 45,
//                     //         height: 45,
//                     //         child: const Icon(
//                     //           Icons.send_rounded,
//                     //           color: mainColor,
//                     //         ),
//                     //       ),
//                     //       title: const Text(
//                     //         "Integration",
//                     //         style: TextStyle(fontWeight: FontWeight.bold),
//                     //       ),
//                     //       subtitle: const Text(
//                     //         "Sync your other social account",
//                     //         style: TextStyle(fontWeight: FontWeight.normal),
//                     //       ),
//                     //       trailing: const Icon(
//                     //         Icons.arrow_forward_ios,
//                     //         color: mainColor,
//                     //       ),
//                     //     ),
//                     //     const Padding(
//                     //       padding: EdgeInsets.symmetric(horizontal: 20),
//                     //       child: Divider(
//                     //         color: Colors.black45,
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     ListTile(
//                       leading: Container(
//                         decoration: BoxDecoration(
//                             color: mainColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(15)),
//                         width: 45,
//                         height: 45,
//                         child: const Icon(
//                           Icons.help_rounded,
//                           color: mainColor,
//                         ),
//                       ),
//                       title: const Text(
//                         "Help",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: const Text(
//                         "Have any confusion? Consult us",
//                         style: TextStyle(fontWeight: FontWeight.normal),
//                       ),
//                       trailing: const Icon(
//                         Icons.arrow_forward_ios,
//                         color: mainColor,
//                       ),
//                     ),
//                   ],
//                 )),
//           )
//         ],
//       ),
//     );
//   }
// }

///
///