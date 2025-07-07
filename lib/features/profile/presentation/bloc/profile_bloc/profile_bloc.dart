import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/features/profile/domain/domain.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateProfileImageUseCase updateProfileImageUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.updateProfileImageUseCase,
  }) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileImageUpdateRequested>(_onProfileImageUpdateRequested);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getProfileUseCase(event.userId);

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileUpdating(profile: currentState.profile));

      final result = await updateProfileUseCase(
        userId: event.userId,
        name: event.name,
        bio: event.bio,
        allergies: event.allergies,
      );

      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (profile) => emit(ProfileLoaded(profile: profile)),
      );
    }
  }

  Future<void> _onProfileImageUpdateRequested(
    ProfileImageUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileImageUploading(profile: currentState.profile));

      final result = await updateProfileImageUseCase(
        userId: event.userId,
        imagePath: event.imagePath,
      );

      result.fold(
        (failure) => emit(ProfileError(message: failure.message)),
        (profile) => emit(ProfileLoaded(profile: profile)),
      );
    }
  }

  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await getProfileUseCase(event.userId);

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }
}
