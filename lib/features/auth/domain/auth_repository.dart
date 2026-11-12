abstract class AuthRepository {
  Future<bool> exists(String phone);

  Future<void> register(
      String phone, String first, String last, DateTime birth);

  Future<bool> login(String phone);

  Future<bool> get isLoggedIn;

  Future<void> logout();
}
