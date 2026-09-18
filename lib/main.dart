import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_skill_sense/features/auth/providers/auth_provider.dart';
import 'package:ai_skill_sense/features/quests/providers/quest_provider.dart';
import 'package:ai_skill_sense/features/ai/providers/ai_provider.dart';
import 'package:ai_skill_sense/features/auth/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
        ChangeNotifierProvider(create: (_) => QuestProvider()),
      ],
      child: MaterialApp(
        title: 'AI Skill Sense',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}