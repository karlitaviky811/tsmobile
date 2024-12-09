class Message {
  final int id;
  final String commentableType;
  final int commentableId;
  final String commentatorType;
  final int commentatorId;
  final String comment;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.commentableType,
    required this.commentableId,
    required this.commentatorType,
    required this.commentatorId,
    required this.comment,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      commentableType: json['commentable_type'],
      commentableId: json['commentable_id'],
      commentatorType: json['commentator_type'],
      commentatorId: json['commentator_id'],
      comment: json['comment'],
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commentable_type': commentableType,
      'commentable_id': commentableId,
      'commentator_type': commentatorType,
      'commentator_id': commentatorId,
      'comment': comment,
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

