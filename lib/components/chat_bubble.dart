import 'package:chitchat/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({super.key,required this.message ,required this.isCurrentUser,});

  @override
  Widget build(BuildContext context) {
    //light vx dark code bubbles colors
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCurrentUser ?
         (isDarkMode ? const Color.fromARGB(255, 106, 78, 170) : const Color.fromARGB(255, 175, 151, 230)):
         (isDarkMode ?Colors.grey.shade800 : Colors.grey.shade500),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
      child: Text(
        message,
        style: TextStyle(color: isCurrentUser ?
        Colors.white :
        (isDarkMode ? Colors.white: Colors.black)),),
    );
  }
}