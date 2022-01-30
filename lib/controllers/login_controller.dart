import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:prayer_buddy/services/api.dart';

class LoginController extends GetxController {
  LoginController get getXID => Get.find<LoginController>();
  var isDataProcessing = false.obs;

  Future<String> signup(
      var user_name, var email, var password, var gender) async {
    var seeker =
        await ApiServices.userAuthSignup(email, password, user_name, gender);
    return seeker;
  }

  Future<String> login(var email, var password) async {
    var seeker = await ApiServices.userAuthLogin(email, password);
    return seeker;
  }

  Future<String> reset(email) async {
    var seeker = await ApiServices.userAuthRest(email);
    return seeker;
  }

  Future<bool> updateProfile(var name, var phone, var age, var sex,
      var profileImg, var user_id, var user_name) async {
    var seeker = await ApiServices.updateUserProfile(
        name, age, phone, profileImg, sex, user_id, user_name);
    return seeker;
  }

  //
}
