import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/models/messages_model.dart';
import 'package:tsmobile/src/providers/message_provider.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class ChatScreen extends StatefulWidget {
  static const String route = 'chat-client-ticket-route';
  final String ticketId;

  ChatScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  late PusherChannelsClient client;
  late StreamSubscription<ChannelReadEvent> messageSubscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connectToPusher();
    startPeriodicFetch();
  }

  @override
  void dispose() {
    messageSubscription.cancel();
    client.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      connectToPusher();
    } else if (state == AppLifecycleState.inactive ||
               state == AppLifecycleState.paused) {
      client.disconnect();
    }
  }

  void connectToPusher() async {
    PusherChannelsPackageLogger.enableLogs();

    const options = PusherChannelsOptions.fromCluster(
      host: '3.137.100.242',
      scheme: 'wss',
      cluster: 'qcxvi4ijlcw1bddsmfyq',
      key: 'vabvfgptnghqkzsbh1xz',
      port: 8080,
    );

    client = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) async {
        print("Error de conexión: $exception");
        refresh();
      },
    );

    final channel = client.publicChannel('App.Models.Ticket.${widget.ticketId}');

    messageSubscription = channel.bind('NewComment').listen((event) {
      final newMessage = Message.fromJson(event.data as Map<String, dynamic>);
      Provider.of<MessageProvider>(context, listen: false).addMessage(newMessage);
    });

    client.onConnectionEstablished.listen((_) {
      channel.subscribeIfNotUnsubscribed();
    });

    unawaited(client.connect());
  }

  void startPeriodicFetch() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      fetchMessages();
    });
  }

  Future<void> fetchMessages() async {
    try {
      await Provider.of<MessageProvider>(context, listen: false)
          .loadMessages("Ticket", int.parse(widget.ticketId));
    } catch (e) {
      print('Error al cargar los mensajes: $e');
    }
  }

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
            .loadMessages("Ticket", int.parse(widget.ticketId)),
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
        commentableId: int.parse(widget.ticketId),
        commentatorType: "",
        commentatorId: 17, // Example ID
        comment: text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await messageProvider.addMessage(messageSend);
        await messageProvider.loadMessages('Ticket', int.parse(widget.ticketId));
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
