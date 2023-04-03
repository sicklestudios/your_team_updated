class Group {
  final String lastMessageBy;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final List<String> isSeen;
  final DateTime timeSent;
  Group({
    required this.lastMessageBy,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.isSeen,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'lastMessageBy': lastMessageBy,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'isSeen': isSeen,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      lastMessageBy: map['lastMessageBy'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      isSeen: List<String>.from(map['isSeen']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
