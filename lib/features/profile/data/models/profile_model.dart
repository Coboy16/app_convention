import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    required super.role,
    required super.bio,
    required super.allergies,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProfileModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'participant',
      bio: data['bio'] ?? '',
      allergies: _parseAllergies(data['allergies']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Método helper para manejar la conversión de alergias
  static List<String> _parseAllergies(dynamic allergiesData) {
    if (allergiesData == null) return [];

    if (allergiesData is List) {
      return allergiesData.map((item) => item.toString()).toList();
    }

    if (allergiesData is String) {
      // Si es un string, intentar dividirlo o retornarlo como lista
      return [allergiesData];
    }

    return [];
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return ProfileModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      role: map['role'] ?? 'participant',
      bio: map['bio'] ?? '',
      allergies: _parseAllergies(map['allergies']),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
      'bio': bio,
      'allergies': allergies,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Factory constructor desde Entity
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      photoUrl: entity.photoUrl,
      role: entity.role,
      bio: entity.bio,
      allergies: entity.allergies,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
    String? bio,
    List<String>? allergies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      allergies: allergies ?? this.allergies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
