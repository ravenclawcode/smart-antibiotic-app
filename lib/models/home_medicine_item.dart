import 'medicine_model.dart';

class HomeMedicineItem {
  final int medicineId;
  final int scheduleTimeId;
  final String scheduledDate;
  final String name;
  final String dosage;
  final String time;
  final String? instruction;
  final String status;
  final String? takenAt;
  final String? skippedAt;
  final String? notes;
  final String? rescheduledTime;
  final MedicineModel medicine;

  const HomeMedicineItem({
    required this.medicineId,
    required this.scheduleTimeId,
    required this.scheduledDate,
    required this.name,
    required this.dosage,
    required this.time,
    required this.status,
    required this.medicine,
    this.instruction,
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
