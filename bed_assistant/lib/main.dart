import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/assistant_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssistantProvider()..init()),
      ],
      child: const BedAssistantApp(),
    ),
  );
}

class BedAssistantApp extends StatelessWidget {
  const BedAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B.Ed AI Book Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
