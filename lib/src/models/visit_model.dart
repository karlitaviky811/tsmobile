class Visit {
  int id;
  String title;
  int type;
  int ticketId;
  DateTime visitDate;
  String? observations;
  List<Reprogramming> reprogramming;
  String? meta;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int? status;
  String? imageSolicitud;
  String? imagePresupuesto;
  String? imageReparacion;
    List<String> selectedServicios;
  List<String> selectedRepuestos;
  

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
    this.selectedServicios = const [],
    this.selectedRepuestos = const [],
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    var reprogrammingList = json['reprogramming'] != null && json['reprogramming']['other'] != null
        ? json['reprogramming']['other'] as List<dynamic>
        : [];
    return Visit(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      ticketId: json['ticket_id'],
      visitDate: DateTime.parse(json['visit_date']),
      observations: json['observations'],
      reprogramming: reprogrammingList
          .map((item) => Reprogramming.fromJson(item))
          .toList(),
      meta: json['meta'],
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'],
      imageSolicitud: json['image_solicitud'],
      imagePresupuesto: json['image_presupuesto'],
      imageReparacion: json['image_reparacion'],
    );
  }
}

class Reprogramming {
  final String reason;
  final String newDate;
  final String extendReason;
  final String oldDate;

  Reprogramming({
    required this.reason,
    required this.newDate,
    required this.extendReason,
    required this.oldDate,
  });

  factory Reprogramming.fromJson(Map<String, dynamic> json) {
    return Reprogramming(
      reason: json['reason'],
      newDate: json['new_date'],
      extendReason: json['extend_reason'],
      oldDate: json['old_date'],
    );
  }
}

