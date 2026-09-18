enum AttributeType {
  cognitive,
  physical,
  emotional,
  technical,
  creative,
  financial;

  static AttributeType fromString(String value) {
    return AttributeType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => AttributeType.technical,
    );
  }

  String get toJsonString => name.toUpperCase();
}