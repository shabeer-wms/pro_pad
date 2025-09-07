import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import your services, routes, and initial view

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Initialize Isar database service
  // TODO: Initialize AudioSession
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pro Pad',
      // TODO: Define light and dark themes in a separate class
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // initialRoute: AppPages.INITIAL, // Define in your routes file
      // getPages: AppPages.routes,
      home: const Text("ProPad Home"), // Replace with your initial view
    );
  }
}