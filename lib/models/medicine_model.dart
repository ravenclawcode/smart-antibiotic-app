import 'package:smart_antibiotic/models/medicine_schedule_time_model.dart';

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

  final List<MedicineScheduleTimeModel> scheduleTimes;

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
    this.times = const [],
    this.scheduleTimes = const [],
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
    List<MedicineScheduleTimeModel>? scheduleTimes,
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
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
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

    final rawTimes =
        schedule['times'] ??
        schedule['schedule_times'] ??
        json['times'] ??
        json['schedule_times'];

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

      times: _parseTimes(rawTimes),

      scheduleTimes: _parseScheduleTimes(rawTimes),
    );
  }

  static List<String> _parseTimes(dynamic value) {
    if (value is List) {
      return value
          .map((item) {
            String time = '';

            if (item is Map) {
              time =
                  item['reminder_time']?.toString() ??
                  item['scheduled_time']?.toString() ??
                  item['time']?.toString() ??
                  '';
            } else {
              time = item.toString();
            }

            return _formatTime(time);
          })
          .where((time) => time.isNotEmpty)
          .toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((time) => _formatTime(time.trim()))
          .where((time) => time.isNotEmpty)
          .toList();
    }

    return [];
  }

  static String _formatTime(String value) {
    if (value.length >= 5) {
      return value.substring(0, 5);
    }

    return value;
  }

  static List<MedicineScheduleTimeModel> _parseScheduleTimes(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => MedicineScheduleTimeModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    return [];
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

      'schedule_times': scheduleTimes.map((e) => e.toJson()).toList(),
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
}
