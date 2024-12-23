import 'package:flutter/material.dart';
// import 'package:minimal_chat_app/Pages/home_page.dart';
// import 'package:minimal_chat_app/Pages/login_page.dart';
// import 'package:minimal_chat_app/services/auth/auth_gate.dart';
// import 'package:minimal_chat_app/auth/login_or_register.dart';
import 'package:minimal_chat_app/firebase_options.dart';
import 'package:minimal_chat_app/services/auth/auth_gate.dart';
// import 'package:minimal_chat_app/theme/light_mood.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:minimal_chat_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
