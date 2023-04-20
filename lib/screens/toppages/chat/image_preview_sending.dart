import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yourteam/constants/constant_utils.dart';
import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/constants/message_enum.dart';
import 'package:yourteam/methods/chat_methods.dart';

class ImagePreviewSending extends StatefulWidget {
  final File imagePath;
  final bool isGroupChat;
  final String contactId;
  const ImagePreviewSending(
      {required this.isGroupChat,
      required this.contactId,
      required this.imagePath,
      super.key});

  @override
  State<ImagePreviewSending> createState() => _ImagePreviewSendingState();
}

class _ImagePreviewSendingState extends State<ImagePreviewSending> {
  void sendFileMessage() {
    ChatMethods().sendFileMessage(
        context: context,
        file: widget.imagePath,
        recieverUserId: widget.contactId,
        messageEnum: MessageEnum.image,
        senderUserData: userInfo,
        messageReply: null,
        isGroupChat: widget.isGroupChat);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          actions: [
            TextButton(
                onPressed: () {
                  showToastMessage("Sending Image");
                  sendFileMessage();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                ))
            // InkWell(
            //   onTap: () {
            //     showToastMessage("Sending Image");
            //     sendFileMessage();
            //     Navigator.pop(context);
            //   },
            //  ,
            // ),
          ],
        ),
        body: Center(
          child: Image.file(
              fit: BoxFit.fitWidth, width: size.width, widget.imagePath),
        ));
  }
}
