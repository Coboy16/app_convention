import 'package:equatable/equatable.dart';

class PostTwoModel extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final PostType type;
  final String? role;

  const PostTwoModel({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.type = PostType.user,
    this.role,
  });

  factory PostTwoModel.fromJson(Map<String, dynamic> json) {
    return PostTwoModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      type: PostType.values.firstWhere(
        (e) => e.toString() == 'PostType.${json['type']}',
        orElse: () => PostType.user,
      ),
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'type': type.toString().split('.').last,
      'role': role,
    };
  }

  PostTwoModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    String? content,
    String? imageUrl,
    DateTime? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    PostType? type,
    String? role,
  }) {
    return PostTwoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      type: type ?? this.type,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    avatarUrl,
    content,
    imageUrl,
    createdAt,
    likesCount,
    commentsCount,
    isLiked,
    type,
    role,
  ];

  // Mock data para desarrollo
  static List<PostTwoModel> get mockPosts => [
    PostTwoModel(
      id: '1',
      userId: 'admin1',
      username: 'Event Team',
      content:
          '🎉 Welcome everyone to Convention 2024! We\'re excited to have you all here in Lima. Don\'t forget to check your schedules and join us for the opening ceremony at 9 AM.',
      imageUrl: 'https://picsum.photos/600/400?random=10',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likesCount: 24,
      commentsCount: 8,
      type: PostType.admin,
      role: 'Organizer',
    ),
    PostTwoModel(
      id: '2',
      userId: 'user1',
      username: 'Maria Rodriguez',
      content:
          'Just arrived in Lima! The city is beautiful and I\'m so excited for the convention. Looking forward to meeting everyone! 🇵🇪',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      likesCount: 12,
      commentsCount: 5,
      type: PostType.user,
    ),
    PostTwoModel(
      id: '3',
      userId: 'admin2',
      username: 'Marketing Team',
      content:
          '📸 Photo contest is now live! Share your best moments from the convention with #Convention2024 for a chance to win amazing prizes!',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      likesCount: 45,
      commentsCount: 15,
      type: PostType.admin,
      role: 'Organizer',
    ),
  ];
}

enum PostType { user, admin }
