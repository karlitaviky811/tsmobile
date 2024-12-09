import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/providers/message_provider.dart';
import 'package:tsmobile/src/providers/messages_model.dart';

class ChatScreen extends StatelessWidget {
  static const String route = 'chat-client-ticket-route';

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F5FD),
        title: Text('Chat', style: AppStyle.txtPoppinsRegular18Black),
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, child) {
          void _sendMessage() async {
            if (_controller.text.isNotEmpty) {
              final message = Message(
                id: 0, // Placeholder ID, will be set by the backend
                commentableType: "App\\Models\\Ticket",
                commentableId: 81, // Example ID
                commentatorType: "App\\Models\\Technical",
                commentatorId: 17, // Example ID
                comment: _controller.text,
                deletedAt: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              await messageProvider.addMessage(message);
              _controller.clear();
            }
          }

          return FutureBuilder<void>(
            future: messageProvider.loadMessages("Ticket", 81), // Pasa los parámetros adecuados
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar los mensajes: ${snapshot.error}'));
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messageProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = messageProvider.messages[index];
                          final timeString = DateFormat('HH:mm').format(message.createdAt);
                          final isOwnMessage = message.commentatorType == "App\\Models\\Technical"; // Ajusta según corresponda

                          return Align(
                            alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: isOwnMessage ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.comment,
                                    style: TextStyle(color: isOwnMessage ? Colors.white : Colors.black),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    timeString,
                                    style: TextStyle(color: isOwnMessage ? Colors.white70 : Colors.black54, fontSize: 10),
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
              }
            },
          );
        },
      ),
    );
  }
}
