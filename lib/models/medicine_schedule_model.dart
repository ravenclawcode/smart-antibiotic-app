class MedicineScheduleModel {
  final String frequencyType;
  final int timesPerDay;
  final int? intervalValue;
  final List<int> selections;
  final List<int> dates;
  final List<String> times;

  const MedicineScheduleModel({
    required this.frequencyType,
    required this.timesPerDay,
    this.intervalValue,
    this.selections = const [],
    this.dates = const [],
    this.times = const [],
  });

  factory MedicineScheduleModel.fromJson(Map<String, dynamic> json) {
    return MedicineScheduleModel(
      frequencyType: json['frequency_type']?.toString() ?? '',

      timesPerDay: int.tryParse(json['times_per_day']?.toString() ?? '') ?? 1,

      intervalValue: json['interval_value'] != null
          ? int.tryParse(json['interval_value'].toString())
          : null,

      selections: _parseIntList(json['selections']),

      dates: _parseIntList(json['dates']),

      times: _parseStringList(json['times']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency_type': frequencyType,
      'times_per_day': timesPerDay,
      'interval_value': intervalValue,
      'selections': selections,
      'dates': dates,
      'times': times,
    };
  }

  static List<int> _parseIntList(dynamic value) {
    if (value is List) {
      return value
          .map((e) => int.tryParse(e.toString()))
          .whereType<int>()
          .toList();
    }

    return [];
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    return [];
  }
}
