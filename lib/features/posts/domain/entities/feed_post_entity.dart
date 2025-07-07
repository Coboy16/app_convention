import 'package:equatable/equatable.dart';

class FeedPostEntity extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByCurrentUser;
  final FeedPostType type;
  final String? userRole;
  final List<String> hashtags;

  const FeedPostEntity({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLikedByCurrentUser = false,
    this.type = FeedPostType.user,
    this.userRole,
    this.hashtags = const [],
  });

  FeedPostEntity copyWith({
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
    return FeedPostEntity(
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

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    avatarUrl,
    content,
    imageUrls,
    createdAt,
    updatedAt,
    likesCount,
    commentsCount,
    isLikedByCurrentUser,
    type,
    userRole,
    hashtags,
  ];
}

enum FeedPostType { user, admin }
