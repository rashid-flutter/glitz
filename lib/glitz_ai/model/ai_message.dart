class AiMessage {
  String msg;
  MessageType msgType;
  AiMessage({required this.msg, required this.msgType});
}

enum MessageType { user, bot }
