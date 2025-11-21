import 'package:health_tech_app/src/features/auth/external/data/data_source/firestore_patient_datasource_impl.dart';
import 'package:health_tech_app/src/features/auth/internal/data/mappers/patient_mapper.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/contracts/patient_repository.dart';
import 'package:health_tech_app/src/features/auth/internal/domain/entities/patient_entity.dart';

class PatientRepositoryImpl implements PatientRepository {
  final FirestorePatientDatasourceImpl datasource;

  PatientRepositoryImpl(this.datasource);

  @override
  Future<PatientEntity?> getById(String uid) async {
    final model = await datasource.getById(uid);
    return model != null ? PatientMapper.toEntity(model) : null;
  }
}