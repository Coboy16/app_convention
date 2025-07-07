part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  final String userId;

  const ProfileLoadRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ProfileUpdateRequested extends ProfileEvent {
  final String userId;
  final String? name;
  final String? bio;
  final List<String>? allergies;

  const ProfileUpdateRequested({
    required this.userId,
    this.name,
    this.bio,
    this.allergies,
  });

  @override
  List<Object?> get props => [userId, name, bio, allergies];
}

class ProfileImageUpdateRequested extends ProfileEvent {
  final String userId;
  final String imagePath;

  const ProfileImageUpdateRequested({
    required this.userId,
    required this.imagePath,
  });

  @override
  List<Object> get props => [userId, imagePath];
}

class ProfileRefreshRequested extends ProfileEvent {
  final String userId;

  const ProfileRefreshRequested({required this.userId});

  @override
  List<Object> get props => [userId];
}
