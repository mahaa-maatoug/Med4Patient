import 'dart:io';

import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'Ordonnance.dart';
import 'OrdonnanceService.dart';


class OrdonnanceController extends GetxController {
  final OrdonnanceService _ordonnanceService = Get.put(OrdonnanceService());

  var ordonnances = <Ordonnance>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedFiles = <File>[].obs;
  var currentStatus = PrescriptionStatus.UPLOADED.obs;
  var startDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var endDate = DateTime.now().obs;
  var showAllPrescriptions = true.obs;
  @override
  void onInit() {
    fetchOrdonnances();
    super.onInit();
  }
  void toggleViewMode() {
    showAllPrescriptions.value = !showAllPrescriptions.value;
  }
  Future<void> fetchOrdonnances() async {
    try {
      isLoading(true);
      errorMessage('');
      final List<Ordonnance> result = await _ordonnanceService.getAllOrdonnances();
      ordonnances.assignAll(result);
    } catch (e) {
      errorMessage('Failed to load ordonnances: $e');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        if (result.files.length + selectedFiles.length > 5) {
          Get.snackbar('Limit Exceeded', 'You can upload maximum 5 files');
          return;
        }

        selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e');
    }
  }

  void removeFile(File file) {
    selectedFiles.remove(file);
  }

  Future<void> createAndUploadOrdonnance({

    String? note,
  }) async {
    try {
      if (selectedFiles.isEmpty) {
        Get.snackbar('Error', 'Please select at least one file');
        return;
      }

      isLoading(true);

      final newOrdonnance = await _ordonnanceService.createOrdonnanceWithFiles(

        files: selectedFiles,
        note: note,
      );

      ordonnances.add(newOrdonnance);
      selectedFiles.clear();
      Get.back();
      Get.snackbar('Success', 'Prescription uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Upload failed: ${e.toString()}');
      print('Error details: $e');
    } finally {
      isLoading(false);
    }
  }
  Future<void> updateOrdonnance({
    required String id,

    String? note,
    PrescriptionStatus? prescriptionStatus,
  }) async {
    try {
      isLoading(true);
      await _ordonnanceService.updateOrdonnance(
        id: id,

        note: note,
        prescriptionStatus: prescriptionStatus,
      );
      await fetchOrdonnances(); // Refresh the list
      Get.snackbar('Success', 'Prescription updated successfully');
    } catch (e) {
      errorMessage('Failed to update prescription: $e');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteOrdonnance(String id) async {
    try {
      isLoading(true);
      await _ordonnanceService.deleteOrdonnance(id);
      ordonnances.removeWhere((ordonnance) => ordonnance.id == id);
      Get.snackbar('Success', 'Prescription deleted successfully');
    } catch (e) {
      errorMessage('Failed to delete prescription: $e');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  // Helper to get status display name
  String getStatusDisplay(PrescriptionStatus status) {
    return status.toString().split('.').last;
  }
  Future<void> fetchOrdonnancesByDate() async {
    try {
      isLoading(true);
      errorMessage('');
      final List<Ordonnance> result = await _ordonnanceService.getPrescriptionHistory(
        startDate: startDate.value,
        endDate: endDate.value,
      );
      ordonnances.assignAll(result);
    } catch (e) {
      errorMessage('Failed to load ordonnances: $e');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}