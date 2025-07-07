import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role; // 'participant' | 'organizer'
  final String bio;
  final List<String> allergies; // ✅ Cambiado de String a List<String>
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.bio = '',
    this.allergies = const [], // ✅ Valor por defecto es lista vacía
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOrganizer => role == 'organizer';
  bool get isParticipant => role == 'participant';

  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? bio,
    List<String>? allergies, // ✅ Cambiado el tipo
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
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

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    bio,
    allergies,
    photoUrl,
    createdAt,
    updatedAt,
  ];
}
