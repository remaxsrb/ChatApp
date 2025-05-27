import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_client/models/login_form.dart';
import 'package:mobile_client/utils/http_wrapper.dart';

class LoginFormNotifier extends StateNotifier<LoginForm> {
  LoginFormNotifier() : super(LoginForm());

  void updateUsername(String username) =>
      state = state.copyWith(username: username);

  void updatePassword(String password) =>
      state = state.copyWith(password: password);

  void clear() => state = LoginForm();

  Future<String> submit() async {
    final httpClient = await createHttpClient();
    final uri = Uri.https("localhost.local", "auth/login");
    final request = await httpClient.postUrl(uri);

    try {
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final requestBody = jsonEncode({
        'username': state.username,
        'password': state.password,
      });

      request.write(requestBody);
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        final token = responseData['token'];

        if (token == null || token.isEmpty) {
          throw Exception("Token not found in response");
        }

        return token;
      } else {
        throw Exception("Login failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      httpClient.close();
    }
  }
}

final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginForm>((
  ref,
) {
  return LoginFormNotifier();
});
