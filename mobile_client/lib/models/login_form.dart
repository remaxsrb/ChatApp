class LoginForm {
  final String username;
  final String password;

  LoginForm({
    this.username = '',
    this.password = '',

  });

  LoginForm copyWith({
    String? username,
    String? password,
  }) {
    return LoginForm(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

