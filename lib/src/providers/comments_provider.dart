import 'package:flutter/material.dart';
import 'package:tsmobile/src/services/comment_service.dart';

class CommentProvider with ChangeNotifier {
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  Future<void> loadComments() async {
    _comments = await _commentService.fetchComments();
    notifyListeners();
  }

  Future<void> addComment(Comment comment) async {
    await _commentService.sendComment(comment);
    _comments.add(comment);
    notifyListeners();
  }
}
