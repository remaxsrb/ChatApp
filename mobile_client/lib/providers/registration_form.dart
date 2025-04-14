import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_client/utils/http_wrapper.dart';
import 'package:mobile_client/utils/photo_uploader.dart';
import '../models/registration_form.dart';
import 'dart:convert';

class RegistrationFormNotifier extends StateNotifier<RegistrationForm> {
  RegistrationFormNotifier() : super(RegistrationForm());

  void updateUsername(String username) =>
      state = state.copyWith(username: username);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updatePassword(String password) =>
      state = state.copyWith(password: password);
  void updateDateOfBirth(DateTime date) =>
      state = state.copyWith(dateOfBirth: date);
  void updateGender(String? gender) => state = state.copyWith(gender: gender);
  void updateProfilePhoto(String path) =>
      state = state.copyWith(profilePhoto: path);

  Future<bool> submit() async {
    String uploadedPhotoURL = '';
    if (state.profilePhoto?.isNotEmpty == true) {
      uploadedPhotoURL = await uploadPhoto(state.profilePhoto!);
      if (uploadedPhotoURL.isEmpty) return false;
    }

    final httpClient = await createHttpClient();
    final uri = Uri.https("localhost.local", "users/register");
    final request = await httpClient.postUrl(uri);

    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

    final requestBody = jsonEncode({
      'username': state.username,
      'date_of_birth':
          state.dateOfBirth != null
              ? '${state.dateOfBirth!.toIso8601String()}Z'
              : '',
      'password': state.password,
      'email': state.email,
      'profile_picture': uploadedPhotoURL,
      'gender': state.gender.toLowerCase(),
    });

    request.write(requestBody);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 201) {
      state = RegistrationForm();
      return true;
    }

    print(responseBody);
    return false;
  }
}

Future<bool> checkUsernameInDB(String username) async {
  final uri = Uri.https('localhost.local', 'users/check-username', {
    "username": username,
  });

  final httpClient = await createHttpClient();

  final request = await httpClient.getUrl(uri);

  final response = await request.close();

  final responseBody = await response.transform(utf8.decoder).join();

  return jsonDecode(responseBody)["in_db"] as bool;
}

Future<bool> checkEmailInDB(String email) async {
  final uri = Uri.https('localhost.local', 'users/check-email', {
    "email": email,
  });
  final httpClient = await createHttpClient();

  final request = await httpClient.getUrl(uri);

  final response = await request.close();

  final responseBody = await response.transform(utf8.decoder).join();

  return jsonDecode(responseBody)["in_db"] as bool;
}

final registrationFormProvider =
    StateNotifierProvider<RegistrationFormNotifier, RegistrationForm>((ref) {
      return RegistrationFormNotifier();
    });
