import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_client/providers/registration_form.dart';
import 'package:mobile_client/routes/app_routes.dart';

class Step1UsernameEmail extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  Step1UsernameEmail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(registrationFormProvider);
    final formNotifier = ref.read(registrationFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final username = form.username.trim();
                final email = form.email.trim();

                final usernameExists = await checkUsernameInDB(username);
                final emailExists = await checkEmailInDB(email);

                if (!context.mounted) return;

                if (usernameExists || emailExists) {
                  String errorMessage = '';
                  if (usernameExists) {
                    errorMessage += 'Username already taken.\n';
                  }
                  if (emailExists) errorMessage += 'Email already in use.';

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(errorMessage.trim())));
                  return;
                }

                Navigator.pushNamed(context, AppRoutes.signupStep2);
              }
            },

            child: Row(children: [Text('Next'), Icon(Icons.arrow_forward)]),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Basic information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Username",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _UsernameField(
                initialValue: form.username,
                onChanged: formNotifier.updateUsername,
              ),
              const Text(
                "Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _EmailField(
                initialValue: form.email,
                onChanged: formNotifier.updateEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _UsernameField({required this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      //decoration: const InputDecoration(labelText: "Username"),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a username';
        }
        return null;
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _EmailField({required this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      //decoration: const InputDecoration(labelText: "Email"),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        } else if (!RegExp(
          r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$",
        ).hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}
