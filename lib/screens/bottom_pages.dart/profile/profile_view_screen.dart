import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:light_modal_bottom_sheet/light_modal_bottom_sheet.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/screens/bottom_pages.dart/profile/profile_update_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    width: size.width,
                    height: 350,
                    imageUrl: userInfo.photoUrl),
                Positioned(
                  left: 15,
                  top: 30,
                  child: Container(
                      decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(50)),
                      width: 45,
                      height: 45,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            )),
                      )),
                ),
                Positioned(
                  right: 15,
                  top: 30,
                  child: Container(
                      decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(50)),
                      width: 45,
                      height: 45,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                expand: false,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return const Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(25),
                                              topLeft: Radius.circular(25))),
                                      child: ProfileUpdateScreen());
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            )),
                      )),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo.username,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Contact Number",
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        userInfo.contact,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Contact Email",
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        userInfo.contactEmail,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "About",
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: size.width / 1.1,
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                userInfo.bio,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
