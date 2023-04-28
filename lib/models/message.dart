class Message {
  late final String msg;
  late final String toID;
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromID;

  Message({
    required this.msg,
    required this.toID,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromID,
  });

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toID = json['toID'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromID = json['fromID'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['toID'] = this.toID;
    data['read'] = this.read;
    data['type'] = this.type.name;
    data['sent'] = this.sent;
    data['fromID'] = this.fromID;
    return data;
  }
}

enum Type { text, image }
