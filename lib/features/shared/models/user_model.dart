import 'attribute_type.dart';
import 'quest_model.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? webhookSecret;
  final List<Skill> skills;
  final List<UserQuest> quests;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.webhookSecret,
    required this.skills,
    required this.quests,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      webhookSecret: json['webhookSecret'],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e))
              .toList() ??
          [],
      quests: (json['quests'] as List<dynamic>?)
              ?.map((e) => UserQuest.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'webhookSecret': webhookSecret,
      'skills': skills.map((e) => e.toJson()).toList(),
      'quests': quests.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Skill {
  final String id;
  final String name;
  final String? description;
  final AttributeType attribute;
  final String userId;
  final List<double>? embedding; // 384-dimensional vector representation
  final bool verified;
  final String? sourceDocId;
  final List<UserSkillProgress> progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Skill({
    required this.id,
    required this.name,
    this.description,
    required this.attribute,
    required this.userId,
    this.embedding,
    required this.verified,
    this.sourceDocId,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      attribute: AttributeType.fromString(json['attribute'] ?? 'TECHNICAL'),
      userId: json['userId'] ?? '',
      embedding: (json['embedding'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      verified: json['verified'] ?? false,
      sourceDocId: json['sourceDocId'],
      progress: (json['progress'] as List<dynamic>?)
              ?.map((e) => UserSkillProgress.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'attribute': attribute.toJsonString,
      'userId': userId,
      'embedding': embedding,
      'verified': verified,
      'sourceDocId': sourceDocId,
      'progress': progress.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UserSkillProgress {
  final String id;
  final String skillId;
  final int level;
  final int xp;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSkillProgress({
    required this.id,
    required this.skillId,
    required this.level,
    required this.xp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSkillProgress.fromJson(Map<String, dynamic> json) {
    return UserSkillProgress(
      id: json['id'] ?? '',
      skillId: json['skillId'] ?? '',
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skillId': skillId,
      'level': level,
      'xp': xp,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}