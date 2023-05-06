// import 'dart:developer';

// import 'package:yourteam/constants/constants.dart';
// import 'package:yourteam/models/file_link_docs_model.dart';

// class InfoStorage {
//   storeLink(DateTime dateTime, String url, String receiverId,
//       bool isGroupChat) async {
//     await firebaseFirestore
//         .collection("users")
//         .doc(receiverId)
//         .collection('links')
//         .doc()
//         .set(LinkModel(
//                 fileUrl: url, timeSent: dateTime, isGroupChat: isGroupChat)
//             .toMap());
//   }

//   Future<List<LinkModel>> getLink() async {
//     List<LinkModel> contactUsers = [];

//     return firebaseFirestore
//         .collection('users')
//         .doc(firebaseAuth.currentUser!.uid)
//         .collection('links')
//         .orderBy('timeSent', descending: true)
//         .get()
//         .then((event) {
//       for (var document in event.docs) {
//         var userInfo = LinkModel.fromMap(document.data());
//         contactUsers.add(userInfo);
//       }
//       return contactUsers;
//     });
//   }

//   storeMedia(DateTime dateTime, String url, String receiverId, String senderId,
//       bool isGroupChat) async {
//     await firebaseFirestore
//         .collection("users")
//         .doc(receiverId)
//         .collection('media')
//         .doc()
//         .set(MediaModel(
//                 senderId: senderId,
//                 photoUrl: url,
//                 timeSent: dateTime,
//                 isGroupChat: isGroupChat)
//             .toMap());
//   }

//   Future<List<MediaModel>> getMedia(String? id) async {
//     List<MediaModel> contactUsers = [];
//     if (id != null && id != firebaseAuth.currentUser!.uid) {
//       await firebaseFirestore
//           .collection('users')
//           .doc(id)
//           .collection('media')
//           .where("senderId", isEqualTo: firebaseAuth.currentUser!.uid)
//           .get()
//           .then((event) {
//         for (var document in event.docs) {
//           log("inOther");
//           var userInfo = MediaModel.fromMap(document.data());
//           contactUsers.add(userInfo);
//         }
//         // return contactUsers;
//       });
//       return firebaseFirestore
//           .collection('users')
//           .doc(firebaseAuth.currentUser!.uid)
//           // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
//           .collection('media')
//           .where("senderId", isEqualTo: id)
//           .get()
//           .then((event) {
//         for (var document in event.docs) {
//           var userInfo = MediaModel.fromMap(document.data());

//           contactUsers.add(userInfo);
//         }
//         return contactUsers;
//       });
//     } else {
//       return firebaseFirestore
//           .collection('users')
//           .doc(firebaseAuth.currentUser!.uid)
//           // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
//           .collection('media')
//           // .where("senderId", isEqualTo: id)
//           .get()
//           .then((event) {
//         for (var document in event.docs) {
//           log('Error');
//           try {
//             var userInfo = MediaModel.fromMap(document.data());
//             log(userInfo.senderId);
//             contactUsers.add(userInfo);
//           } catch (e) {
//             log('Error' + e.toString());
//           }
//         }
//         return contactUsers;
//       });
//     }
//   }

//   storeFile(DateTime dateTime, String url, String name, String receiverId,
//       String senderId, bool isGroupChat) async {
//     await firebaseFirestore
//         .collection("users")
//         .doc(receiverId)
//         .collection('docs')
//         .doc()
//         .set(DocsModel(
//                 senderId: senderId,
//                 fileName: name,
//                 fileUrl: url,
//                 timeSent: dateTime,
//                 isGroupChat: isGroupChat)
//             .toMap());
//   }

//   Future<List<DocsModel>> getFile() async {
//     List<DocsModel> contactUsers = [];
//     return firebaseFirestore
//         .collection('users')
//         .doc(firebaseAuth.currentUser!.uid)
//         .collection('docs')
//         .get()
//         .then((event) {
//       for (var document in event.docs) {
//         var userInfo = DocsModel.fromMap(document.data());
//         contactUsers.add(userInfo);
//       }
//       return contactUsers;
//     });
//   }
// }

import 'dart:developer';

import 'package:yourteam/constants/constants.dart';
import 'package:yourteam/models/file_link_docs_model.dart';

class InfoStorage {
  storeLink(DateTime dateTime, String url, String receiverId,
      bool isGroupChat) async {
    await firebaseFirestore
        .collection("users")
        .doc(receiverId)
        .collection('links')
        .doc()
        .set(LinkModel(
                fileUrl: url, timeSent: dateTime, isGroupChat: isGroupChat)
            .toMap());
  }

  Future<List<LinkModel>> getLink() async {
    List<LinkModel> contactUsers = [];

    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('links')
        .orderBy('timeSent', descending: true)
        .get()
        .then((event) {
      for (var document in event.docs) {
        var userInfo = LinkModel.fromMap(document.data());
        contactUsers.add(userInfo);
      }
      return contactUsers;
    });
  }

  storeMedia(DateTime dateTime, String url, String receiverId, String senderId,
      bool isGroupChat) async {
    await firebaseFirestore
        .collection("users")
        .doc(receiverId)
        .collection('media')
        .doc()
        .set(MediaModel(
                senderId: senderId,
                photoUrl: url,
                timeSent: dateTime,
                isGroupChat: isGroupChat)
            .toMap());
  }

  Future<List<MediaModel>> getMedia(String? id, bool isGroupChat) async {
    List<MediaModel> contactUsers = [];
    if (id != null && id != firebaseAuth.currentUser!.uid) {
      await firebaseFirestore
          .collection('users')
          .doc(id)
          .collection('media')
          .where("senderId", isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((event) {
        for (var document in event.docs) {
          log("inOther");
          var userInfo = MediaModel.fromMap(document.data());
          if (isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (temp) {
              contactUsers.add(userInfo);
            }
          } else if (!isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (!temp) {
              contactUsers.add(userInfo);
            }
          } else {
            contactUsers.add(userInfo);
          }
        }
        // return contactUsers;
      });
      return firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
          .collection('media')
          .where("senderId", isEqualTo: id)
          .get()
          .then((event) {
        for (var document in event.docs) {
          var userInfo = MediaModel.fromMap(document.data());
          // if (isGroupChat) {
          //   if (userInfo.isGroupChat != null) {
          //     if (userInfo.isGroupChat!) {
          //       contactUsers.add(userInfo);
          //     }
          //   }
          // } else {
          //   contactUsers.add(userInfo);
          // }
          if (isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (temp) {
              contactUsers.add(userInfo);
            }
          } else if (!isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (!temp) {
              contactUsers.add(userInfo);
            }
          } else {
            contactUsers.add(userInfo);
          }
        }
        return contactUsers;
      });
    } else {
      return firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
          .collection('media')
          // .where("senderId", isEqualTo: id)
          .get()
          .then((event) {
        for (var document in event.docs) {
          var userInfo = MediaModel.fromMap(document.data());
          try {
            log('Fetching media');

            contactUsers.add(userInfo);
          } catch (e) {
            log('Error' + e.toString());
          }
        }
        return contactUsers;
      });
    }
  }

  storeFile(DateTime dateTime, String url, String name, String receiverId,
      String senderId, bool isGroupChat) async {
    await firebaseFirestore
        .collection("users")
        .doc(receiverId)
        .collection('docs')
        .doc()
        .set(DocsModel(
                senderId: senderId,
                fileName: name,
                fileUrl: url,
                timeSent: dateTime,
                isGroupChat: isGroupChat)
            .toMap());
  }

  Future<List<DocsModel>> getFile(String? id, bool isGroupChat) async {
    List<DocsModel> contactUsers = [];
    if (id != null && id != firebaseAuth.currentUser!.uid) {
      await firebaseFirestore
          .collection('users')
          .doc(id)
          .collection('docs')
          .where("senderId", isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((event) {
        for (var document in event.docs) {
          var userInfo = DocsModel.fromMap(document.data());
          if (isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (temp) {
              contactUsers.add(userInfo);
            }
          } else if (!isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (!temp) {
              contactUsers.add(userInfo);
            }
          } else {
            contactUsers.add(userInfo);
          }
        }
        // return contactUsers;
      });
      return firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
          .collection('docs')
          .where("senderId", isEqualTo: id)
          .get()
          .then((event) {
        for (var document in event.docs) {
          var userInfo = DocsModel.fromMap(document.data());
          // if (isGroupChat) {
          //   if (userInfo.isGroupChat != null) {
          //     if (userInfo.isGroupChat!) {
          //       contactUsers.add(userInfo);
          //     }
          //   }
          // } else {
          //   contactUsers.add(userInfo);
          // }
          if (isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (temp) {
              contactUsers.add(userInfo);
            }
          } else if (!isGroupChat) {
            bool temp = userInfo.isGroupChat ?? false;
            if (!temp) {
              contactUsers.add(userInfo);
            }
          } else {
            contactUsers.add(userInfo);
          }
        }
        return contactUsers;
      });
    } else {
      return firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
          .collection('docs')
          // .where("senderId", isEqualTo: id)
          .get()
          .then((event) {
        for (var document in event.docs) {
          var userInfo = DocsModel.fromMap(document.data());
          try {
            log('Fetching media');

            contactUsers.add(userInfo);
          } catch (e) {
            log('Error' + e.toString());
          }
        }
        return contactUsers;
      });
    }
  }
}

// Future<List<DocsModel>> getFileGroup(String groupId) async {
//   List<DocsModel> contactUsers = [];
//   return await firebaseFirestore
//       .collection('groups')
//       .doc(groupId)
//       .collection("media")
//       .get()
//       .then((value) {
//     for (var document in value.docs) {
//       var userInfo = DocsModel.fromMap(document.data());
//       contactUsers.add(userInfo);
//     }
//     return contactUsers;
//   });
//   // if (id != null && id != firebaseAuth.currentUser!.uid) {
//   //   await firebaseFirestore
//   //       .collection('users')
//   //       .doc(id)
//   //       .collection('docs')
//   //       .where("senderId", isEqualTo: firebaseAuth.currentUser!.uid)
//   //       .get()
//   //       .then((event) {
//   //     for (var document in event.docs) {
//   //       var userInfo = DocsModel.fromMap(document.data());
//   //       if (isGroupChat) {
//   //         bool temp = userInfo.isGroupChat ?? false;
//   //         if (temp) {
//   //           contactUsers.add(userInfo);
//   //         }
//   //       } else if (!isGroupChat) {
//   //         bool temp = userInfo.isGroupChat ?? false;
//   //         if (!temp) {
//   //           contactUsers.add(userInfo);
//   //         }
//   //       } else {
//   //         contactUsers.add(userInfo);
//   //       }
//   //     }
//   //     // return contactUsers;
//   //   });
//   //   return firebaseFirestore
//   //       .collection('users')
//   //       .doc(firebaseAuth.currentUser!.uid)
//   //       // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
//   //       .collection('docs')
//   //       .where("senderId", isEqualTo: id)
//   //       .get()
//   //       .then((event) {
//   //     for (var document in event.docs) {
//   //       var userInfo = DocsModel.fromMap(document.data());
//   //       // if (isGroupChat) {
//   //       //   if (userInfo.isGroupChat != null) {
//   //       //     if (userInfo.isGroupChat!) {
//   //       //       contactUsers.add(userInfo);
//   //       //     }
//   //       //   }
//   //       // } else {
//   //       //   contactUsers.add(userInfo);
//   //       // }
//   //       if (isGroupChat) {
//   //         bool temp = userInfo.isGroupChat ?? false;
//   //         if (temp) {
//   //           contactUsers.add(userInfo);
//   //         }
//   //       } else if (!isGroupChat) {
//   //         bool temp = userInfo.isGroupChat ?? false;
//   //         if (!temp) {
//   //           contactUsers.add(userInfo);
//   //         }
//   //       } else {
//   //         contactUsers.add(userInfo);
//   //       }
//   //     }
//   //     return contactUsers;
//   //   });
//   // } else {
//   //   return firebaseFirestore
//   //       .collection('users')
//   //       .doc(firebaseAuth.currentUser!.uid)
//   //       // .doc("LTKgBuRItJT2cIHuFx77yu0Zsqo2")
//   //       .collection('docs')
//   //       // .where("senderId", isEqualTo: id)
//   //       .get()
//   //       .then((event) {
//   //     for (var document in event.docs) {
//   //       var userInfo = DocsModel.fromMap(document.data());
//   //       try {
//   //         log('Fetching media');

//   //         contactUsers.add(userInfo);
//   //       } catch (e) {
//   //         log('Error' + e.toString());
//   //       }
//   //     }
//   //     return contactUsers;
//   //   });
//   // }
// }

//   Future<List<DocsModel>> getFile(bool isGroupChat) async {
//     List<DocsModel> contactUsers = [];
//     return firebaseFirestore
//         .collection('users')
//         .doc(firebaseAuth.currentUser!.uid)
//         .collection('docs')
//         .get()
//         .then((event) {
//       for (var document in event.docs) {
//         var userInfo = DocsModel.fromMap(document.data());
//         if (isGroupChat) {
//           if (userInfo.isGroupChat != null) {
//             if (userInfo.isGroupChat!) {
//               contactUsers.add(userInfo);
//             }
//           }
//         } else {
//           contactUsers.add(userInfo);
//         }
//         contactUsers.add(userInfo);
//       }
//       return contactUsers;
//     });
//   }
// }

class InfoStorageGroup {
  storeLink(DateTime dateTime, String url, String receiverId) async {
    await firebaseFirestore
        .collection("groups")
        .doc(receiverId)
        .collection('links')
        .doc()
        .set(LinkModel(fileUrl: url, timeSent: dateTime).toMap());
  }

  Future<List<LinkModel>> getLink(String receiverId) async {
    List<LinkModel> contactUsers = [];

    return firebaseFirestore
        .collection("groups")
        .doc(receiverId)
        .collection('links')
        .orderBy('timeSent', descending: true)
        .get()
        .then((event) {
      for (var document in event.docs) {
        var userInfo = LinkModel.fromMap(document.data());
        contactUsers.add(userInfo);
      }
      return contactUsers;
    });
  }

  storeMedia(
      DateTime dateTime, String url, String receiverId, String senderId) async {
    await firebaseFirestore
        .collection("groups")
        .doc(receiverId)
        .collection('media')
        .doc()
        .set(MediaModel(senderId: senderId, photoUrl: url, timeSent: dateTime)
            .toMap());
  }

  Future<List<MediaModel>> getMedia(String groupId) async {
    List<MediaModel> contactUsers = [];
    return firebaseFirestore
        .collection('groups')
        // .doc(firebaseAuth.currentUser!.uid)
        .doc(groupId)
        .collection('media')
        // .where("senderId", isEqualTo: id)
        .get()
        .then((event) {
      for (var document in event.docs) {
        var userInfo = MediaModel.fromMap(document.data());
        contactUsers.add(userInfo);
      }
      return contactUsers;
    });
  }

  storeFile(DateTime dateTime, String url, String name, String receiverId,
      String senderId) async {
    await firebaseFirestore
        .collection("groups")
        .doc(receiverId)
        .collection('docs')
        .doc()
        .set(DocsModel(
                senderId: senderId,
                fileName: name,
                fileUrl: url,
                timeSent: dateTime)
            .toMap());
  }

  Future<List<DocsModel>> getFile(String groupId) async {
    List<DocsModel> contactUsers = [];
    return firebaseFirestore
        .collection('groups')
        .doc(groupId)
        .collection('docs')
        .get()
        .then((event) {
      for (var document in event.docs) {
        var userInfo = DocsModel.fromMap(document.data());
        contactUsers.add(userInfo);
        log(document.data().toString());
      }
      return contactUsers;
    });
  }
}
