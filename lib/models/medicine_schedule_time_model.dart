class MedicineScheduleTimeModel {
  final int id;
  final String time;

  const MedicineScheduleTimeModel({required this.id, required this.time});

  factory MedicineScheduleTimeModel.fromJson(Map<String, dynamic> json) {
    return MedicineScheduleTimeModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      time:
          json['reminder_time']?.toString() ??
          json['scheduled_time']?.toString() ??
          json['time']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'reminder_time': time};
  }
}
