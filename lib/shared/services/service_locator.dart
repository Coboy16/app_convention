import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '/features/feactures.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Auth Feature
  _initAuth();
}

void _initAuth() {
  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      googleSignIn: sl(),
      firestore: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), connectionChecker: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthStateUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      googleSignInUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      getAuthStateUseCase: sl(),
    ),
  );

  // profile
  // External dependencies
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  // DataSources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firestore: sl(), storage: sl()),
  );

  sl.registerLazySingleton<ImageLocalDataSource>(
    () => ImageLocalDataSourceImpl(imagePicker: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () =>
        ProfileRepositoryImpl(remoteDataSource: sl(), connectionChecker: sl()),
  );

  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => GetUserPostsUseCase(sl()));
  sl.registerLazySingleton(() => CreatePostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => PickImageUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      updateProfileImageUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PostsBloc(
      getUserPostsUseCase: sl(),
      createPostUseCase: sl(),
      deletePostUseCase: sl(),
    ),
  );
}
