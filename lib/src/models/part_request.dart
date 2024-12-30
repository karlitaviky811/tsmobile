import 'dart:ffi';

class Repuesto {
  final int id;
  final int status;
  final int technicalVisitId;
  final String? name;
  final String observation;
  final DateTime? dateHanded;
  final List<String>? meta;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? budgetAmount;

  Repuesto({
    required this.id,
    required this.status,
    required this.technicalVisitId,
    this.name,
    required this.observation,
    this.dateHanded,
    this.meta,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.budgetAmount,
  });

  factory Repuesto.fromJson(Map<String, dynamic> json) {
    return Repuesto(
      id: json['id'],
      status: json['status'] ?? 1,
      technicalVisitId: json['technical_visit_id'] ?? '',
      name: json['name'] ?? '',
      observation: json['observation'] != null ? json['observation'] : 'Sin nombre de repuesto',
      dateHanded: json['date_handed'] != null ? DateTime.parse(json['date_handed']) : null,
      meta: json['meta'] != null ? (json['meta'] as Map<String, dynamic>).values.map((e) => e.toString()).toList() : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      budgetAmount: json['budget_amount'] != null ? (json['budget_amount'] as num).toDouble() : null,
    );
  }
}