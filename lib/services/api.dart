import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:prayer_buddy/model/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  static var client = http.Client();
  static String _mybaseUrl = 'https://arome.joons-me.com/Api/';
  static String _send_message = 'send_private_message';
  static String _login_authorization = 'login_authorization';
  static String _signup_authorization = 'signup_authorization';
  static String _reset_password = 'reset_password';
  static String _live_stream_status = 'get_live_streaming_status';
  static String _live_stream_link = 'get_live_streaming_link';
  static String _has_new_update = 'has_new_update';
  static String _ios_store_link = 'ios_store_link';
  static String _android_store_link = 'android_store_link';
  static String _get_users = 'get_users';

  static Future<bool> submitMessage(var email, var name, var msg) async {
    final uri = Uri.parse('$_mybaseUrl$_send_message');

    var response = await http.post(uri, body: {
      'message': msg,
      'email': email,
      'name': name,
    });

    var body = response.body;

    final j = json.decode(body) as Map<String, dynamic>;
    bool status = j['status'];
    return status;
  }

  static Future<String> userAuthLogin(String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uri = Uri.parse('$_mybaseUrl$_login_authorization');

    var response = await http.post(uri, body: {
      'email': email,
      'password': pass,
    });

    Map<String, dynamic> j = json.decode(response.body);
    String status = j['status'];
    String status_msg = j['status_msg'];

    if (status == 'success') {
      String user_id = j['user_id'];
      String full_name = j['full_name'];
      String age = j['age'];
      String sex = j['sex'];
      String emailAddres = j['email'];
      String phone_no = j['phone_no'];
      String user_img = j['user_img'];
      String user_name = j['user_name'];
      String is_profile_updated = j['is_profile_updated'];

      prefs.setString('user_id', user_id);
      prefs.setString('full_name', full_name);
      prefs.setString('age', age);
      prefs.setString('sex', sex);
      prefs.setString('email', emailAddres);
      prefs.setString('phone_no', phone_no);
      prefs.setString('user_img', user_img);
      prefs.setBool('isUserLogin', true);
      prefs.setString('profile_updated', is_profile_updated);
      prefs.setString('user_name', user_name);

      return status;
    } else if (status == 'fail_01' ||
        status == 'fail_02' ||
        status == 'fail_03' ||
        status == 'fail_04') {
      return status;
    }
    return "fail";
  }

  static Future<String> userAuthSignup(
      String email, String pass, String user_name, String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uri = Uri.parse('$_mybaseUrl$_signup_authorization');

    var response = await http.post(uri, body: {
      'email': email,
      'password': pass,
      'user_name': user_name,
      'gender': gender,
    });

    Map<String, dynamic> j = json.decode(response.body);
    String status = j['status'];
    String status_msg = j['status_msg'];

    if (status == 'success') {
      String user_id = j['user_id'];
      String full_name = j['full_name'];
      String age = j['age'];
      String sex = j['sex'];
      String emailAddres = j['email'];
      String phone_no = j['phone_no'];
      String user_img = j['user_img'];
      String user_name = j['user_name'];
      String is_profile_updated = j['is_profile_updated'];

      prefs.setString('user_id', user_id);
      prefs.setString('full_name', full_name);
      prefs.setString('age', age);
      prefs.setString('sex', sex);
      prefs.setString('email', emailAddres);
      prefs.setString('phone_no', phone_no);
      prefs.setString('user_img', user_img);
      prefs.setBool('isUserLogin', true);
      prefs.setString('profile_updated', is_profile_updated);
      prefs.setString('user_name', user_name);

      return status;
    } else if (status == 'fail_01' ||
        status == 'fail_02' ||
        status == 'fail_03' ||
        status == 'fail_04' ||
        status == 'fail_05') {
      return status;
    }
    return "fail";
  }

  static Future<String> userAuthRest(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uri = Uri.parse('$_mybaseUrl$_reset_password');

    var response = await http.post(uri, body: {
      'email': email,
    });

    Map<String, dynamic> j = json.decode(response.body);
    String status = j['status'];

    if (status == 'success') {
      return status;
    } else if (status == 'fail_01' ||
        status == 'fail_02' ||
        status == 'fail_03' ||
        status == 'fail_04') {
      return status;
    }

    return "fail";
  }

  static Future<bool> updateUserProfile(String name, String age, String phone,
      File profileImg, String sex, String my_id, var user_name) async {
    final uri = Uri.parse('$_mybaseUrl/update_profile/$my_id');
    var request = http.MultipartRequest('POST', uri);
    request.fields['full_name'] = name;
    request.fields['age'] = age;
    request.fields['phone'] = phone;
    request.fields['sex'] = sex;

    var profileImage =
        await http.MultipartFile.fromPath('profile_image', profileImg.path);
    request.files.add(profileImage);

    var respond = await request.send();
    if (respond.statusCode == 200) {
      var new_user_img = 'https://rcnapp.one/user_img/$user_name' +
          '/images/' +
          profileImage.filename!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('full_name', name);
      prefs.setString('age', age);
      prefs.setString('sex', sex);
      prefs.setString('phone_no', phone);
      prefs.setString('user_img', new_user_img);
      prefs.setString('profile_updated', "true");
      return true;
    } else {
      return false;
    }
  }

  static Future<String> get_live_status() async {
    final response =
        await http.get(Uri.parse('$_mybaseUrl$_live_stream_status'));
    var body = response.body;
    final j = json.decode(body) as Map<String, dynamic>;
    String status = j['status'];
    return status;
  }

  static Future<String> get_live_link() async {
    final response = await http.get(Uri.parse('$_mybaseUrl$_live_stream_link'));
    var body = response.body;
    final j = json.decode(body) as Map<String, dynamic>;
    String status = j['status'];
    return status;
  }

  static Future<int> isAppHasNewUpdate() async {
    final response = await http.get(Uri.parse('$_mybaseUrl$_has_new_update/'));

    Map<String, dynamic> j = json.decode(response.body);
    int counter = j['counter'];
    return counter;
  }

  static Future<String> iosStoreLink() async {
    final response = await http.get(Uri.parse('$_mybaseUrl$_ios_store_link/'));

    Map<String, dynamic> j = json.decode(response.body);
    String counter = j['link'];
    return counter;
  }

  static Future<String> androidStoreLink() async {
    final response =
        await http.get(Uri.parse('$_mybaseUrl$_android_store_link/'));

    Map<String, dynamic> j = json.decode(response.body);
    String counter = j['link'];
    return counter;
  }

  Future<bool> deleteMyAccount(my_id) async {
    final response =
        await http.get(Uri.parse('$_mybaseUrl/delete_account/$my_id'));

    Map<String, dynamic> j = json.decode(response.body);
    bool checker = j['status'];
    // return true;
    return checker;
  }

  static Future<List<Users>> getUsers(var page_num, var user_id) async {
    try {
      final result = await client
          .get(Uri.parse('$_mybaseUrl$_get_users/$page_num/$user_id'));
      // print(result.body);
      if (result.statusCode == 200) {
        final itinerary = usersFromJson(result.body);
        return itinerary;
      } else {
        return Future.error('Unwanted status Code');
      }
    } catch (ex) {
      return Future.error(ex.toString());
    }
  }
}
