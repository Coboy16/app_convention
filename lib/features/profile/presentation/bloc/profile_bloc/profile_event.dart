part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {}

class ProfileUpdateRequested extends ProfileEvent {
  final ProfileModel profile;

  const ProfileUpdateRequested({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileRefreshRequested extends ProfileEvent {}

class ProfileAvatarUpdateRequested extends ProfileEvent {
  final String avatarUrl;

  const ProfileAvatarUpdateRequested({required this.avatarUrl});

  @override
  List<Object> get props => [avatarUrl];
}
