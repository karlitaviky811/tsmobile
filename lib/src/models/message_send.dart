class MessageSend {
  final int commentableId;
  final String commentableType;
  final String comment;

  MessageSend({
    required this.commentableId,
    required this.commentableType,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentable_id': commentableId,
      'commentable_type': commentableType,
      'comment': comment,
    };
  }
}
