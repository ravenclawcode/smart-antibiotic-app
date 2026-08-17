class MedicineModel {
  final int? id;
  final String name;
  final String? dosage;
  final String? dosageUnit;
  final String? instruction;
  final String? startDate;
  final String? endDate;
  final bool isActive;

  final String frequencyType;
  final int timesPerDay;
  final int? intervalValue;

  final List<int> days;

  final List<int> dates;

  final List<String> times;

  const MedicineModel({
    this.id,
    required this.name,
    this.dosage,
    this.dosageUnit,
    this.instruction,
    this.startDate,
    this.endDate,
    this.isActive = true,
    required this.frequencyType,
    this.timesPerDay = 1,
    this.intervalValue,
    this.days = const [],
    this.dates = const [],
    required this.times,
  });

  MedicineModel copyWith({
    int? id,
    String? name,
    String? dosage,
    String? dosageUnit,
    String? instruction,
    String? startDate,
    String? endDate,
    bool? isActive,
    String? frequencyType,
    int? timesPerDay,
    int? intervalValue,
    List<int>? days,
    List<int>? dates,
    List<String>? times,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      instruction: instruction ?? this.instruction,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      frequencyType: frequencyType ?? this.frequencyType,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      intervalValue: intervalValue ?? this.intervalValue,
      days: days ?? this.days,
      dates: dates ?? this.dates,
      times: times ?? this.times,
    );
  }

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    final schedule = json['schedule'] is Map
        ? Map<String, dynamic>.from(json['schedule'])
        : <String, dynamic>{};

    final frequencyType =
        schedule['frequency_type']?.toString() ??
        json['frequency_type']?.toString() ??
        '';

    final rawSelections =
        schedule['selections'] ?? schedule['days'] ?? json['days'];

    final rawDates = schedule['dates'] ?? json['dates'];

    return MedicineModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,

      name: json['name']?.toString() ?? '',

      dosage: json['dosage']?.toString(),

      dosageUnit: json['dosage_unit']?.toString(),

      instruction: json['instruction']?.toString(),

      startDate: json['start_date']?.toString(),

      endDate: json['end_date']?.toString(),

      isActive:
          json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active']?.toString() == '1',

      frequencyType: frequencyType,

      timesPerDay:
          int.tryParse(
            (schedule['times_per_day'] ?? json['times_per_day'] ?? 1)
                .toString(),
          ) ??
          1,

      intervalValue: schedule['interval_value'] != null
          ? int.tryParse(schedule['interval_value'].toString())
          : json['interval_value'] != null
          ? int.tryParse(json['interval_value'].toString())
          : null,

      days: _parseIntList(rawSelections),

      dates: _parseIntList(rawDates),

      times: _parseStringList(schedule['times'] ?? json['times']),
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'name': name,
      'dosage': dosage,
      'dosage_unit': dosageUnit,
      'instruction': instruction,
      'start_date': startDate,
      'end_date': endDate,

      'frequency_type': frequencyType,
      'times_per_day': frequencyType == 'daily' ? timesPerDay : null,

      'interval_value':
          frequencyType == 'interval_days' ||
              frequencyType == 'interval_weeks' ||
              frequencyType == 'interval_months'
          ? intervalValue
          : null,

      'days':
          frequencyType == 'certain_days' || frequencyType == 'interval_weeks'
          ? days
          : [],

      'dates': frequencyType == 'interval_months' ? dates : [],

      'times': times,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'dosage_unit': dosageUnit,
      'instruction': instruction,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive,
      'frequency_type': frequencyType,
      'times_per_day': timesPerDay,
      'interval_value': intervalValue,
      'days': days,
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

    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }

    return [];
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return value.split(',').map((e) => e.trim()).toList();
    }

    return [];
  }
}
