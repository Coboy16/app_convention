import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/feed_post_entity.dart';

class FeedPostModel extends FeedPostEntity {
  const FeedPostModel({
    required super.id,
    required super.userId,
    required super.username,
    super.avatarUrl,
    required super.content,
    required super.imageUrls,
    required super.createdAt,
    required super.updatedAt,
    super.likesCount,
    super.commentsCount,
    super.isLikedByCurrentUser,
    super.type,
    super.userRole,
    super.hashtags,
  });

  // Factory constructor desde Firestore
  factory FeedPostModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    // Verificar si el usuario actual dio like
    final likes = List<String>.from(data['likes'] ?? []);
    final isLikedByCurrentUser = likes.contains(currentUserId);

    return FeedPostModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      avatarUrl: data['avatarUrl'],
      content: data['content'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      likesCount: likes.length,
      commentsCount: data['commentsCount'] ?? 0,
      isLikedByCurrentUser: isLikedByCurrentUser,
      type: _parsePostType(data['type']),
      userRole: data['userRole'],
      hashtags: List<String>.from(data['hashtags'] ?? []),
    );
  }

  // Factory constructor desde Map
  factory FeedPostModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String currentUserId,
  ) {
    final likes = List<String>.from(map['likes'] ?? []);
    final isLikedByCurrentUser = likes.contains(currentUserId);

    return FeedPostModel(
      id: id,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      avatarUrl: map['avatarUrl'],
      content: map['content'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt']),
      likesCount: likes.length,
      commentsCount: map['commentsCount'] ?? 0,
      isLikedByCurrentUser: isLikedByCurrentUser,
      type: _parsePostType(map['type']),
      userRole: map['userRole'],
      hashtags: List<String>.from(map['hashtags'] ?? []),
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'content': content,
      'imageUrls': imageUrls,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'likes': [], // Se maneja por separado
      'commentsCount': commentsCount,
      'type': type.toString().split('.').last,
      'userRole': userRole,
      'hashtags': hashtags,
    };
  }

  // Factory constructor desde Entity
  factory FeedPostModel.fromEntity(FeedPostEntity entity) {
    return FeedPostModel(
      id: entity.id,
      userId: entity.userId,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      content: entity.content,
      imageUrls: entity.imageUrls,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      isLikedByCurrentUser: entity.isLikedByCurrentUser,
      type: entity.type,
      userRole: entity.userRole,
      hashtags: entity.hashtags,
    );
  }

  @override
  FeedPostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    String? content,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    bool? isLikedByCurrentUser,
    FeedPostType? type,
    String? userRole,
    List<String>? hashtags,
  }) {
    return FeedPostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
      type: type ?? this.type,
      userRole: userRole ?? this.userRole,
      hashtags: hashtags ?? this.hashtags,
    );
  }

  static FeedPostType _parsePostType(dynamic type) {
    if (type == null) return FeedPostType.user;

    switch (type.toString()) {
      case 'admin':
        return FeedPostType.admin;
      case 'user':
      default:
        return FeedPostType.user;
    }
  }
}
