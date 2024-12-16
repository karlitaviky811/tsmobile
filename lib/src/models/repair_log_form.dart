class RepairLog {
  final String titulo;
  final String estado;
  final DateTime selectedDate;
  final List<String> selectedServicios;
  final bool necesitaRepuesto;
  final List<String> selectedRepuestos;
  final String presupuestoRepuesto;
  final String comentarios;
  final String imagenSolicitud;
  final String imagenPresupuesto;
  final String imagenReparacion;
  final String comentariosGenerales;
  final bool presupuestoAceptado;
  final String nombreRepuesto;
  final String precioRepuesto;
  final bool repuestoSolicitado;
  final String estadoCompraRepuesto;

  RepairLog({
    required this.titulo,
    required this.estado,
    required this.selectedDate,
    required this.selectedServicios,
    required this.necesitaRepuesto,
    required this.selectedRepuestos,
    required this.presupuestoRepuesto,
    required this.comentarios,
    required this.imagenSolicitud,
    required this.imagenPresupuesto,
    required this.imagenReparacion,
    required this.comentariosGenerales,
    required this.presupuestoAceptado,
    required this.nombreRepuesto,
    required this.precioRepuesto,
    required this.repuestoSolicitado,
    required this.estadoCompraRepuesto,
  });

  factory RepairLog.fromJson(Map<String, dynamic> json) {
    return RepairLog(
      titulo: json['titulo'] ?? 'Cambio de Pantalla',
      estado: json['estado'] ?? 'Solicitud de Repuesto',
      selectedDate: DateTime.parse(json['selectedDate']),
      selectedServicios: List<String>.from(json['selectedServicios'] ?? []),
      necesitaRepuesto: json['necesitaRepuesto'] ?? false,
      selectedRepuestos: List<String>.from(json['selectedRepuestos'] ?? []),
      presupuestoRepuesto: json['presupuestoRepuesto'] ?? '',
      comentarios: json['comentarios'] ?? '',
      imagenSolicitud: json['imagenSolicitud'] ?? '',
      imagenPresupuesto: json['imagenPresupuesto'] ?? '',
      imagenReparacion: json['imagenReparacion'] ?? '',
      comentariosGenerales: json['comentariosGenerales'] ?? '',
      presupuestoAceptado: json['presupuestoAceptado'] ?? false,
      nombreRepuesto: json['nombreRepuesto'] ?? '',
      precioRepuesto: json['precioRepuesto'] ?? '',
      repuestoSolicitado: json['repuestoSolicitado'] ?? false,
      estadoCompraRepuesto: json['estadoCompraRepuesto'] ?? 'Enviada',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'estado': estado,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedServicios': selectedServicios,
      'necesitaRepuesto': necesitaRepuesto,
      'selectedRepuestos': selectedRepuestos,
      'presupuestoRepuesto': presupuestoRepuesto,
      'comentarios': comentarios,
      'imagenSolicitud': imagenSolicitud,
      'imagenPresupuesto': imagenPresupuesto,
      'imagenReparacion': imagenReparacion,
      'comentariosGenerales': comentariosGenerales,
      'presupuestoAceptado': presupuestoAceptado,
      'nombreRepuesto': nombreRepuesto,
      'precioRepuesto': precioRepuesto,
      'repuestoSolicitado': repuestoSolicitado,
      'estadoCompraRepuesto': estadoCompraRepuesto,
    };
  }
}
