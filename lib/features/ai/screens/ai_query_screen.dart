import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';

class AIQueryScreen extends StatefulWidget {
  const AIQueryScreen({super.key});

  @override
  State<AIQueryScreen> createState() => _AIQueryScreenState();
}

class _AIQueryScreenState extends State<AIQueryScreen> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _submitPrompt() async {
    if (_promptController.text.trim().isEmpty) return;

    final aiProvider = Provider.of<AIProvider>(context, listen: false);
    final success = await aiProvider.submitQuery(_promptController.text.trim());

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(aiProvider.errorMessage ?? 'Query failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Skill & Capability Evaluator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Enter skill or capability prompt...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            aiProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _submitPrompt,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Run Semantic Evaluation'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Evaluation Output:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        if (aiProvider.lastResult != null) ...[
                          Text(aiProvider.lastResult!),
                          const SizedBox(height: 16),
                          Text(
                            'Generated Embeddings Dimensions: ${aiProvider.lastEmbeddings?.length ?? 0}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 12),
                          ),
                        ] else ...[
                          Text(
                            'Results will appear here after evaluation...',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}