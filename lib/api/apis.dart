import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glitz/chat/model/message.dart';
import 'package:glitz/models/chat_user.dart';

class APIs {
  //?for Authenticatio
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static get user => auth.currentUser!;

  //?for checking  if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection('Rashi')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static late ChatUser me;

  static Future<void> getSelfInfo() async {
    await firestore.collection('Rashi').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey I'm using Glitz!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );
    return await firestore
        .collection('Rashi')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("Rashi")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //Updete user info
  static Future<void> updateUserInfo() async {
    await firestore
        .collection("Rashi")
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  //*update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extention: $ext');
    //? Folder crete in firebase storage
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    //? uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((po) {
      log('Data Transferred: ${po.bytesTransferred / 1000}kb');
    });
    //?updating image firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection("Rashi").doc(user.uid).update({
      'image': me.image,
    });
  }

  //* useful for getting conversatin id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //* get all messages in firestore database(db)
  //? messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection("chats/${getConversationID(user.id)}/messages/")
        .snapshots();
  }
  //? chats (collection) -->conversations_id (doc)--> messages (collection)--> message (doc)

  //* for sending message
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    //?message sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //?message to sent(also used as id)
    final Message message = Message(
        formId: user.uid,
        msg: msg,
        read: '',
        told: chatUser.id,
        type: Type.text,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //*update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.formId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
}