class HomeMedicineItem {
  final int medicineId;
  final int scheduleTimeId;
  final String name;
  final String dosage;
  final String time;
  final String? instruction;
  final String status;
  final String? takenAt;
  final String? skippedAt;
  final String? notes;
  final String? rescheduledTime;

  const HomeMedicineItem({
    required this.medicineId,
    required this.scheduleTimeId,
    required this.name,
    required this.dosage,
    required this.time,
    this.instruction,
    required this.status,
    this.takenAt,
    this.skippedAt,
    this.notes,
    this.rescheduledTime,
  });

  bool get isTaken => status == 'taken';
  bool get isSkipped => status == 'skipped';
  bool get isMissed => status == 'missed';
  bool get isRescheduled => status == 'rescheduled';
}
