import 'package:flutter/material.dart';
import '../repositories/ai_repository.dart';

class AIProvider extends ChangeNotifier {
  final AIRepository _aiRepository = AIRepository();

  bool _isLoading = false;
  String? _lastResult;
  List<double>? _lastEmbeddings;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get lastResult => _lastResult;
  List<double>? get lastEmbeddings => _lastEmbeddings;
  String? get errorMessage => _errorMessage;

  Future<bool> submitQuery(String prompt) async {
    _isLoading = true;
    _errorMessage = null;
    _lastResult = null;
    _lastEmbeddings = null;
    notifyListeners();

    try {
      final response = await _aiRepository.sendAiQuery(prompt);
      _lastResult = response.result;
      _lastEmbeddings = response.embeddings;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}