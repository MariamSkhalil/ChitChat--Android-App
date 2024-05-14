
import 'package:chitchat/components/chat_bubble.dart';
import 'package:chitchat/components/my_textfield.dart';
import 'package:chitchat/services/auth/auth_service.dart';
import 'package:chitchat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth services
  final AuthService _auth = AuthService();
  final ChatService _chatService = ChatService();

  //for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState(){
    super.initState();

    //add listener to the focus node
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        //cause a delay so the keyboard has time to show up
        //then the amount of remaining space will be calculated
        //then scroll down
        Future.delayed(
          const Duration(milliseconds: 500),
          ()=>scrollDown(),
          );
      }
    });
    //wait a bit for the listview to be built, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      ()=>scrollDown(),
    );


  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn
    );
  }

  //send message
  void sendMessage() async {
    //if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      //send the message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      //clear the text controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,      ),
      body: Column(
        children: [
          //display all the messages
          Expanded(child: _buildMessageList()),

          //display the users input
          _buildUserInput()
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _auth.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(senderID, widget.receiverID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        //return list view
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderID'] == _auth.getCurrentUser()!.uid;

    //align to the right if the sender is the current user, else left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

 
    return Container(
      alignment: alignment,
      child:
       Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end: CrossAxisAlignment.start,
         children: [
           ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
         ],
       )
      );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom:40.0),
      child: Row(
      children: [
        //textfield should take up most of the space
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: "Type a message",
            obscureText: false,
            focusNode: myFocusNode,
          ),
        ),
        //send button
        Container(
          margin: const EdgeInsets.only(right: 25),
          child: IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_circle_up, size: 40),
          ),
        ),
      ],
     ),
    );
  }
}
