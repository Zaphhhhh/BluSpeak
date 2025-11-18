import 'package:flutter/material.dart';

class SendMessageBarWidget extends StatelessWidget {
  const SendMessageBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0x101633FF),
      ),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 15),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.blue,
            elevation: 0,
            child: const Icon(Icons.send, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}
