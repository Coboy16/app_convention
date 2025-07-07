import 'package:equatable/equatable.dart';

class FeedStoryEntity extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isViewedByCurrentUser;
  final List<String> viewedByUserIds;

  const FeedStoryEntity({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    required this.expiresAt,
    this.isViewedByCurrentUser = false,
    this.viewedByUserIds = const [],
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  FeedStoryEntity copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    String? imageUrl,
    String? caption,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isViewedByCurrentUser,
    List<String>? viewedByUserIds,
  }) {
    return FeedStoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isViewedByCurrentUser:
          isViewedByCurrentUser ?? this.isViewedByCurrentUser,
      viewedByUserIds: viewedByUserIds ?? this.viewedByUserIds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    avatarUrl,
    imageUrl,
    caption,
    createdAt,
    expiresAt,
    isViewedByCurrentUser,
    viewedByUserIds,
  ];
}
