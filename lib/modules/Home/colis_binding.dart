import 'package:get/get.dart';

import 'colis.controller.dart';



class ColisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ColisController>(() => ColisController());
  }
}