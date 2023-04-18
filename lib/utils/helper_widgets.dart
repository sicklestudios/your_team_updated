//get the users image
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget showUsersImage(
  bool isAsset, {
  String picUrl = "assets/user.png",
  double size = 25,
}) {
  if (picUrl == "") {
    picUrl = "assets/user.png";
  }
  return CircleAvatar(
    radius: size,
    backgroundImage: isAsset
        ? AssetImage(picUrl)
        : CachedNetworkImageProvider(picUrl) as ImageProvider,
  );
}
