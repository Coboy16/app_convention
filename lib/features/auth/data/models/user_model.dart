import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    super.bio,
    super.allergies,
    super.photoUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  // Factory constructor para crear desde Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'participant',
      bio: data['bio'] ?? '',
      allergies: _parseAllergies(data['allergies']), // ✅ Usar helper method
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // ✅ Método helper para manejar la conversión de alergias
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

  // Factory constructor para crear desde Map
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'participant',
      bio: map['bio'] ?? '',
      allergies: _parseAllergies(map['allergies']), // ✅ Usar helper method
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(map['updatedAt']),
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'bio': bio,
      'allergies': allergies, // ✅ Ya es List<String>, no necesita conversión
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Factory constructor desde Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: entity.role,
      bio: entity.bio,
      allergies: entity.allergies,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Crear nuevo usuario con defaults
  factory UserModel.createNew({
    required String id,
    required String email,
    required String name,
    String role = 'participant',
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      email: email,
      name: name,
      role: role,
      bio: '',
      allergies: const [], // ✅ Lista vacía por defecto
      photoUrl: null,
      createdAt: now,
      updatedAt: now,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? bio,
    List<String>? allergies, // ✅ Cambiar tipo
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      allergies: allergies ?? this.allergies,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
