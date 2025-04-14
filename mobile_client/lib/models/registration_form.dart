class RegistrationForm {
  final String username;
  final String email;
  final String password;
  final DateTime? dateOfBirth;
  final String gender;
  final String? profilePhoto; // File path or network URI

  RegistrationForm({
    this.username = '',
    this.email = '',
    this.password = '',
    this.dateOfBirth,
    this.gender = '',
    this.profilePhoto,
  });

  RegistrationForm copyWith({
    String? username,
    String? email,
    String? password,
    DateTime? dateOfBirth,
    String? gender,
    String? profilePhoto,
  }) {
    return RegistrationForm(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}

