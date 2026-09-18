import 'package:flutter/material.dart';
import '../../shared/models/quest_model.dart';
import '../repositories/quest_repository.dart';

class QuestProvider extends ChangeNotifier {
  final QuestRepository _questRepository = QuestRepository();

  List<UserQuest> _quests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserQuest> get quests => _quests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadQuests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _quests = await _questRepository.fetchUserQuests();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markQuestCompleted(String userQuestId) async {
    try {
      await _questRepository.completeQuest(userQuestId);
      // Update local state status
      _quests = _quests.map((q) {
        if (q.id == userQuestId) {
          return UserQuest(
            id: q.id,
            userId: q.userId,
            questId: q.questId,
            quest: q.quest,
            status: 'COMPLETED',
            createdAt: q.createdAt,
          );
        }
        return q;
      }).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}