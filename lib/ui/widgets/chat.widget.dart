import 'package:flutter/material.dart';
// Assurez-vous que le chemin d'importation est correct
import 'send_message_bar.widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF050919),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SendMessageBarWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
