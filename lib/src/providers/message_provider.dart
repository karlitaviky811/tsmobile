import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/message_send_model.dart';
import 'package:tsmobile/src/models/messages_model.dart';
import 'package:tsmobile/src/services/messages_service.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  Future<void> loadMessages(String commentableType, int commentableId) async {
    print('Iniciando carga de mensajes...'); // Log para iniciar la carga
    try {
      _messages = await _messageService.fetchMessages(commentableType, commentableId);
      print('Mensajes cargados: $_messages'); // Log para verificar mensajes cargados
      notifyListeners();
      print('Carga de mensajes completa'); // Log para confirmar finalización
    } catch (e) {
      print('Error al cargar los mensajes: $e');
      throw Exception('Error al cargar los mensajes: $e');
    }
  }

 Future<void> addMessage(Message messageSend) async {
    print('Añadiendo mensaje: ${messageSend.comment}'); // Accede al valor usando el objeto
    try {
      // Simulación de una llamada a un servicio remoto
       await _messageService.sendMessage(MessageSend(commentableId: messageSend.commentableId, commentableType: messageSend.commentableType, comment: messageSend.comment));
   
      _messages.add(messageSend);
      notifyListeners();

      // Guardar mensaje en SharedPreferences (si es necesario)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> messagesString = _messages.map((msg) => msg.comment).toList();
      prefs.setStringList('messages', messagesString);
    } catch (e) {
      print('Error añadiendo el mensaje: $e');
      notifyListeners();
    }
  }

}


