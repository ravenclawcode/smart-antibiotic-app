import 'package:smart_antibiotic/models/medicine_model.dart';
import 'package:smart_antibiotic/services/notification_service.dart';

class MedicineReminderService {
  MedicineReminderService._();

  static final MedicineReminderService instance = MedicineReminderService._();

  final NotificationService _notificationService = NotificationService.instance;

  Future<void> scheduleMedicine(
    MedicineModel medicine, {
    int preReminderMinutes = 30,
  }) async {
    await _notificationService.scheduleMedicineNotifications(
      medicine: medicine,
      preReminderMinutes: preReminderMinutes,
    );
  }

  Future<void> cancelMedicine(int medicineId) async {
    await _notificationService.cancelMedicineNotifications(medicineId);
  }

  Future<void> cancelDose({
    required int medicineId,
    required int scheduleTimeId,
    required int occurrenceIndex,
  }) async {
    await _notificationService.cancelMedicineDose(
      medicineId: medicineId,
      scheduleTimeId: scheduleTimeId,
      occurrenceIndex: occurrenceIndex,
    );
  }
}
