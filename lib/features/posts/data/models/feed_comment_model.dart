import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/feed_comment_entity.dart';

class FeedCommentModel extends FeedCommentEntity {
  const FeedCommentModel({
    required super.id,
    required super.postId,
    required super.userId,
    required super.username,
    super.avatarUrl,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
    super.likesCount,
    super.isLikedByCurrentUser,
  });

  // Factory constructor desde Firestore
  factory FeedCommentModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    // Verificar si el usuario actual dio like
    final likes = List<String>.from(data['likes'] ?? []);
    final isLikedByCurrentUser = likes.contains(currentUserId);

    return FeedCommentModel(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      avatarUrl: data['avatarUrl'],
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      likesCount: likes.length,
      isLikedByCurrentUser: isLikedByCurrentUser,
    );
  }

  // Factory constructor desde Map
  factory FeedCommentModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String currentUserId,
  ) {
    final likes = List<String>.from(map['likes'] ?? []);
    final isLikedByCurrentUser = likes.contains(currentUserId);

    return FeedCommentModel(
      id: id,
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      avatarUrl: map['avatarUrl'],
      content: map['content'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt']),
      likesCount: likes.length,
      isLikedByCurrentUser: isLikedByCurrentUser,
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'likes': [], // Se maneja por separado
    };
  }

  // Factory constructor desde Entity
  factory FeedCommentModel.fromEntity(FeedCommentEntity entity) {
    return FeedCommentModel(
      id: entity.id,
      postId: entity.postId,
      userId: entity.userId,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likesCount: entity.likesCount,
      isLikedByCurrentUser: entity.isLikedByCurrentUser,
    );
  }

  @override
  FeedCommentModel copyWith({
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
    return FeedCommentModel(
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
}
