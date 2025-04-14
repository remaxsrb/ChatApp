import 'package:flutter/material.dart';
import 'package:mobile_client/views/signup/step2_password.dart';
import 'package:mobile_client/views/signup/step3_dob_gener.dart';
import 'package:mobile_client/views/signup/step4_profile_photo.dart';
import '../views/landing/landing_screen.dart';
import '../views/login/login_screen.dart';
import '../views/signup/step1_username_email.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String signupStep1 = '/signup';
  static const String signupStep2 = '/signup/password';
  static const String signupStep3 = '/signup/dobgender';
  static const String signupStep4 = '/signup/photo';



  static final Map<String, WidgetBuilder> routes = {
    landing: (context) => const LandingScreen(),
    login: (context) => const LoginScreen(),
    signupStep1: (context) => Step1UsernameEmail(),
    signupStep2: (context) => Step2Password(),
    signupStep3: (context) => Step3DOBGender(),
    signupStep4: (context) => Step4ProfilePhoto(),



  };
}
