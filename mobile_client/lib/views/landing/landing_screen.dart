import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to ChatApp',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Sign Up',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.signupStep1),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Login',
                  isOutlined: true,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  buttonColor: Colors.blueGrey,
                  fontColor: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
