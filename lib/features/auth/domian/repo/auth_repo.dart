import 'package:dartz/dartz.dart';
import 'package:fitness/core/error/faileur.dart';
import 'package:fitness/features/auth/domian/entites/user_entity.dart';

abstract class AuthRepo {
  Future<Either<Faileur, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Faileur, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Faileur, UserEntity>> signInWithGoogle();
  Future<Either<Faileur, UserEntity>> signInWithFacebook();
  Future addUserDataToFirestore({required UserEntity user});
  Future<UserEntity> getDataUser({required String userId});
  Future<UserEntity?> saveUserData({required UserEntity userEntity});
}
