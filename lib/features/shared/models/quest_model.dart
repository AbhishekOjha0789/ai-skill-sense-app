import 'attribute_type.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final AttributeType attribute;
  final int xpReward;
  final DateTime createdAt;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.attribute,
    required this.xpReward,
    required this.createdAt,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      attribute: AttributeType.fromString(json['attribute'] ?? 'TECHNICAL'),
      xpReward: json['xpReward'] ?? 50,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'attribute': attribute.toJsonString,
      'xpReward': xpReward,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserQuest {
  final String id;
  final String userId;
  final String questId;
  final Quest? quest;
  final String status; // PENDING, COMPLETED
  final DateTime createdAt;

  UserQuest({
    required this.id,
    required this.userId,
    required this.questId,
    this.quest,
    required this.status,
    required this.createdAt,
  });

  factory UserQuest.fromJson(Map<String, dynamic> json) {
    return UserQuest(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      questId: json['questId'] ?? '',
      quest: json['quest'] != null ? Quest.fromJson(json['quest']) : null,
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'questId': questId,
      'quest': quest?.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}