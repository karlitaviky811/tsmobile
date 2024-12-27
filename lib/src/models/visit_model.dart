import 'package:intl/intl.dart';

class Visit {
  final int id;
  String title;
  final int type;
  final int ticketId;
  DateTime visitDate;
  String? observations;
  List<Reprogramming> reprogramming;
  final String? meta;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  int status;
  String? imageSolicitud;
  String? imagePresupuesto;
  String? imageReparacion;
  bool necesitaRepuesto;
  List<String> services;
  List<String> selectedRepuestos;
  List<String> selectedServicios;

  Visit({
    required this.id,
    required this.title,
    required this.type,
    required this.ticketId,
    required this.visitDate,
    this.observations,
    required this.reprogramming,
    this.meta,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.imageSolicitud,
    this.imagePresupuesto,
    this.imageReparacion,
    required this.necesitaRepuesto,
    required this.services,
    required this.selectedRepuestos,
    required this.selectedServicios,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    var reprogrammingList = json['reprogramming'] != null &&
            json['reprogramming']['other'] != null &&
            json['reprogramming']['other'] is List
        ? json['reprogramming']['other'] as List<dynamic>
        : [];

    return Visit(
      id: json['id'],
      title: json['title'] ?? '',
      type: json['type'],
      ticketId: json['ticket_id'],
      visitDate: json['visit_date'] != null
          ? DateTime.parse(json['visit_date'])
          : DateTime.now(),
      observations: json['observations'] ?? '',
      reprogramming: reprogrammingList
          .map((item) => Reprogramming.fromJson(item))
          .toList(),
      meta: json['meta'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'] ?? 1,
      imageSolicitud: json['image_solicitud'] ?? '',
      imagePresupuesto: json['image_presupuesto'] ?? '',
      imageReparacion: json['image_reparacion'] ?? '',
      necesitaRepuesto: json['necesitaRepuesto'] ?? false,
      services: List<String>.from(json['services'] ?? []),
      selectedRepuestos: List<String>.from(json['selectedRepuestos'] ?? []),
      selectedServicios: List<String>.from(json['selectedServicios'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'ticket_id': ticketId,
      'visit_date': visitDate.toIso8601String(),
      'observations': observations,
      'reprogramming': {
        'other': reprogramming.map((item) => item.toJson()).toList(),
      },
      'meta': meta,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'image_solicitud': imageSolicitud,
      'image_presupuesto': imagePresupuesto,
      'image_reparacion': imageReparacion,
      'necesitaRepuesto': necesitaRepuesto,
      'services': services,
      'selectedRepuestos': selectedRepuestos,
      'selectedServicios': selectedServicios,
    };
  }
}

class Reprogramming {
  final String reason;
  final DateTime newDate;
  final String extendReason;
  final DateTime oldDate;

  Reprogramming({
    required this.reason,
    required this.newDate,
    required this.extendReason,
    required this.oldDate,
  });

  factory Reprogramming.fromJson(Map<String, dynamic> json) {
    return Reprogramming(
      reason: json['reason'],
      newDate: DateTime.parse(json['new_date']),
      extendReason: json['extend_reason'],
      oldDate: DateTime.parse(json['old_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'new_date': newDate.toIso8601String(),
      'extend_reason': extendReason,
      'old_date': oldDate.toIso8601String(),
    };
  }

  String formattedNewDate() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(newDate);
  }

  String formattedOldDate() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(oldDate);
  }
}
