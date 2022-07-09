import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
// import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class ApiCalls with ChangeNotifier {
  List _menuList = [];

  List _profileDetails = [];

  List _businessHours = [];

  Map<String, dynamic> _user = {};

  Map<String, dynamic> _bankPaymentDetails = {};

  Map<String, dynamic> _bPayDetails = {};

  List _newOrdersList = [];

  var _updatedOrderList;

  List _preparingOrdersList = [];

  List _dispatchedOrdersList = [];

  List _allOrderHistory = [];

  List _cuisinesCategoryList = [];

  List _businessCategoryList = [];

  Map<String, dynamic> _orderDetails = {};

  List _couponList = [];

  List _generalException = [];

  List get couponList {
    return _couponList;
  }

  Map<String, dynamic> get orderDetails {
    return _orderDetails;
  }

  List get businessCategoryList {
    return _businessCategoryList;
  }

  List get generalException {
    return _generalException;
  }

  List get allOrderHistory {
    return _allOrderHistory;
  }

  List get cuisinesCategoryList {
    return _cuisinesCategoryList;
  }

  List get dispatchedOrdersList {
    return _dispatchedOrdersList;
  }

  List get preparingOrdersList {
    return _preparingOrdersList;
  }

  List get newOrdersList {
    return _newOrdersList;
  }

  Map<String, dynamic> get bPayDetails {
    return _bPayDetails;
  }

  Map<String, dynamic> get bankPaymentDetails {
    return _bankPaymentDetails;
  }

  Map<String, dynamic> get user {
    return _user;
  }

  List get businessHours {
    return _businessHours;
  }

  List get profileDetails {
    return _profileDetails;
  }

  List get menuList {
    return _menuList;
  }

  // var baseUrl = 'https://ootaonline.herokuapp.com/';

  void exception(var response) {
    var responseData = json.decode(response.body) as Map<String, dynamic>;
    // print(responseData.values.first);

    List temp = [];

    responseData.forEach((key, value) {
      temp.add({
        'heading': key,
        'value': value,
      });
    });
    _generalException = temp;
    notifyListeners();
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

  Future<Map<String, dynamic>> sendProfileSetUp(var data, var token) async {
    final url = Uri.parse('${baseUrl}business/profile-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _generalException.clear();
        var responseData = json.decode(response.body);
        return {
          'Status_Code': response.statusCode,
          'Id': responseData['Profile_Id'],
          'Profile_Code': responseData['Profile_Code'],
        };
      } else {
        if (response.statusCode == 400) {
          exception(response);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': response.body,
          };
        } else {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        }
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> sendBusinessHours(var data, var id, var token) async {
    final url = Uri.parse('${baseUrl}business/businesshours-list/$id/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;

        List temp = [];
        responseData.forEach((key, value) {
          temp.add({
            'heading': key,
            'value': value,
          });
        });
        _generalException = temp;
        notifyListeners();
      }
      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> editBusinessHours(var data, var id, var token) async {
    final url = Uri.parse('${baseUrl}business/businesshours-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      _generalException.clear();

      if (response.statusCode == 400) {
        exception(response);
      }

      print(response.statusCode);
      print(response.body);

      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchBusinessHours(var id, var token) async {
    final url = Uri.parse('${baseUrl}business/businesshours-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        _businessHours = responseData;
        notifyListeners();
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData
        };
      }

      // print(response.statusCode);
      // print(response.body);
      return {
        'Status_Code': response.statusCode,
      };
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendBankPaymentOptions(
      var data, var id, var token) async {
    final url = Uri.parse('${baseUrl}business/bankpayment-list/$id/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        return {
          'Status_Code': response.statusCode,
        };
      } else {
        if (response.statusCode == 400) {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);

          List temp = [];
          responseData.forEach((key, value) {
            temp.add({
              'heading': key,
              'value': value,
            });
          });
          _generalException = temp;
          notifyListeners();
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        } else {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        }
      }

      // print(response.statusCode);
      // print(response.body);
      // return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchBankPaymentOptions(
      var id, var token) async {
    final url = Uri.parse('${baseUrl}business/bankpayment-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // body: json.encode(data),
      );
      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData;
        if (response.body != '') {
          responseData = json.decode(response.body);
          _bankPaymentDetails = responseData;
        } else {
          _bankPaymentDetails = {};
        }

        notifyListeners();
        return {
          'StatusCode': response.statusCode,
          'ResponseData': responseData
        };
      } else {
        _bankPaymentDetails = {};

        notifyListeners();
        return {'StatusCode': response.statusCode, 'ResponseData': {}};
      }

      // return {'StatusCode': response.statusCode};
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendBpayDetails(
      var data, var id, var token) async {
    final url = Uri.parse('${baseUrl}business/bpay-list/$id/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        return {
          'Status_Code': response.statusCode,
        };
      } else {
        if (response.statusCode == 400) {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          List temp = [];
          responseData.forEach((key, value) {
            temp.add({
              'heading': key,
              'value': value,
            });
          });
          _generalException = temp;
          notifyListeners();
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        } else {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        }
      }

      // print(response.statusCode);
      // print(response.body);
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateBankDetails(
      var data, var id, var token) async {
    final url = Uri.parse('${baseUrl}business/bankpayment-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 202 || response.statusCode == 201) {
        _generalException.clear();
        var responseData = json.decode(response.body);
        _bankPaymentDetails = responseData;
        notifyListeners();
        return {
          'StatusCode': response.statusCode,
          'ResponseData': responseData
        };
      } else {
        if (response.statusCode == 400) {
          exception(response);
        }
        _bankPaymentDetails = {};
        notifyListeners();
        return {'StatusCode': response.statusCode, 'ResponseData': {}};
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendFCMDeviceModel(var data, var token) async {
    print(data);
    final url = Uri.parse('${baseUrl}business/fcm-list/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(response.body);
        return {
          'Status_Code': response.statusCode,
        };
      } else {
        if (response.statusCode == 400) {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        } else {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        }
      }

      // print(response.statusCode);
      // print('fcm response ${response.body.toString()}');
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchBpayDetails(var id, var token) async {
    final url = Uri.parse('${baseUrl}business/bpay-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // body: json.encode(data),
      );

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData;
        if (response.body != '') {
          responseData = json.decode(response.body);
          _bPayDetails = responseData;
        } else {
          _bPayDetails = {};
        }

        notifyListeners();
        return {
          'StatusCode': response.statusCode,
          'ResponseData': responseData
        };
      } else {
        _bPayDetails = {};
        notifyListeners();
        return {'StatusCode': response.statusCode, 'ResponseData': {}};
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateBpayDetails(
      var data, var id, var token) async {
    final url = Uri.parse('${baseUrl}business/bpay-details/$id/');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 202 || response.statusCode == 201) {
        _generalException.clear();
        var responseData = json.decode(response.body);
        _bPayDetails = responseData;
        notifyListeners();
        return {
          'StatusCode': response.statusCode,
          'ResponseData': responseData
        };
      } else {
        if (response.statusCode == 400) {
          exception(response);
        }
        _bPayDetails = {};
        notifyListeners();
        return {'StatusCode': response.statusCode, 'ResponseData': {}};
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchProfileDetails(var token) async {
    final url = Uri.parse('${baseUrl}business/profile-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        _profileDetails = responseData;
        notifyListeners();

        if (_profileDetails.isNotEmpty) {
          var pref = await SharedPreferences.getInstance();
          if (pref.containsKey('PartnerUniqueKey')) {
            pref.remove('PartnerUniqueKey');
          }
          var userData = json.encode({
            'PartnerUniqueKey': responseData[0]['Chat_Unique_Id'],
          });
          pref.setString('PartnerUniqueKey', userData);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData
          };
        }
      }
      return {'Status_Code': response.statusCode, 'Response_Body': ''};
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> fetchBusinessCategory(var token) async {
    final url = Uri.parse('${baseUrl}business/businesscategory/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print('business category ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        _businessCategoryList = responseData;
        notifyListeners();
      }
      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> editProfileDetails(var data, var token) async {
    final url =
        Uri.parse('${baseUrl}business/profile-details/${data['Profile_Id']}/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _generalException.clear();
        var responseData = json.decode(response.body);

        _profileDetails = responseData;
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData
        };
      } else {
        if (response.statusCode == 400) {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);

          exception(response);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData,
          };
        } else {
          var responseData = json.decode(response.body) as Map<String, dynamic>;
          // print(responseData.values.first);
          return {
            'Status_Code': response.statusCode,
            'Response_Body': responseData.values.first
          };
        }
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUser(var token) async {
    final url = Uri.parse('${baseUrl}business/user-details/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _user = responseData;
        return {
          'Status_Code': response.statusCode,
          'Id': responseData['id'],
        };
      }
      return {'Status_Code': response.statusCode, 'Response_Body': ''};
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> addMenuItems(
      var data, var id, var token, var image, var name) async {
    // print(name);
    final url = Uri.parse('${baseUrl}menu-data/menu-list/$id/');

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": 'Token $token'
    };
    List<MultipartFile> newList = [];
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      // print(image.length);
      if (image.isNotEmpty) {
        // for (int i = 0; i < image.length; i++) {
        //   var file = http.MultipartFile.fromBytes('Food_Image', image[i],
        //       // File(image).readAsBytesSync(),
        //       // File(image.relativePath).lengthSync(),
        //       filename: name[i]);
        //   newList.add(file);
        // }
        // request.files.addAll(newList);
        var file = http.MultipartFile.fromBytes('Food_Image', image,
            // File(image).readAsBytesSync(),
            // File(image.relativePath).lengthSync(),
            filename: name);
        request.files.add(file);
      }

      // request.fields['Food_Image_One'] = '';
      // request.fields['Food_Image_Two'] = '';
      // request.fields['Food_Image_Three'] = '';
      // request.fields['Image_Length'] = image.length;
      request.fields['Profile'] = data['Profile'].toString();
      request.fields['Food_Name'] = data['Food_Name'];
      request.fields['Ingredients'] = data['Ingredients'];
      request.fields['Allergen'] = data['Allergen'];
      request.fields['Price'] = data['Price'].toString();
      request.fields['Description'] = data['Description'];
      request.fields['Preparation_Time'] = data['Preparation_Time'].toString();
      request.fields['In_Stock'] = true.toString();
      request.fields['Cuisine'] = data['Cuisine'].toString();

      var res = await request.send();
      // print(res.statusCode);

      var responseString = await res.stream.bytesToString();
      // print(responseString);

      if (res.statusCode == 400) {
        // print(responseString);
        // print(res.reasonPhrase);

        List temp = [];
        temp.add({
          'heading': '',
          'value': [responseString],
        });

        _generalException = temp;
        notifyListeners();
      }

      return res.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> replaceMenuItem(
      var data, var id, var token, var image, var name) async {
    // print(name);
    final url = Uri.parse('${baseUrl}menu-data/menu-details/$id/');

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": 'Token $token'
    };
    try {
      var request = http.MultipartRequest('PATCH', url);
      request.headers.addAll(headers);
      if (image.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes('Food_Image', image,
              // File(image).readAsBytesSync(),
              // File(image.relativePath).lengthSync(),
              filename: name),
        );
      }

      request.fields['Profile'] = data['Profile'].toString();
      request.fields['Food_Name'] = data['Food_Name'];
      request.fields['Ingredients'] = data['Ingredients'];
      request.fields['Allergen'] = data['Allergen'];
      request.fields['Price'] = data['Price'].toString();
      request.fields['Description'] = data['Description'];
      request.fields['Preparation_Time'] = data['Preparation_Time'].toString();
      request.fields['Cuisine'] = data['Cuisine'].toString();
      var res = await request.send();
      // print(res.statusCode);

      var responseString = await res.stream.bytesToString();
      // print(responseString);

      // if (res.statusCode == 204 || res.statusCode == 202) {
      //   fetchMenuItems(token, data['Profile']).then((value) {
      //     return res.statusCode;
      //   });
      // }
      _generalException.clear();
      if (res.statusCode == 400) {
        print(responseString);
        print(res.reasonPhrase);

        List temp = [];
        temp.add({
          'heading': '',
          'value': [responseString],
        });

        _generalException = temp;
        notifyListeners();
      }
      return res.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> editMenuItems(var data, var id, var token) async {
    // print(id);
    final url = Uri.parse('${baseUrl}menu-data/menu-details/$id/');

    var headers = <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": 'Token $token'
    };
    try {
      // final response = await http.patch(
      //   url,
      //   headers: <String, String>{
      //     "Content-Type": "application/json; charset=UTF-8",
      //     "Authorization": 'Token $token'
      //   },
      //   body: json.encode(data),
      // );
      var request = http.MultipartRequest('PATCH', url);
      request.headers.addAll(headers);
      // if (image.isNotEmpty) {
      //   request.files.add(
      //     http.MultipartFile.fromBytes('Food_Image', image,
      //         // File(image).readAsBytesSync(),
      //         // File(image.relativePath).lengthSync(),
      //         filename: name),
      //   );
      // }

      request.fields['Profile'] = data['Profile'].toString();
      request.fields['Food_Name'] = data['Food_Name'];
      request.fields['Ingredients'] = data['Ingredients'];
      request.fields['Allergen'] = data['Allergen'];
      request.fields['Price'] = data['Price'].toString();
      request.fields['Description'] = data['Description'];
      request.fields['Preparation_Time'] = data['Preparation_Time'].toString();
      request.fields['Cuisine'] = data['Cuisine'];
      var res = await request.send();
      // print(res.statusCode);

      var responseString = await res.stream.bytesToString();
      // print(responseString);

      if (res.statusCode == 400) {
        // print(responseString);
        // print(res.reasonPhrase);

        List temp = [];
        temp.add({
          'heading': '',
          'value': [responseString],
        });

        _generalException = temp;
        notifyListeners();
      }

      return res.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> editMenuImage(var id, var token, var image, var name) async {
    // print(name);
    final url = Uri.parse('${baseUrl}menu-data/menu-details/$id/');

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": 'Token $token'
    };
    try {
      var request = http.MultipartRequest('PATCH', url);
      request.headers.addAll(headers);
      if (image.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes('Food_Image', image,
              // File(image).readAsBytesSync(),
              // File(image.relativePath).lengthSync(),
              filename: name),
        );
      }

      // request.fields['Profile'] = data['Profile'].toString();
      // request.fields['Food_Name'] = data['Food_Name'];
      // request.fields['Ingredients'] = data['Ingredients'];
      // request.fields['Allergen'] = data['Allergen'];
      // request.fields['Price'] = data['Price'].toString();
      // request.fields['Description'] = data['Description'];
      // request.fields['Preparation_Time'] = data['Preparation_Time'].toString();

      var res = await request.send();
      // print(res.statusCode);

      var responseString = await res.stream.bytesToString();
      // print(responseString);

      return res.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchMenuItems(var token, var id) async {
    final url = Uri.parse('${baseUrl}menu-data/menu-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      print(response.statusCode);
      log(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);
        _menuList = responseData;
        notifyListeners();
        return {'StatusCode': response.statusCode, 'Body': responseData};
      }
      return {'StatusCode': response.statusCode, 'Body': []};
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> updateStockValue(var data, var id, var token) async {
    // print(id);
    final url = Uri.parse('${baseUrl}menu-data/menu-details/$id/');

    var headers = <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": 'Token $token'
    };
    try {
      // final response = await http.patch(
      //   url,
      //   headers: <String, String>{
      //     "Content-Type": "application/json; charset=UTF-8",
      //     "Authorization": 'Token $token'
      //   },
      //   body: json.encode(data),
      // );
      var request = http.MultipartRequest('PATCH', url);
      request.headers.addAll(headers);
      // if (image.isNotEmpty) {
      //   request.files.add(
      //     http.MultipartFile.fromBytes('Food_Image', image,
      //         // File(image).readAsBytesSync(),
      //         // File(image.relativePath).lengthSync(),
      //         filename: name),
      //   );
      // }

      request.fields['In_Stock'] = data.toString();

      var res = await request.send();
      // print(res.statusCode);

      var responseString = await res.stream.bytesToString();
      // print(responseString);

      return res.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> updateRecommendedValue(var data, var id, var token) async {
    // print(id);
    final url = Uri.parse('${baseUrl}menu-data/menu-details/$id/');

    var headers = <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Authorization": 'Token $token'
    };
    try {
      // final response = await http.patch(
      //   url,
      //   headers: <String, String>{
      //     "Content-Type": "application/json; charset=UTF-8",
      //     "Authorization": 'Token $token'
      //   },
      //   body: json.encode(data),
      // );
      var request = http.MultipartRequest('PATCH', url);
      request.headers.addAll(headers);
      // if (image.isNotEmpty) {
      //   request.files.add(
      //     http.MultipartFile.fromBytes('Food_Image', image,
      //         // File(image).readAsBytesSync(),
      //         // File(image.relativePath).lengthSync(),
      //         filename: name),
      //   );
      // }

      request.fields['Recommended'] = data.toString();

      var res = await request.send();
      // print(res.statusCode);

      var responseString = await res.stream.bytesToString();
      // print(responseString);

      return res.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> fetchOrders(var id, var token) async {
    final url = Uri.parse('${baseUrl}order/newOrder-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // log(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        List newOrdersList = [];
        List preparingOrderList = [];
        List dispatchedOrderList = [];
        for (var data in responseData) {
          if (data['Status'] == '' || data['Status'] == null) {
            newOrdersList.add(data);
          } else if (data['Status'] == 'Accept') {
            preparingOrderList.add(data);
          } else if (data['Status'] == 'Ready') {
            dispatchedOrderList.add(data);
          }
        }

        _newOrdersList = newOrdersList;
        _preparingOrdersList = preparingOrderList;
        _dispatchedOrdersList = dispatchedOrderList;
        notifyListeners();
      }
      // print(_newOrdersList);
      // log(response.body);
      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> fetchOrderDetails(var id, var token) async {
    final url = Uri.parse('${baseUrl}order/newOrder-details/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );
      print(response.statusCode);
      print('order details ${response.body}');

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _orderDetails = responseData;

        notifyListeners();
      }

      // log(response.body);
      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> fetchAllOrders(var id, var token) async {
    final url = Uri.parse('${baseUrl}order/newOrder-list/$id/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        // List newOrdersList = [];
        // List preparingOrderList = [];
        // List dispatchedOrderList = [];

        // for (var data in responseData) {
        //   if (data['Status'] == '' || data['Status'] == null) {
        //     newOrdersList.add(data);
        //   } else if (data['Status'] == 'Accept') {
        //     preparingOrderList.add(data);
        //   } else if (data['Status'] == 'Ready') {
        //     dispatchedOrderList.add(data);
        //   }
        // }
        // _newOrdersList = newOrdersList;
        // _preparingOrdersList = preparingOrderList;
        // _dispatchedOrdersList = dispatchedOrderList;

        _allOrderHistory = responseData;
        notifyListeners();
      }
      // print(response.statusCode);
      // print(response.body);
      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> getCuisinesCategory(var token) async {
    final url = Uri.parse('${baseUrl}menu-data/cuisine-list/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        _cuisinesCategoryList = responseData;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> updateOrders(var data, var id, var token) async {
    print(data);
    final url = Uri.parse('${baseUrl}order/newOrder-details/$id/');
    try {
      final response = await http.patch(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );
      print(response.statusCode);
      log(response.body);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        _updatedOrderList = responseData;
        notifyListeners();
      }

      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<int> sendMessageNotification(var data, var token) async {
    final url = Uri.parse('${baseUrl}business/sendmessage/');

    // print(data);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print(response.body);
      return response.statusCode;
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addCouponsData(var data, var token) async {
    final url =
        Uri.parse('${baseUrl}business/couponcode-list/${data['Profile']}/');

    // print(data);
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print(response.body);
      _generalException.clear();
      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        // print(responseData.values.first);
        exception(response);
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData.values.first
        };
      } else {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        // print(responseData.values.first);
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData.values.first
        };
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCouponsData(var data, var token) async {
    final url =
        Uri.parse('${baseUrl}business/couponcode-details/${data['id']}/');

    // print(data);
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        body: json.encode(data),
      );

      // print(response.statusCode);
      // print(response.body);
      _generalException.clear();

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        // print(responseData.values.first);
        exception(response);
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData.values.first
        };
      } else {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        // print(responseData.values.first);
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData.values.first
        };
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCoupons(var token, var id) async {
    final url = Uri.parse('${baseUrl}business/couponcode-list/$id/');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
      );

      // print(response.statusCode);
      // print('Coupon Body ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = json.decode(response.body);

        _couponList = responseData;
        notifyListeners();
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData
        };
      } else {
        notifyListeners();
        return {'Status_Code': response.statusCode, 'Response_Body': []};
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteCouponsData(var id, var token) async {
    final url = Uri.parse('${baseUrl}business/couponcode-details/$id/');

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": 'Token $token'
        },
        // body: json.encode(data),
      );

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 400) {
        var responseData = json.decode(response.body) as Map<String, dynamic>;
        // print(responseData.values.first);
        return {
          'Status_Code': response.statusCode,
          'Response_Body': responseData.values.first
        };
      } else {
        // print(responseData.values.first);
        return {'Status_Code': response.statusCode, 'Response_Body': []};
      }
    } catch (e) {
      commonException(e.toString());
      rethrow;
    }
  }
}
