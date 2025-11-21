import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:health_tech_app/src/core/infra/router/app_router.dart';
import 'package:health_tech_app/src/core/infra/services/firebase/firebase_service.dart';
import 'package:health_tech_app/src/core/infra/services/router/router_services.dart';
import 'package:health_tech_app/src/features/auth/external/data/data_source/firebase_auth_datasource.dart';
import 'package:health_tech_app/src/features/auth/external/data/data_source/firebase_auth_datasource_impl.dart';
import 'package:health_tech_app/src/features/auth/external/domain/use_cases/login_patient_uc.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/contracts/auth_repository.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/contracts/auth_repository_impl.dart';
import 'package:health_tech_app/src/features/auth/internal/presentation/view_model/login_view_model.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  // ===== CORE =====
  getIt.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );

  getIt.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  // ===== AUTH FEATURE =====
  getIt.registerLazySingleton<FirebaseService>(
        () => FirebaseService(getIt<FirebaseFirestore>()),
  );

  // DataSource
  getIt.registerLazySingleton<FirebaseAuthDatasourceImpl>(
        () => FirebaseAuthDatasourceImpl(
      getIt<FirebaseAuth>(),
    
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      getIt<FirebaseAuthDatasourceImpl>(),
    ),
  );

  // UseCase
  getIt.registerLazySingleton<LoginPatientUc>(
        () => LoginUcImpl(
      getIt<AuthRepository>(),
    ),
  );

  // ViewModel
  getIt.registerFactory<LoginViewModel>(
        () => LoginViewModel(
      getIt<LoginPatientUc>(),
    ),
  );

  // ===== ROUTER SERVICE =====
  getIt.registerLazySingleton<RouterService>(
        () => RouterServiceImpl(buildRouter()),
  );
}
