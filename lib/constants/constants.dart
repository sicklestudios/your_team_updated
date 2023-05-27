import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String appVersion = '2.0.0';
String appName = "Your Chat";
var firebaseAuth = FirebaseAuth.instance;
var firebaseFirestore = FirebaseFirestore.instance;
var userInfo;
const fcmPost = "https://fcm.googleapis.com/fcm/send";
// const appId = 'b2f84a50565243f2a23a384c7fbb229c';
const fcmServerKey =
    'key=AAAAkDRUyUw:APA91bFM2OXKHfmMzKtdvqjnhwRSB75JWJXkvjV4N8qYsyCdbaneR2T8e2GtPTvo3xZxD53dEm0IgrsvmOD83njL-9m6FGXhh1117akvIZNxGsKxEVmim1UZ_ge_-M5zrl6yg9Xb1JLo';
String staticPhotoUrl =
    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png";

var CHANNEL_NAME = '';
var CALLERDATA;
var TOKEN = '';
// var role = ClientRole.Broadcaster;
var PROFILE;
var VIDEO_OR_AUDIO_FLG = false;
var ISOPEN = false;
var CURRENT_CONTEXT;
// var role = Client.Broadcaster;

String agoraAppId = "b2f84a50565243f2a23a384c7fbb229c";
String agoraAppCertificate = "478b46cf1f6948058dfa2222f76e77f7";
String agoraTempToken =
    "007eJxTYPi55T2DlENLV1WB7tFWa/2qBQtjnp3mP6U5hefHun87nVoVGJKM0ixMEk0NTM1MjUyM04wSjYwTjS1Mks3TkpKMjCyTXWPeJjcEMjJI3HRnYWSAQBCfiaEqm4EBACxwHuE=";

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

void printInfo(String text) {
  print('\x1B[34m$text\x1B[0m');
}

void printSuccess(String text) {
  print('\x1B[32m$text\x1B[0m');
}
class MenuItem {
  final String text;
  final IconData icon;
  const MenuItem({
    required this.text,
    required this.icon,
  });
}
