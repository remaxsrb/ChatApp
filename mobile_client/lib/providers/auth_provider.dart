import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthState {
  final String? token;
  AuthState({this.token});

  bool get isAuthenticated => token != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  AuthNotifier() : super(AuthState()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await secureStorage.read(key: 'jwt_token');
    state = AuthState(token: token);
  }

  Future<void> login(String token) async {
    await secureStorage.write(key: 'jwt_token', value: token);
    state = AuthState(token:token);
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
    state = AuthState();
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());