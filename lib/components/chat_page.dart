import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/my_textfield.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });
// text controller
  final TextEditingController _messageController = TextEditingController();

//chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

//send message
  void sendMessage() async {
    //if there is something inside thr textfield
    if (_messageController.text.isNotEmpty) {
      //send  the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(
            child: _buildMessagesList(),
          ),
          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  //build the message
  Widget _buildMessagesList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        //Error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }
//return list view
        return ListView(
          children: (snapshot.data!)
              .docs
              .map((doc) => _buildMessagesItem(doc))
              .toList(),
        );
      },
    );
  }

  //build the message item
  Widget _buildMessagesItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data["message"]);
  }

  // build message input
  Widget _buildUserInput() {
    return Row(
      children: [
        //textfield should take up most of the space
        Expanded(
          child: MyTextfield(
            controller: _messageController,
            hintText: "Type a message",
            obscureText: false,
          ),
        ),
        //send button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
        )
      ],
    );
  }
}
