class Message {
  Message({
    required this.formId,
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.sent,
  });
  late final String formId;
  late final String msg;
  late final String read;
  late final String told;
  late final Type type;
  late final String sent;

  Message.fromJson(Map<String, dynamic> json) {
    formId = json['formId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
  }
  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'msg': msg,
      'read': read,
      'told': told,
      'type': type.toString().split('.').last, // Convert enum to string
      'sent': sent,
    };
  }
}

enum Type { text, image }
