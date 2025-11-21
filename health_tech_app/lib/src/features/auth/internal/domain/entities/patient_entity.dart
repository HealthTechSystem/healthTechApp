class PatientEntity {
  final String uid;
  final String displayName;
  final String email;
  final String phone;
  final String status;    // active | pending_validation | inactive
  final String clinicId;
  final DateTime createdAt;

  const PatientEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phone,
    required this.status,
    required this.clinicId,
    required this.createdAt,
  });
}
