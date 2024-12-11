class ServiceTicket {
  final int id;
  final int technicalId;
  final int serviceCallId;
  final String title;
  final DateTime? diagnosisDate;
  final String? diagnosisDetail;
  final DateTime? solutionDate;
  final String? solutionDetail;
  final String customerName;
  final int status;
  final int totalCost;
  final String? meta;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String,dynamic> serviceCallDetail;

  
  ServiceTicket({
    required this.id,
    required this.technicalId,
    required this.serviceCallId,
    required this.title,
    this.diagnosisDate,
    this.diagnosisDetail,
    this.solutionDate,
    this.solutionDetail,
    required this.customerName,
    required this.status,
    required this.totalCost,
    this.meta,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceCallDetail
  });

  factory ServiceTicket.fromJson(Map<String, dynamic> json) {
    return ServiceTicket(
      id: json['id'],
      technicalId: json['technical_id'],
      serviceCallId: json['service_call_id'],
      title: json['title'],
      diagnosisDate: json['diagnosis_date'] != null ? DateTime.tryParse(json['diagnosis_date']) : null,
      diagnosisDetail: json['diagnosis_detail'],
      solutionDate: json['solution_date'] != null ? DateTime.tryParse(json['solution_date']) : null,
      solutionDetail: json['solution_detail'],
      customerName: json['customer_name'],
      status: json['status'],
      totalCost: json['total_cost'],
      meta: json['meta'],
      serviceCallDetail: json['service_call'] as Map<String, dynamic>,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
