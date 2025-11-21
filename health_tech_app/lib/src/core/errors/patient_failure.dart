class PatientNotFoundFailure implements Exception {
  final String message;

  PatientNotFoundFailure([this.message = "Paciente não encontrado."]);
  
  @override
  String toString() => message;
}
