abstract class FirebaseAuthDatasource {
  Future<Map<String, dynamic>> login(String email, String password);
}
