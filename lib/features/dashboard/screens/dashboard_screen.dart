import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_skill_sense/features/settings/screens/settings_screen.dart';
import 'package:ai_skill_sense/features/auth/screens/profile_screen.dart';
import 'package:ai_skill_sense/features/auth/providers/auth_provider.dart';
import 'package:ai_skill_sense/features/auth/screens/login_screen.dart';
import 'package:ai_skill_sense/features/shared/models/attribute_type.dart';
import 'package:ai_skill_sense/features/shared/models/user_model.dart';
import 'package:ai_skill_sense/features/ai/screens/ai_query_screen.dart';
import 'package:ai_skill_sense/features/quests/screens/quests_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkAuthStatus();
    });
  }

  void _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final User? user = authProvider.currentUser;

    // Handle loading or unauthenticated fallback cleanly
    if (user == null) {
      return Scaffold(
        body: Center(
          child: authProvider.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Session expired or offline.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
        ),
      );
    }

    // Safely use user lists directly since they are non-nullable in the model
    final userSkills = user.skills;
    final userQuests = user.quests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Skill Sense - Dashboard'),
        actions: [
          // Settings & Integrations Button (for Webhook Bridge URL, etc.)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            tooltip: 'Settings & Integrations',
          ),
          // User Profile Button (Account metadata & Logout)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            tooltip: 'Profile',
          ),
          // Existing Logout Shortcut Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => authProvider.checkAuthStatus(),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // User Welcome Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${user.name}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text('Skills: ${userSkills.length}'),
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                        Chip(
                          label: Text('Quests: ${userQuests.length}'),
                          backgroundColor: Colors.deepPurple.shade50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Navigation Hub for Phase 5 & 6 Features
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AIQueryScreen()),
                    ),
                    icon: const Icon(Icons.psychology),
                    label: const Text('AI Evaluator'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuestsScreen()),
                    ),
                    icon: const Icon(Icons.task_alt),
                    label: const Text('View Quests'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Text(
              'Core Attributes Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            
            // Attribute Grid Cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: AttributeType.values.length,
              itemBuilder: (context, index) {
                final attr = AttributeType.values[index];
                final matchingSkills = userSkills
                    .where((s) => s.attribute == attr)
                    .toList();

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          attr.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${matchingSkills.length} Skills Registered',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          matchingSkills.any((s) => s.verified)
                              ? 'Verified Source'
                              : 'Unverified',
                          style: TextStyle(
                            fontSize: 12,
                            color: matchingSkills.any((s) => s.verified)
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}