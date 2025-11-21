import 'package:health_tech_app/src/core/errors/patient_failure.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/contracts/auth_repository.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/contracts/patient_repository.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/entities/patient_entity.dart';

class LoginWithGoogleUc {
  final AuthRepository _authRepository;
  final PatientRepository _patientRepository;

  LoginWithGoogleUc(this._authRepository, this._patientRepository);

  Future<PatientEntity> call() async {
    final uid = await _authRepository.loginWithGoogle();

    final patient = await _patientRepository.getById(uid);

    if (patient == null) {
      throw PatientNotFoundFailure();
    }

    return patient;
  }
}
