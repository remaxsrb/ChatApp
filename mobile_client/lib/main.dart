import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Landing',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.landing,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
