import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimal_chat_app/model/messages.dart';

class ChatService {
//get instance of firestore and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// get user stream
  Stream<List<Map<String, dynamic>>> getUSersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
// go through each individual user
        final user = doc.data();
//return user
        return user;
      }).toList();
    });
  }

// send message
  Future<void> sendMessage(String receiverID, message) async {
    //Get Current user info
    final String CurrentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
      senderID: CurrentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );
    //construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [CurrentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chatroomID is the same for any 2 peoples)
    String chatroomID = ids.join('_'); // join the ids with an underscore
    //add new messages to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatroom ID for the Two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
