import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_tech_app/src/features/auth/internal/data/models/patient_model.dart';

class FirestorePatientDatasourceImpl {
  final FirebaseFirestore _firestore;

  FirestorePatientDatasourceImpl(this._firestore);

  Future<PatientModel?> getById(String uid) async {
    final doc = await _firestore.collection('patients').doc(uid).get();
    if (!doc.exists) return null;
    return PatientModel.fromFirestore(doc.id, doc.data()!);
  }
}