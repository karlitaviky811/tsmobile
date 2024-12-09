class Item {
  final int id;
  final int technicalId;
  final int serviceCallId;
  final String title;
  final DateTime diagnosisDate;
  final String diagnosisDetail;
  final DateTime solutionDate;
  final String solutionDetail;
  final String customerName;
  final int status;
  final double totalCost;
  final DateTime createdAt; // Use DateTime instead of String
  final DateTime updatedAt; // Use DateTime instead of String
  final List<dynamic> media;

  Item({
    required this.id,
    required this.technicalId,
    required this.serviceCallId,
    required this.title,
    required this.diagnosisDate,
    required this.diagnosisDetail,
    required this.solutionDate,
    required this.solutionDetail,
    required this.customerName,
    required this.status,
    required this.totalCost,
    required this.createdAt,
    required this.updatedAt,
    required this.media,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      technicalId: json['technical_id'],
      serviceCallId: json['service_call_id'],
      title: json['title'],
      diagnosisDate: DateTime.parse(json['diagnosis_date']),
      diagnosisDetail: json['diagnosis_detail'],
      solutionDate: DateTime.parse(json['solution_date']),
      solutionDetail: json['solution_detail'],
      customerName: json['customer_name'],
      status: json['status'],
      totalCost: json['total_cost'].toDouble(),
      createdAt: DateTime.parse(json['created_at']), // Parse the string to DateTime
      updatedAt: DateTime.parse(json['updated_at']), // Parse the string to DateTime
      media: json['media'],
    );
  }
}
