import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/chat_page.dart';
import 'package:minimal_chat_app/components/my_drawer.dart';
import 'package:minimal_chat_app/components/user_tile.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Logout method
  void logout(BuildContext context) async {
    await _authService.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     onPressed: () => logout(context),
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // Build a list of users except for the current logged-in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUSersStream(),
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return const Center(
            child: Text("An error occurred while loading users."),
          );
        }
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // No data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No users available."),
          );
        }
        // Display user list
        return ListView(
          children: (snapshot.data!)
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // Build individual list tile for a user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tapped on a user --> go to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
