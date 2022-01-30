import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:prayer_buddy/model/users_model.dart';
import 'package:prayer_buddy/services/api.dart';

class UsersController extends GetxController {
  UsersController get getXID => Get.find<UsersController>();
  ScrollController usersScrollController = ScrollController();
  var page_num = 1;
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;

  var usersList = <Users>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  getUsers(var user_id) async {
    var seeker = await ApiServices.getUsers(page_num, user_id);
    if (seeker != null) {
      isDataProcessing(true);
      usersList.value = seeker;
    }
  }

  void paginationTask(var user_id) {
    usersScrollController.addListener(() {
      if (usersScrollController.position.pixels ==
          usersScrollController.position.maxScrollExtent) {
        page_num++;
        getItinerarMore(page_num, user_id);
      }
    });
  }

  void getItinerarMore(var page_num, var user_id) async {
    var seeker = await ApiServices.getUsers(page_num, user_id);

    if (seeker != null) {
      isMoreDataAvailable(true);
      usersList.addAll(seeker);
    } else {
      isMoreDataAvailable(false);
      showSnackBar('Oops!', "No more items", Colors.red);
    }

    if (isMoreDataAvailable == false) {
      showSnackBar('Oops!', "No more items", Colors.red);
    }
  }

  showSnackBar(String title, String msg, Color backgroundColor) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
    );
  }
}
