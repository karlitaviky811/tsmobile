import 'package:flutter/material.dart';
import 'package:tsmobile/src/providers/messages_model.dart';
import 'package:tsmobile/src/services/messages_service.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  Future<void> loadMessages(String commentableType, int commentableId) async {
    try {
      _messages = await _messageService.fetchMessages(commentableType, commentableId);
      print('Mensajes cargados: $_messages'); // Añadir log para verificar mensajes cargados
      notifyListeners();
    } catch (e) {
      print('Error al cargar los mensajes: $e');
      throw Exception('Error al cargar los mensajes: $e');
    }
  }

  Future<void> addMessage(Message message) async {
    try {
      await _messageService.sendMessage(message);
      _messages.add(message);
      notifyListeners();
    } catch (e) {
      print('Error al agregar el mensaje: $e');
      throw Exception('Error al agregar el mensaje: $e');
    }
  }
}
