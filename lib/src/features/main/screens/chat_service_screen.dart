



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/models/messages_model.dart';
import 'package:tsmobile/src/providers/message_provider.dart';


class ChatScreen extends StatelessWidget {
  static const String route = 'chat-client-ticket-route';

  final TextEditingController _controller = TextEditingController();
  final String ticketId;

  ChatScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              }),
        backgroundColor: const Color(0xffF3F5FD),
        title: Text('Chat', style: AppStyle.txtPoppinsRegular18Black),
      ),
      body: FutureBuilder<void>(
        future: Provider.of<MessageProvider>(context, listen: false)
            .loadMessages("Ticket", int.parse(ticketId)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar los mensajes: ${snapshot.error}'));
          } else {
            return Consumer<MessageProvider>(
              builder: (context, messageProvider, child) {
                final messages = messageProvider.messages;
                // Ordenar mensajes por fecha de creación en orden ascendente
                messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final timeString =
                              DateFormat('HH:mm').format(message.createdAt);
                          final isOwnMessage = message.commentatorType ==
                              "App\\Models\\Technical";

                          return Align(
                            alignment: isOwnMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: isOwnMessage
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: isOwnMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.comment,
                                    style: TextStyle(
                                        color: isOwnMessage
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    timeString,
                                    style: TextStyle(
                                        color: isOwnMessage
                                            ? Colors.white70
                                            : Colors.black54,
                                        fontSize: 10),
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
                              decoration: const InputDecoration(
                                hintText: 'Escribe un mensaje...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () =>
                                sendMessage(context, _controller.text),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  void sendMessage(BuildContext context, String text) async {
    if (text.isNotEmpty) {
      final messageProvider =
          Provider.of<MessageProvider>(context, listen: false);
      final messageSend = Message(
        id: 0, // Placeholder ID, will be set by the backend
        commentableType: "Ticket",
        commentableId: int.parse(ticketId),
        commentatorType: "",
        commentatorId: 17, // Example ID
        comment: text,
        deletedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await messageProvider.addMessage(messageSend);
        await messageProvider.loadMessages('Ticket', int.parse(ticketId));
        _controller.clear();
      } catch (e) {
        print('Error enviando el mensaje: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error enviando el mensaje. Por favor, inténtalo de nuevo.'),
        ));
      }
    }
  }
}
