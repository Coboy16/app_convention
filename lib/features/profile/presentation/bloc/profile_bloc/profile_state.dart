part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileUpdating extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdating({required this.profile});

  @override
  List<Object> get props => [profile];
}

class ProfileImageUploading extends ProfileState {
  final ProfileEntity profile;

  const ProfileImageUploading({required this.profile});

  @override
  List<Object> get props => [profile];
}
