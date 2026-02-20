import 'package:fitness/core/services/data_base_service.dart';
import 'package:fitness/core/services/firebase_auth_service.dart';
import 'package:fitness/core/services/firestore_service.dart';
import 'package:fitness/features/auth/data/repo/auth_repo_impl.dart';
import 'package:fitness/features/auth/domian/repo/auth_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuthServices>(FirebaseAuthServices());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      firebaseAuthServices: getIt<FirebaseAuthServices>(),
      databaseService: getIt<DatabaseService>(),
    ),
  );
}
