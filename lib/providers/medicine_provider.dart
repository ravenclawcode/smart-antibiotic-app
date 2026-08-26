import 'package:flutter/foundation.dart';

import '../core/error/api_exception.dart';
import '../models/medicine_model.dart';
import '../services/medicine_service.dart';
import '../services/notification_service.dart';

class MedicineProvider extends ChangeNotifier {
  final MedicineService medicineService;

  MedicineProvider({required this.medicineService});

  bool _isLoading = false;
  bool _isSaving = false;

  String? _errorMessage;

  List<MedicineModel> _medicines = [];

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  List<MedicineModel> get medicines => List.unmodifiable(_medicines);

  Future<bool> loadMedicines() async {
    if (_isLoading) {
      return false;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _medicines = await medicineService.getMedicines();

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal mengambil data obat.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MedicineModel?> createMedicine(MedicineModel medicine) async {
    if (_isSaving) {
      return null;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final createdMedicine = await medicineService.createMedicine(medicine);

      await NotificationService.instance.scheduleMedicineNotifications(
        medicine: createdMedicine,
      );

      _medicines.add(createdMedicine);

      return createdMedicine;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (_) {
      _errorMessage = 'Gagal menyimpan obat.';
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<MedicineModel?> getMedicine(int id) async {
    if (_isLoading) {
      return null;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      return await medicineService.getMedicine(id);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (_) {
      _errorMessage = 'Gagal mengambil detail obat.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<MedicineModel?> updateMedicine(int id, MedicineModel medicine) async {
    if (_isSaving) {
      return null;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final updatedMedicine = await medicineService.updateMedicine(
        id,
        medicine,
      );

      await NotificationService.instance.cancelMedicineNotifications(id);

      await NotificationService.instance.scheduleMedicineNotifications(
        medicine: updatedMedicine,
      );

      final index = _medicines.indexWhere((item) => item.id == id);

      if (index != -1) {
        _medicines[index] = updatedMedicine;
      }

      return updatedMedicine;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (_) {
      _errorMessage = 'Gagal memperbarui obat.';
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteMedicine(int id) async {
    if (_isSaving) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await medicineService.deleteMedicine(id);

      await NotificationService.instance.cancelMedicineNotifications(id);

      _medicines.removeWhere((item) => item.id == id);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal menghapus obat.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteMedicinePermanent(int id) async {
    if (_isSaving) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await medicineService.deleteMedicinePermanent(id);

      await NotificationService.instance.cancelMedicineNotifications(id);

      _medicines.removeWhere((item) => item.id == id);

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal menghapus obat secara permanen.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }

    _errorMessage = null;

    notifyListeners();
  }

  Future<bool> deleteDose({
    required int medicineId,
    required int scheduleTimeId,
    required String scheduledDate,
  }) async {
    if (_isSaving) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await medicineService.deleteDose(
        medicineId: medicineId,
        scheduleTimeId: scheduleTimeId,
        scheduledDate: scheduledDate,
      );

      final medicine = _medicines.firstWhere(
        (item) => item.id == medicineId,
        orElse: () => throw Exception('Medicine $medicineId tidak ditemukan.'),
      );

      final date = DateTime.parse(scheduledDate);

      await NotificationService.instance.cancelMedicineDoseByDate(
        medicine: medicine,
        scheduleTimeId: scheduleTimeId,
        scheduledDate: date,
      );

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal menghapus dosis.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateDose({
    required int medicineId,
    required int scheduleTimeId,
    required String scheduledDate,
    required String dosage,
    required String dosageUnit,
    required String instruction,
  }) async {
    if (_isSaving) {
      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await medicineService.updateDose(
        medicineId: medicineId,
        scheduleTimeId: scheduleTimeId,
        scheduledDate: scheduledDate,
        dosage: dosage,
        dosageUnit: dosageUnit,
        instruction: instruction,
      );

      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (_) {
      _errorMessage = 'Gagal memperbarui dosis.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
