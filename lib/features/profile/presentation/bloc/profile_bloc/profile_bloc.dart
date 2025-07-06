import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:konecta/features/profile/data/data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
    on<ProfileAvatarUpdateRequested>(_onProfileAvatarUpdateRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      // Simular llamada a API con delay
      await Future.delayed(const Duration(seconds: 1));

      // Usar mock data
      final profile = ProfileModel.mockProfile;

      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: 'Error al cargar el perfil: ${e.toString()}'));
    }
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(ProfileUpdating(profile: currentState.profile));

        // Simular llamada a API para actualizar
        await Future.delayed(const Duration(seconds: 1));

        emit(ProfileUpdated(profile: event.profile));

        // Volver al estado loaded con los datos actualizados
        emit(ProfileLoaded(profile: event.profile));
      }
    } catch (e) {
      emit(
        ProfileError(message: 'Error al actualizar el perfil: ${e.toString()}'),
      );
    }
  }

  Future<void> _onProfileRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // No mostrar loading para refresh
      await Future.delayed(const Duration(milliseconds: 500));

      final profile = ProfileModel.mockProfile;
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(
        ProfileError(message: 'Error al refrescar el perfil: ${e.toString()}'),
      );
    }
  }

  Future<void> _onProfileAvatarUpdateRequested(
    ProfileAvatarUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(ProfileUpdating(profile: currentState.profile));

        // Simular upload de imagen
        await Future.delayed(const Duration(seconds: 2));

        final updatedProfile = currentState.profile.copyWith(
          avatarUrl: event.avatarUrl,
        );

        emit(ProfileLoaded(profile: updatedProfile));
      }
    } catch (e) {
      emit(
        ProfileError(message: 'Error al actualizar la imagen: ${e.toString()}'),
      );
    }
  }

  // Métodos helper
  void loadProfile() {
    add(ProfileLoadRequested());
  }

  void updateProfile(ProfileModel profile) {
    add(ProfileUpdateRequested(profile: profile));
  }

  void refreshProfile() {
    add(ProfileRefreshRequested());
  }

  void updateAvatar(String avatarUrl) {
    add(ProfileAvatarUpdateRequested(avatarUrl: avatarUrl));
  }
}
