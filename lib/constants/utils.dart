import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yourteam/call_constants_global.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/models/call_model.dart';
import 'package:yourteam/models/chat_model.dart';
import 'package:yourteam/models/user_model.dart';
import 'package:yourteam/screens/call/call_methods.dart';
import 'package:yourteam/screens/call/call_notification_sent.dart';
import 'package:yourteam/screens/call/calls_ui/screens/dialScreen/dial_screen.dart';
import 'package:yourteam/utils/SharedPreferencesUser.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    // showSnackBar(context: context, content: e.toString());
  }
  return image;
}

//getting the userInfo
fetchUserInfoFromUtils() async {
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

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    // showSnackBar(context: context, content: e.toString());
  }
  return video;
}

 Future<void> callsetting(
  BuildContext context,List tokensList,
  bool calltype,CallModel contactModel,bool isGroupChat,dynamic usermodel,List membersUid ) async {
    CallMethods().storeCallInfo(
        contactModel.receiverId,
       contactModel.receiverName,
      contactModel.receiverPic,
        calltype,
        isGroupChat,
membersUid
        );

    // setState(() {
      appValueNotifier.globalisCallOnGoing.value = true;
    // });
    if (isGroupChat) {
      CHANNEL_NAME =contactModel.receiverId;
    } else {
      CHANNEL_NAME =
      contactModel.receiverId + firebaseAuth.currentUser!.uid;
    }

    // var response = await get_call_token();
    // CHANNEL_NAME = response['channelname'];
    // TOKEN = response['token'];
    callValueNotifiers.setSpeakerValue(!calltype);
    callValueNotifiers.setIsVideoOn(!calltype);
    VIDEO_OR_AUDIO_FLG = calltype;
    // CALLERDATA = user;
    // new UserModel().pickcall;
    var msg = {
      'token': {'token': TOKEN, 'channelname': CHANNEL_NAME},
      'call_type':
          VIDEO_OR_AUDIO_FLG == false ? "video_channel" : "call_channel",
      'user_info': isGroupChat ? null : userInfo,
      'groupCall': isGroupChat,
      'uid': userInfo.uid,
    };
    print(msg);

    // await firebaseFirestore
    //     .collection('users')
    //     .doc(userInfo.uid)
    //     .update({'pickcall': false, 'rejectcall': false});
    // clickbtn = true;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DialScreen()));
    //starting the call using the call kit
    //starting a call
    SharedPrefrenceUser.setCallerName(CALLERDATA['name']);

    CallKitParams params = CallKitParams(
      id: const Uuid().v4(),
      nameCaller: CALLERDATA != null
          ? CALLERDATA['name'] ?? "Nothing to show"
          : "Nothing to show",
      handle: '',
      type: VIDEO_OR_AUDIO_FLG == false ? 1 : 0,
      extra: <String, dynamic>{},
      android: const AndroidParams(
          isCustomNotification: true,
          isCustomSmallExNotification: true,
          isShowLogo: true,
          isShowCallback: false,
          isShowMissedCallNotification: true,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#091C40',
          // backgroundUrl: 'https://i.pravatar.cc/500',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"),
      ios: IOSParams(
        // iconName: 'Your Team',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.startCall(params);
    if (!isGroupChat) {
      sendFcmCall(msg, usermodel!.token,isGroupChat,contactModel);
    } else {
      for (var element in tokensList) {
        sendFcmCall(msg, element,isGroupChat,contactModel);
      }
    }
  }

  void sendFcmCall(msg, String token,bool isGroupChat,CallModel contactModel) async {
    await send_fcm_call(
        token: token,
        name: isGroupChat
            ? contactModel.receiverName
            : userInfo == null
                ? ""
                : userInfo.username,
        title: "Call",
        msg: msg,
        btnstatus:
            VIDEO_OR_AUDIO_FLG == false ? "video_channel" : "call_channel");
  }