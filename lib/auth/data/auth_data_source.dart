abstract class AuthDataSource {
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<void> signOut();
  Future<void> resetPassword(String email);
}
