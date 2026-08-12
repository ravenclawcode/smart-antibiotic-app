class PreferenceModel {
  final String reminderType;
  final String reminderSound;
  final String timezone;

  const PreferenceModel({
    required this.reminderType,
    required this.reminderSound,
    required this.timezone,
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      reminderType: json['reminder_type']?.toString() ?? '',
      reminderSound: json['reminder_sound']?.toString() ?? '',
      timezone: json['timezone']?.toString() ?? 'Asia/Jakarta',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminder_type': reminderType,
      'reminder_sound': reminderSound,
      'timezone': timezone,
    };
  }
}
