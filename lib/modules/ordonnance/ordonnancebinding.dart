import 'package:get/get.dart';

import 'OrdonnanceController.dart';
import 'OrdonnanceService.dart';


class OrdonnanceBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => OrdonnanceController());
  }
}