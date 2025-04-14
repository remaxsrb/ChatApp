import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_client/providers/registration_form.dart';
import 'package:mobile_client/routes/app_routes.dart';

class Step2Password extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final RegExp _upperCaseRegExp = RegExp(r'[A-Z]');
  final RegExp _numberRegExp = RegExp(r'[0-9]');
  final RegExp _specialCharRegExp = RegExp(r'[!@#$%^&*_]');
  final RegExp _lengthRegExp = RegExp(r'.{12,}');

  Step2Password({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(registrationFormProvider);
    final formNotifier = ref.read(registrationFormProvider.notifier);

    String password = form.password;
    bool isLengthValid = _lengthRegExp.hasMatch(password);
    bool hasUpperCase = _upperCaseRegExp.hasMatch(password);
    bool hasNumber = _numberRegExp.hasMatch(password);
    bool hasSpecialChar = _specialCharRegExp.hasMatch(password);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                Navigator.pushNamed(context, AppRoutes.signupStep3);
              }
            },
            child: Row(
              children: [
                Text('Next'),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Center the title here
              const Center(
                child: Text(
                  "Create Your Password",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: form.password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                onChanged: formNotifier.updatePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (!_lengthRegExp.hasMatch(value)) {
                    return 'Password must be at least 12 characters long';
                  } else if (!_upperCaseRegExp.hasMatch(value)) {
                    return 'Password must contain at least one uppercase letter';
                  } else if (!_numberRegExp.hasMatch(value)) {
                    return 'Password must contain at least one number';
                  } else if (!_specialCharRegExp.hasMatch(value)) {
                    return 'Password must contain at least one special character';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password Requirements
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordRequirement(
                      'At least 12 characters',
                      isLengthValid,
                    ),
                    _buildPasswordRequirement(
                      'At least 1 uppercase letter',
                      hasUpperCase,
                    ),
                    _buildPasswordRequirement('At least 1 number', hasNumber),
                    _buildPasswordRequirement(
                      'At least 1 special character (!@#\$%^&*_)',
                      hasSpecialChar,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.error,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: isValid ? Colors.green : Colors.red),
        ),
      ],
    );
  }
}
