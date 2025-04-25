
import 'package:get/get.dart';
import 'order_service.dart';
class OrderController extends GetxController {
  final OrderService orderService = OrderService();

  var orders = [].obs;
  var isLoading = false.obs;

  Future<void> fetchPatientOrders(String patientId) async {
    isLoading.value = true;
    final result = await orderService.getPatientOrders(patientId);
    orders.assignAll(result);
    isLoading.value = false;
  }
}