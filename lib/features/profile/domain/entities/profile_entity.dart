import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String role; // 'participant' | 'organizer'
  final String bio;
  final List<String> allergies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    required this.bio,
    required this.allergies,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOrganizer => role == 'organizer';
  bool get isParticipant => role == 'participant';

  ProfileEntity copyWith({
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
    return ProfileEntity(
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

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    photoUrl,
    role,
    bio,
    allergies,
    createdAt,
    updatedAt,
  ];
}
