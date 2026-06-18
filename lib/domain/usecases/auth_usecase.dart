import '../repositories/auth_repository.dart';

class AuthUsecase {
  final AuthRepository authRepository;
  AuthUsecase(this.authRepository);

  Future<String> login(String username, String password) {
    return authRepository.login(username, password);
  }

  void logout() {
    authRepository.logout();
  }
}
