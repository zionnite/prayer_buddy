import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:prayer_buddy/model/call_request_model.dart';

class HandlerCallController extends GetxController {
  HandlerCallController get getXID => Get.find<HandlerCallController>();

  var callRequest = <CallRequestModel>[].obs;
}
