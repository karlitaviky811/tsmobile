import 'package:flutter/material.dart';
import 'package:tsmobile/src/providers/messages_model.dart';
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

  Future<void> addMessage(Message message) async {
    print('Añadiendo mensaje: ${message.comment}'); // Log para iniciar la adición de mensaje
    try {
      await _messageService.sendMessage(message);
      _messages.add(message);
      print('Mensaje añadido: ${message.comment}'); // Verificación del mensaje añadido
      notifyListeners();
    } catch (e) {
      print('Error al agregar el mensaje: $e');
      throw Exception('Error al agregar el mensaje: $e');
    }
  }
}
