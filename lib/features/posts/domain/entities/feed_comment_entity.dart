import 'package:equatable/equatable.dart';

class FeedCommentEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final bool isLikedByCurrentUser;

  const FeedCommentEntity({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount = 0,
    this.isLikedByCurrentUser = false,
  });

  FeedCommentEntity copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? avatarUrl,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    bool? isLikedByCurrentUser,
  }) {
    return FeedCommentEntity(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }

  @override
  List<Object?> get props => [
    id,
    postId,
    userId,
    username,
    avatarUrl,
    content,
    createdAt,
    updatedAt,
    likesCount,
    isLikedByCurrentUser,
  ];
}
