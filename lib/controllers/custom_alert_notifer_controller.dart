import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:prayer_buddy/model/custom_alert_notifier_model.dart';

class CustomAlertNotifierController extends GetxController {
  CustomAlertNotifierController get getXID =>
      Get.find<CustomAlertNotifierController>();

  var alert = <CustomAlertNotifierModel>[].obs;
  var user_online_status = false.obs;

  // add(data) async {
  //   addCustomAlertNotifier.clear();
  //   addCustomAlertNotifier(data);
  // }
}
