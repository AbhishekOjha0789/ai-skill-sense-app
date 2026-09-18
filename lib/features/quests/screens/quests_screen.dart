import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quest_provider.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuestProvider>(context, listen: false).loadQuests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final questProvider = Provider.of<QuestProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Life Quests & Tasks')),
      body: questProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : questProvider.quests.isEmpty
              ? const Center(child: Text('No active quests assigned.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: questProvider.quests.length,
                  itemBuilder: (context, index) {
                    final uQuest = questProvider.quests[index];
                    final quest = uQuest.quest;
                    final isCompleted = uQuest.status == 'COMPLETED';

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          quest?.title ?? 'Unknown Quest',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(quest?.description ?? ''),
                            const SizedBox(height: 8),
                            Chip(
                              label: Text('+${quest?.xpReward ?? 50} XP (${quest?.attribute.name.toUpperCase()})'),
                              backgroundColor: Colors.amber.shade100,
                            ),
                          ],
                        ),
                        trailing: isCompleted
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : ElevatedButton(
                                onPressed: () async {
                                  await questProvider.markQuestCompleted(uQuest.id);
                                },
                                child: const Text('Complete'),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}