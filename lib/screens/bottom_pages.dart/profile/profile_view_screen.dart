import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:yourteam/constants/colors.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
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
                        onPressed: () {},
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
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
