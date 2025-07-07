import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;

  Future<UserModel> updateUserInFirestore(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerException('No se pudo autenticar el usuario');
      }

      // Obtener datos del usuario desde Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw const ServerException(
          'Usuario no encontrado en la base de datos',
        );
      }

      return UserModel.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      debugPrint('Error inesperado: ${e.toString()}');
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const ServerException('No se pudo crear el usuario');
      }

      // Crear nuevo usuario en Firestore
      final newUser = UserModel.createNew(
        id: credential.user!.uid,
        email: email,
        name: name,
        role: 'participant', // Rol por defecto
      );

      // Guardar en Firestore
      await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(newUser.toMap());

      // Actualizar displayName en Firebase Auth
      await credential.user!.updateDisplayName(name);

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      debugPrint('Error inesperado: ${e.toString()}');
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const ServerException('Inicio de sesión con Google cancelado');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw const ServerException('No se pudo autenticar con Google');
      }

      final user = userCredential.user!;

      // Verificar si el usuario ya existe en Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      UserModel userModel;

      if (userDoc.exists) {
        // Usuario existente
        userModel = UserModel.fromFirestore(userDoc);
      } else {
        // Nuevo usuario, crear en Firestore
        userModel = UserModel.createNew(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          role: 'participant',
        );

        await firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw ServerException(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      debugPrint('Error inesperado: ${e.toString()}');
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
    } catch (e) {
      throw ServerException('Error al cerrar sesión: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      final userDoc = await firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw ServerException('Error al obtener usuario actual: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }

      try {
        final userDoc = await firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) {
          return null;
        }

        return UserModel.fromFirestore(userDoc);
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<UserModel> updateUserInFirestore(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());

      await firestore
          .collection('users')
          .doc(user.id)
          .update(updatedUser.toMap());

      return updatedUser;
    } catch (e) {
      throw ServerException('Error al actualizar usuario: ${e.toString()}');
    }
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo electrónico';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo electrónico';
      case 'weak-password':
        return 'La contraseña es muy débil';
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo más tarde';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      default:
        return 'Error de autenticación: $code';
    }
  }
}
