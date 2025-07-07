import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/feed_story_entity.dart';

class FeedStoryModel extends FeedStoryEntity {
  const FeedStoryModel({
    required super.id,
    required super.userId,
    required super.username,
    super.avatarUrl,
    required super.imageUrl,
    required super.caption,
    required super.createdAt,
    required super.expiresAt,
    super.isViewedByCurrentUser,
    super.viewedByUserIds,
  });

  // Factory constructor desde Firestore
  factory FeedStoryModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    // Verificar si el usuario actual vio la historia
    final viewedBy = List<String>.from(data['viewedBy'] ?? []);
    final isViewedByCurrentUser = viewedBy.contains(currentUserId);

    return FeedStoryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      avatarUrl: data['avatarUrl'],
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      isViewedByCurrentUser: isViewedByCurrentUser,
      viewedByUserIds: viewedBy,
    );
  }

  // Factory constructor desde Map
  factory FeedStoryModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String currentUserId,
  ) {
    final viewedBy = List<String>.from(map['viewedBy'] ?? []);
    final isViewedByCurrentUser = viewedBy.contains(currentUserId);

    return FeedStoryModel(
      id: id,
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      avatarUrl: map['avatarUrl'],
      imageUrl: map['imageUrl'] ?? '',
      caption: map['caption'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      expiresAt: map['expiresAt'] is Timestamp
          ? (map['expiresAt'] as Timestamp).toDate()
          : DateTime.parse(map['expiresAt']),
      isViewedByCurrentUser: isViewedByCurrentUser,
      viewedByUserIds: viewedBy,
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'viewedBy': viewedByUserIds,
    };
  }

  // Factory constructor desde Entity
  factory FeedStoryModel.fromEntity(FeedStoryEntity entity) {
    return FeedStoryModel(
      id: entity.id,
      userId: entity.userId,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      imageUrl: entity.imageUrl,
      caption: entity.caption,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      isViewedByCurrentUser: entity.isViewedByCurrentUser,
      viewedByUserIds: entity.viewedByUserIds,
    );
  }

  @override
  FeedStoryModel copyWith({
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
    return FeedStoryModel(
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
}
