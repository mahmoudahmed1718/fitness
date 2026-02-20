import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/constant.dart';
import 'package:fitness/core/error/exception.dart';
import 'package:fitness/core/error/faileur.dart';
import 'package:fitness/core/services/data_base_service.dart';
import 'package:fitness/core/services/firebase_auth_service.dart';
import 'package:fitness/core/services/shared_prefence_singleton.dart';
import 'package:fitness/core/utlis/back_end_points.dart';
import 'package:fitness/features/auth/data/models/user_model.dart';
import 'package:fitness/features/auth/domian/entites/user_entity.dart';
import 'package:fitness/features/auth/domian/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthServices firebaseAuthServices;
  final DatabaseService databaseService;
  AuthRepoImpl({
    required this.databaseService,
    required this.firebaseAuthServices,
  });
  @override
  Future<Either<Faileur, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    User? user;
    try {
      user = await firebaseAuthServices.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userEntity = UserEntity(id: user!.uid, name: name, email: email);
      addUserDataToFirestore(user: userEntity);

      return right(userEntity);
    } on CustomException catch (e) {
      await deleteuser(user);
      return left(ServerFaileur(message: e.message));
    } catch (e) {
      deleteuser(user);
      return left(ServerFaileur(message: 'An unknown error occurred.'));
    }
  }

  Future<void> deleteuser(User? user) async {
    if (user != null) {
      await firebaseAuthServices.deleteUser();
    }
  }

  @override
  Future<Either<Faileur, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var user = await firebaseAuthServices.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userData = await getDataUser(userId: user!.uid);
      await saveUserData(userEntity: userData);
      return right(userData);
    } on CustomException catch (e) {
      return left(ServerFaileur(message: e.message));
    } catch (e) {
      log(
        'execption on authRepoImpl.signInWithEmailAndPassword. ${e.toString()}',
      );
      return left(ServerFaileur(message: 'An unknown error occurred.'));
    }
  }

  @override
  // Future<Either<Faileur, UserEntity>> signInWithGoogle() async {
  //   User? user;
  //   try {
  //     user = await firebaseAuthServices.signInWithGoogle();
  //     var userentity = UserModel.formFireBaseUser(user);
  //     var isUserExists = await databaseService.checkUserExists(
  //       path: BackendPoints.getUserData,
  //       documentId: userentity.id,
  //     );
  //     if (isUserExists) {
  //       await getDataUser(userId: user.uid);
  //     } else {
  //       await addUserDataToFirestore(user: userentity);
  //     }
  //     return right(userentity);
  //   } catch (e) {
  //     await deleteuser(user);
  //     log('execption on authRepoImpl.signInWithGoogle. ${e.toString()}');
  //     return left(ServerFaileur(message: 'An unknown error occurred.'));
  //   }
  // }
  @override
  Future<Either<Faileur, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthServices.signInWithFacebook();
      var userentity = UserModel.formFireBaseUser(user);
      var isUserexsit = await databaseService.checkUserExists(
        path: BackendPoints.getUserData,
        documentId: userentity.id,
      );
      if (isUserexsit) {
        await getDataUser(userId: user.uid);
      } else {
        await addUserDataToFirestore(user: userentity);
      }
      return right(userentity);
    } catch (e) {
      deleteuser(user);
      log('execption on authRepoImpl.signInWithFacebook. ${e.toString()}');
      return left(ServerFaileur(message: 'An unknown error occurred.'));
    }
  }

  @override
  Future addUserDataToFirestore({required UserEntity user}) async {
    await databaseService.addData(
      path: BackendPoints.addUserData,
      data: UserModel.fromEntity(user).toJson(),
      documentId: user.id,
    );
  }

  @override
  Future<UserEntity> getDataUser({required String userId}) async {
    try {
      var userData = await databaseService.getData(
        path: BackendPoints.getUserData,
        documentId: userId,
      );
      return UserModel.fromJson(userData);
    } on ServerFaileur catch (e) {
      log('execption on authRepoImpl.getDataUser. ${e.toString()}');
      throw CustomException(message: 'An unknown error occurred.');
    } catch (e) {
      log('execption on authRepoImpl.getDataUser. ${e.toString()}');
      throw CustomException(message: 'An unknown error occurred.');
    }
  }

  @override
  Future<UserEntity?> saveUserData({required UserEntity userEntity}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(userEntity).toJson());
    await SharedPreferenceSingleton.setString(kUserData, jsonData);
    return userEntity;
  }
}
