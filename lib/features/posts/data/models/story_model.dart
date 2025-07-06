import 'package:equatable/equatable.dart';

class StoryModel extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String imageUrl;
  final String caption;
  final DateTime createdAt;
  final bool isViewed;

  const StoryModel({
    required this.id,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
    this.isViewed = false,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      imageUrl: json['imageUrl'] as String,
      caption: json['caption'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'createdAt': createdAt.toIso8601String(),
      'isViewed': isViewed,
    };
  }

  StoryModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatarUrl,
    String? imageUrl,
    String? caption,
    DateTime? createdAt,
    bool? isViewed,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
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
    isViewed,
  ];

  // Mock data para desarrollo
  static List<StoryModel> get mockStories => [
    StoryModel(
      id: '1',
      userId: 'user1',
      username: 'Sarah M.',
      imageUrl: 'https://picsum.photos/400/600?random=1',
      caption: 'Getting ready for the convention! 🎉',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StoryModel(
      id: '2',
      userId: 'user2',
      username: 'Mike R.',
      imageUrl: 'https://picsum.photos/400/600?random=2',
      caption: 'Amazing speakers lineup! 🚀',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    StoryModel(
      id: '3',
      userId: 'user3',
      username: 'Ana L.',
      imageUrl: 'https://picsum.photos/400/600?random=3',
      caption: 'Networking time! 🤝',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    StoryModel(
      id: '4',
      userId: 'user4',
      username: 'Carlos P.',
      imageUrl: 'https://picsum.photos/400/600?random=4',
      caption: 'Best conference ever! 💯',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
  ];
}
