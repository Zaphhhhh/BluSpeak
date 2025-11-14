import 'package:flutter/material.dart';

class SendMessageBarWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0x101633FF),
      ),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          SizedBox(width: 15),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write message...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 15),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.send, color: Colors.white, size: 18),
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
