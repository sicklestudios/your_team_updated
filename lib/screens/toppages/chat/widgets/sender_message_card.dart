import 'package:flutter/material.dart';
import 'package:yourteam/constants/colors.dart';
import 'package:yourteam/constants/message_enum.dart';
import 'package:yourteam/screens/toppages/chat/widgets/display_text_image_file.dart';

class SenderMessageCard extends StatelessWidget {
  final String photoUrl;
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback longPress;
  final bool? isSelected;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isGroupChat;
  final Widget avatarWidget;
  const SenderMessageCard(
      {required this.photoUrl,
      required this.message,
      required this.date,
      required this.type,
      required this.longPress,
      required this.repliedText,
      required this.username,
      this.isSelected,
      required this.repliedMessageType,
      required this.isGroupChat,
      required this.avatarWidget,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          // width: MediaQuery.of(context).size.width / 1.25,
          // // constraints: BoxConstraints(
          // //     minWidth: 5,
          // //     maxWidth: type != MessageEnum.audio
          // //         ? MediaQuery.of(context).size.width / 1.25
          // //         : MediaQuery.of(context).size.width / 1.25),
          constraints: BoxConstraints(
              minWidth: 5,
              maxWidth: type != MessageEnum.audio
                  ? MediaQuery.of(context).size.width / 1.25
                  : MediaQuery.of(context).size.width / 1.25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (isSelected != null)
                if (isSelected!) const Icon(Icons.check_box),
              if (isSelected == null) avatarWidget,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        date == "null" ? "" : date,
                        style: const TextStyle(
                            fontSize: 13, color: Color.fromARGB(124, 0, 0, 0)),
                      ),
                    ),
                    Card(
                      elevation: 3,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )),
                      color: senderChatCardColor,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          if(isGroupChat)
                          Padding(
                            padding: const EdgeInsets.only(top:8.0,left:15,right: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(username,textAlign: TextAlign.start,overflow: TextOverflow.clip,style: const TextStyle(fontWeight: FontWeight.bold,color: mainColor),),
                              ],
                            ),
                          )
                          ,Padding(
                              // padding: const EdgeInsets.only(
                              //     left: 10, right: 30, top: 5, bottom: 5),
                              padding: const EdgeInsets.all(15),
                              child: DisplayTextImageGIF(
                                  photoUrl: photoUrl,
                                  date: date,
                                  message: message,
                                  type: type,
                                  isSender: false)),
                        ],
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
}
