class ServiceTicket {
  final int id;
  final int technicalId;
  final int serviceCallId;
  final String title;
  final DateTime? diagnosisDate;
  final String? diagnosisDetail;
  final DateTime? solutionDate;
  final String? solutionDetail;
  final String? customerName;
  final int status;
  final int totalCost;
  final dynamic meta;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> serviceCallDetail;

  ServiceTicket({
    required this.id,
    required this.technicalId,
    required this.serviceCallId,
    required this.title,
    this.diagnosisDate,
    this.diagnosisDetail,
    this.solutionDate,
    this.solutionDetail,
    this.customerName,
    required this.status,
    required this.totalCost,
    this.meta,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceCallDetail,
  });

  factory ServiceTicket.fromJson(Map<String, dynamic> json) {
    return ServiceTicket(
      id: json['id'] ?? 0,
      technicalId: json['technical_id'] ?? 0,
      serviceCallId: json['service_call_id'] ?? 0,
      title: json['title'] ?? '',
      diagnosisDate: json['diagnosis_date'] != null ? DateTime.parse(json['diagnosis_date']) : null,
      diagnosisDetail: json['diagnosis_detail'],
      solutionDate: json['solution_date'] != null ? DateTime.parse(json['solution_date']) : null,
      solutionDetail: json['solution_detail'] ?? '',
      customerName: json['customer_name'],
      status: json['status'] ?? 1,
      totalCost: json['total_cost'] ?? 0,
      meta: json['meta'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      serviceCallDetail: json['service_call'] ?? {},
    );
  }

  // Método para validar campos null
  bool isValid() {
    return diagnosisDate != null &&
        diagnosisDetail != null &&
        solutionDate != null &&
        solutionDetail != null;
  }

  // Métodos para obtener detalles con valores por defecto
  String getDiagnosisDetail() {
    return diagnosisDetail ?? "No diagnosis detail provided.";
  }

  String getSolutionDetail() {
    return solutionDetail ?? "No solution detail provided.";
  }
}
