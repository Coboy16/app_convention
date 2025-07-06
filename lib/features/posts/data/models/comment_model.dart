import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String content;
  final DateTime createdAt;
  final int likesCount;
  final bool isLiked;

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.content,
    required this.createdAt,
    this.likesCount = 0,
    this.isLiked = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'avatarUrl': avatarUrl,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'isLiked': isLiked,
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? username,
    String? avatarUrl,
    String? content,
    DateTime? createdAt,
    int? likesCount,
    bool? isLiked,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
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
    likesCount,
    isLiked,
  ];

  // Mock comments para desarrollo
  static List<CommentModel> getMockComments(String postId) {
    return [
      CommentModel(
        id: '1',
        postId: postId,
        userId: 'user1',
        username: 'Carlos Mendez',
        content:
            '¡Qué emocionante! No puedo esperar a las conferencias de mañana.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likesCount: 3,
      ),
      CommentModel(
        id: '2',
        postId: postId,
        userId: 'user2',
        username: 'Ana Sofia',
        content: 'Lima es increíble! La comida aquí es espectacular 🍽️',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likesCount: 5,
      ),
      CommentModel(
        id: '3',
        postId: postId,
        userId: 'user3',
        username: 'Miguel Torres',
        content:
            'Gracias por organizar este evento tan increíble. Todo está perfecto.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 8,
      ),
      CommentModel(
        id: '4',
        postId: postId,
        userId: 'user4',
        username: 'Lucia Vargas',
        content: 'Me encanta conocer a personas de todo el mundo aquí 🌍',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likesCount: 2,
      ),
      CommentModel(
        id: '5',
        postId: postId,
        userId: 'user5',
        username: 'Roberto Silva',
        content:
            '¿Alguien más está emocionado por la sesión de networking de esta tarde?',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        likesCount: 6,
      ),
    ];
  }
}
