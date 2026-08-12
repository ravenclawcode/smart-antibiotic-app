class OnboardingModel {
  final String uuid;
  final String name;
  final String reminderType;
  final String reminderSound;
  final String timezone;

  const OnboardingModel({
    required this.uuid,
    required this.name,
    required this.reminderType,
    required this.reminderSound,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'reminder_type': reminderType,
      'reminder_sound': reminderSound,
      'timezone': timezone,
    };
  }
}
