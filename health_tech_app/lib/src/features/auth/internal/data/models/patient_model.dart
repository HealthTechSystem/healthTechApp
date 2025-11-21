import 'package:cloud_firestore/cloud_firestore.dart';

/// TODO conectar ao firestore por aqui
class PatientModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? phone;
  final String status;
  final String clinicId;
  final DateTime createdAt;

  PatientModel({
    required this.uid,
    this.displayName,
    this.email,
    this.phone,
    required this.status,
    required this.clinicId,
    required this.createdAt,
  });

  factory PatientModel.fromFirestore(
    String uid,
    Map<String, dynamic> data,
  ) {
    return PatientModel(
      uid: uid,
      displayName: data['displayName'],
      email: data['email'],
      phone: data['phone'],
      status: data['status'] ?? 'active',
      clinicId: data['clinicId'] ?? '',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'phone': phone,
      'status': status,
      'clinicId': clinicId,
      'createdAt': createdAt,
    };
  }
}
