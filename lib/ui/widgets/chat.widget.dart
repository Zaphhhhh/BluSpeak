import 'package:bluspeak/ui/widgets/send_message_bar.widget.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 800,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFF050919),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomLeft,
              child: SendMessageBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
