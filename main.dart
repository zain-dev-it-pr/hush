import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hushh/splash_screen.dart';
import 'package:hushh/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
runApp(const HushhApp());
}
class HushhApp extends StatelessWidget {
  const HushhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hushh',
      theme: AppTheme.dark(),
      home: const SplashScreen(),
    );
  }
}
