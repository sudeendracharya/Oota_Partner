import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../colors.dart';
import '../../main.dart';

class Authenticate with ChangeNotifier {
  // var baseUrl = 'https://ootaonline.herokuapp.com/';

  var _token;
  var _profileId;

  List _authenticateException = [];

  List get authenticateException {
    return _authenticateException;
  }

  bool get isAuth {
    return _token != null;
  }

  bool get isProfile {
    return _profileId != null;
  }

  get token {
    return _token;
  }

  void commonException(String error) {
    EasyLoading.dismiss();

    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue.withOpacity(0.5),
      message: error,
      title: 'Failed',
    ));
  }

  Future<int> signUp(var data) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/registration/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body);

        EasyLoading.dismiss();
        Get.defaultDialog(
          title: 'Alert',
          middleText: responseData['email'][0] ??
              'Something Went Wrong please try With Different Account',
          confirm: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'ok',
              style: TextStyle(color: ProjectColors.themeColor),
            ),
          ),
        );
      }

      // print(response.statusCode);
      // print(response.body);

      return response.statusCode;
    } catch (e) {
      commonException(e.toString());

      rethrow;
    }
  }

  Future<Map<String, dynamic>> logIn(var data) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/login/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _token = responseData['key'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
          },
        );
        prefs.setString('userData', userData);
        return {'StatusCode': response.statusCode, 'Body': ''};
      } else if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        _authenticateException.clear();
        // print(responseData);
        List temp = [];
        responseData.forEach((key, value) {
          temp.add({'key': key, 'value': value});
        });
        // print(temp);
        _authenticateException = temp;
        notifyListeners();
        return {
          'StatusCode': response.statusCode,
          'Body': responseData['non_field_errors']
        };
      } else {
        var responseData = json.decode(response.body);
        return {'StatusCode': response.statusCode, 'Body': responseData};
      }
    } catch (e) {
      commonException(e.toString());

      rethrow;
    }
  }

  Future<int> forgetPassword(var data) async {
    final url = Uri.parse('${baseUrl}api/v1/rest-auth/login/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json.encode(data),
      );

      return response.statusCode;
    } catch (e) {
      commonException(e.toString());

      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    // logout();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    // final expiryDate =
    //     DateTime.parse(extratedUserData['expiryDate'].toString());

    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }
    if (extratedUserData["token"] == null) {
      return false;
    }
    _token = extratedUserData["token"];

    notifyListeners();
    // _autoLogOut();
    return true;
  }

  Future<void> logout() async {
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      prefs.remove('userData');
    }
    if (prefs.containsKey('profile')) {
      prefs.remove('profile');
    }

    notifyListeners();
  }

  Future<bool> fetchProfileDetails() async {
    final url = Uri.parse('${baseUrl}business/profile-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $_token'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        if (responseData.isNotEmpty) {
          _profileId = responseData;
          notifyListeners();
          return true;
        } else {
          _profileId = null;

          return false;
        }
      } else {
        _profileId = null;

        return false;
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }
}
