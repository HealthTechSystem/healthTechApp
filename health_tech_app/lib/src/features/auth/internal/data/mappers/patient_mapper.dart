import 'package:health_tech_app/src/features/auth/internal/data/models/patient_model.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/entities/patient_entity.dart';

class PatientMapper {
  static PatientEntity toEntity(PatientModel model) {
    return PatientEntity(
      uid: model.uid,
      displayName: model.displayName ?? '',
      email: model.email ?? '',
      phone: model.phone ?? '',
      status: model.status, // já é required no model
      clinicId: model.clinicId,
      createdAt: model.createdAt,
    );
  }

  static PatientModel fromEntity(PatientEntity entity) {
    return PatientModel(
      uid: entity.uid,
      displayName: entity.displayName,
      email: entity.email,
      phone: entity.phone,
      status: entity.status,
      clinicId: entity.clinicId,
      createdAt: entity.createdAt,
    );
  }
}
