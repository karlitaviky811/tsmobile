import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';



class ChatScreen extends StatelessWidget {
  static const String route = 'chat-client-ticket-route';
  @override
  Widget build(BuildContext context) {
    final List<Message> _messages = [];
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
             backgroundColor: Color(0xffF3F5FD),
        title: Text('Chat',style: AppStyle.txtPoppinsRegular18Black),
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void _sendMessage() {
            if (_controller.text.isNotEmpty) {
              setState(() {
                _messages.add(Message(
                  text: _controller.text,
                  time: DateTime.now(),
                ));
                _controller.clear();
              });
            }
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final timeString = DateFormat('HH:mm').format(message.time);
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.text,
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              timeString,
                              style: TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Message {
  final String text;
  final DateTime time;

  Message({required this.text, required this.time});
}
