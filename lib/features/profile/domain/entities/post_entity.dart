import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String userId;
  final String? description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PostEntity({
    required this.id,
    required this.userId,
    this.description,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
  });

  PostEntity copyWith({
    String? id,
    String? userId,
    String? description,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    description,
    imageUrls,
    createdAt,
    updatedAt,
  ];
}
