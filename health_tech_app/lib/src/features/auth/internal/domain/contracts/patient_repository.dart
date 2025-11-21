import 'package:health_tech_app/src/features/auth/internal/domain/entities/patient_entity.dart';

abstract class PatientRepository {
  Future<PatientEntity?> getById(String uid);
}