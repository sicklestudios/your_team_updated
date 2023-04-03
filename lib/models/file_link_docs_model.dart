class LinkModel {
  final String fileUrl;
  final DateTime timeSent;
  final bool? isGroupChat;

  LinkModel({
    required this.fileUrl,
    required this.timeSent,
    this.isGroupChat,
  });

  Map<String, dynamic> toMap() {
    return {
      'fileUrl': fileUrl,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isGroupChat': isGroupChat,
    };
  }

  factory LinkModel.fromMap(Map<String, dynamic> map) {
    return LinkModel(
      fileUrl: map['fileUrl'],
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isGroupChat: map['isGroupChat'],
    );
  }
}

class MediaModel {
  final String senderId;
  final String photoUrl;
  final DateTime timeSent;
  final bool? isGroupChat;

  MediaModel({
    required this.senderId,
    required this.photoUrl,
    required this.timeSent,
    this.isGroupChat,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'photoUrl': photoUrl,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isGroupChat': isGroupChat,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      senderId: map['senderId'],
      photoUrl: map['photoUrl'],
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isGroupChat: map['isGroupChat'] ?? false,
    );
  }
}

class DocsModel {
  final String senderId;
  final String fileName;
  final String fileUrl;
  final DateTime timeSent;
  final bool? isGroupChat;

  DocsModel({
    required this.senderId,
    required this.fileName,
    required this.fileUrl,
    required this.timeSent,
    this.isGroupChat,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isGroupChat': isGroupChat,
    };
  }

  factory DocsModel.fromMap(Map<String, dynamic> map) {
    return DocsModel(
      senderId: map['senderId'],
      fileName: map['fileName'],
      fileUrl: map['fileUrl'],
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      isGroupChat: map['isGroupChat'],
    );
  }
}
