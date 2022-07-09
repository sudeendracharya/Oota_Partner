import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/authentication/screens/log_in_screen.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/home_page.dart';
import 'package:oota_business/home_ui/screens/map_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../colors.dart';

enum payment { none, bPay, bankDetails }

enum serviceFee { discount, coupon }

class ProfileSetUpPage extends StatefulWidget {
  ProfileSetUpPage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/ProfileSetUpPage';

  @override
  _ProfileSetUpPageState createState() => _ProfileSetUpPageState();
}

class _ProfileSetUpPageState extends State<ProfileSetUpPage> {
  payment paymentSelected = payment.none;
  serviceFee selectedService = serviceFee.discount;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _bankPaymentFormKey = GlobalKey();
  final GlobalKey<FormState> _bPayPaymentFormKey = GlobalKey();
  TextEditingController sundayOpenController = TextEditingController();
  TextEditingController sundayCloseController = TextEditingController();
  TextEditingController mondayOpenController = TextEditingController();
  TextEditingController mondayCloseController = TextEditingController();
  TextEditingController tuesdayOpenController = TextEditingController();
  TextEditingController tuesdayCloseController = TextEditingController();
  TextEditingController wednesdayOpenController = TextEditingController();
  TextEditingController wednesdayCloseController = TextEditingController();
  TextEditingController thursdayOpenController = TextEditingController();
  TextEditingController thursdayCloseController = TextEditingController();
  TextEditingController fridayOpenController = TextEditingController();
  TextEditingController fridayCloseController = TextEditingController();
  TextEditingController saturdayOpenController = TextEditingController();
  TextEditingController saturdayCloseController = TextEditingController();

  TextEditingController profileIdController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();
  TextEditingController businessCategoryController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController abnController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();

  var uuid = Uuid();

  Map<String, dynamic> initialValues = {
    'Profile_Id': '',
    'Business_Name': '',
    'Business_Address': '',
    'Business_Category': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile': '',
    'ABN': '',
  };

  Map<String, dynamic> profileSetUp = {
    'Profile_Id': '',
    'FCM_Token': '',
    'Profile_Code': '',
    'User': '',
    'Business_Name': '',
    'Business_Address': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile': '',
    'ABN': '',
    'Business_Category': '',
    'Food_Supply_Frequency': '',
    'Delivery_Charges': '0',
    'coupon_Code': '',
  };

  // Map<String, dynamic> profileSetUp = {
  //   'Profile_Id': 'A001',
  //   'FCM_Token': '',
  //   'Profile_Code': '5',
  //   'User': '',
  //   'Business_Name': '',
  //   'Business_Address': '',
  //   'First_Name': '',
  //   'Last_Name': '',
  //   'Mobile': '',
  //   'ABN': '',
  //   'Business_Category': '',
  //   'Food_Supply_Frequency': '',
  //   'Delivery_Charges': '0',
  //   'coupon_Code': '',
  // };

  Map<String, dynamic> initialProfileValues = {
    'FCM_Token': '',
    'Profile_Code': '',
    'User': '',
    'Business_Name': '',
    'Business_Address': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile': '',
    'ABN': '',
    'Business_Category': '',
    'Food_Supply_Frequency': '',
  };

  Map<String, dynamic> fcmDeviceModel = {
    'registration_id': '',
    'name': '',
    'device_id': '',
    'type': '',
  };

  Map<String, dynamic> bankPaymentSetUp = {
    'Profile': '',
    'Bank_Name': '',
    'BSB': '',
    'Account_Number': '',
  };

  Map<String, dynamic> bPaySetUp = {
    'Profile': '',
    'BPay': '',
  };

  var businessCategoryName;

  List<String> _selectedFrequency = [];
  final List<String> _frequencyFoodSupply = ['Daily', 'Weekly', 'On-Demand'];

  List businessCategory = [];
  Iterable<String> times = [
    '12:00 AM',
    '12:30 AM',
  ];

  var isOpened = false;

  var index = 0;

  Map<String, dynamic> sundayTimings = {
    'Profile': '',
    'Day': 'Sunday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> mondayTimings = {
    'Profile': '',
    'Day': 'Monday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> tuesdayTimings = {
    'Profile': '',
    'Day': 'Tuesday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> wednesdayTimings = {
    'Profile': '',
    'Day': 'Wednesday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> thursdayTimings = {
    'Profile': '',
    'Day': 'Thursday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> fridayTimings = {
    'Profile': '',
    'Day': 'Friday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> saturdayTimings = {
    'Profile': '',
    'Day': 'Saturday',
    'OpensAt': '',
    'ClosesAt': '',
  };

  var sundaySwitch = false;
  var mondaySwitch = false;
  var tuesdaySwitch = false;
  var wednesdaySwitch = false;
  var thursdaySwitch = false;
  var fridaySwitch = false;
  var saturdaySwitch = false;

  double gap = 10;

  var bankDetailsSelected = false;

  var bPaySelected = false;

  var _businessCategoryName;

  var _profileId;

  var _profileCode;

  var _selected = true;

  var result;

  var _validate = true;

  double errorHeight = 70;

  Map<String, dynamic> couponCode = {
    'Coupon': '',
    'Coupon_Discount': '',
  };

  TextEditingController lgaController = TextEditingController();

  var latitude;

  var longitude;

  var selectedDeliveryType;

  bool validateAddress = true;

  @override
  void initState() {
    super.initState();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchBusinessCategory(token)
          .then((value) => null);
    });
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      fcmDeviceModel['type'] = 'ios';
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      fcmDeviceModel['type'] = 'android';
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  String getRandom(int length) {
    const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random r = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }

  Future<void> getProfile() async {
    EasyLoading.show();
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        EasyLoading.dismiss();
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          _profileId = value['Response_Body'][0]['Profile_Id'];
          profileSetUp['Profile_Id'] = value['Response_Body'][0]['Profile_Id'];
          initialProfileValues = {
            'Profile_Id': value['Response_Body'][0]['Profile_Id'],
            'Profile_Code': value['Response_Body'][0]['Profile_Code'],
            'User': value['Response_Body'][0]['User'],
            'Business_Name': value['Response_Body'][0]['Business_Name'],
            'Business_Address': value['Response_Body'][0]['Business_Address'],
            'First_Name': value['Response_Body'][0]['First_Name'],
            'Last_Name': value['Response_Body'][0]['Last_Name'],
            'Mobile': value['Response_Body'][0]['Mobile'],
            'ABN': value['Response_Body'][0]['ABN'],
            'Business_Category': value['Response_Body'][0]['Business_Category'],
            'Food_Supply_Frequency': value['Response_Body'][0]
                ['Food_Supply_Frequency'],
          };

          businessNameController.text =
              value['Response_Body'][0]['Business_Name'];
          businessAddressController.text =
              value['Response_Body'][0]['Business_Address'];
          firstNameController.text = value['Response_Body'][0]['First_Name'];
          lastNameController.text = value['Response_Body'][0]['Last_Name'];
          mobileController.text = value['Response_Body'][0]['Mobile'];
          abnController.text = value['Response_Body'][0]['ABN'];

          // print(initialProfileValues);

          setState(() {});
        }
      });
    });
  }

  Future<void> save() async {
    _validate = _formKey.currentState!.validate();

    if (_validate != true) {
      setState(() {
        _validate = false;
      });
      return;
    }

    EasyLoading.show();
    _formKey.currentState!.save();
    profileSetUp['Business_Category'] = _businessCategoryName;
    profileSetUp['Food_Supply_Frequency'] = _selectedFrequency;
    profileSetUp['coupon_Code'] = couponCode;
    profileSetUp['Latitude'] = latitude;
    profileSetUp['Longitude'] = longitude;
    if (selectedDeliveryType == null) {
      Get.showSnackbar(const GetSnackBar(
        title: 'Alert',
        message: 'Please select delivery type',
        duration: Duration(seconds: 4),
      ));
      return;
    }
    try {
      if (_profileId != null) {
        Provider.of<Authenticate>(context, listen: false)
            .tryAutoLogin()
            .then((value) async {
          var token = Provider.of<Authenticate>(context, listen: false).token;
          final prefs = await SharedPreferences.getInstance();
          if (!prefs.containsKey('FCM')) {
            return false;
          }
          final extratedUserData =
              json.decode(prefs.getString('FCM')!) as Map<String, dynamic>;
          profileSetUp['FCM_Token'] = extratedUserData['token'];
          print(profileSetUp);

          Provider.of<ApiCalls>(context, listen: false)
              .editProfileDetails(profileSetUp, token)
              .then((value) async {
            if (value['Status_Code'] == 202 || value['Status_Code'] == 201) {
              EasyLoading.dismiss();
              Get.showSnackbar(GetSnackBar(
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).backgroundColor,
                message: 'Successfully Updated the Data',
                title: 'Success',
              ));

              setState(() {
                index = index + 1;
              });
            } else {
              EasyLoading.dismiss();
              Get.defaultDialog(
                  title: 'Error',
                  middleText: value['Response_Body'][0],
                  confirm: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'ok',
                        style: TextStyle(color: ProjectColors.themeColor),
                      )));

              return;
            }
          });
        });
        return;
      }

      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;

        Provider.of<ApiCalls>(context, listen: false)
            .fetchUser(token)
            .then((value) async {
          if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
            print(value);
            profileSetUp['User'] = value['Id'];
            profileSetUp['Profile_Code'] = getRandom(5);

            final prefs = await SharedPreferences.getInstance();
            if (!prefs.containsKey('FCM')) {
              return false;
            }
            final extratedUserData =
                json.decode(prefs.getString('FCM')!) as Map<String, dynamic>;
            profileSetUp['FCM_Token'] = extratedUserData['token'];
            print(profileSetUp);
            // if (!mounted) {
            //   print('Not mounted');
            //   return null;
            // }
            Provider.of<ApiCalls>(context, listen: false)
                .sendProfileSetUp(profileSetUp, token)
                .then((value) async {
              if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
                _profileCode = value['Profile_Code'];
                _profileId = value['Id'];
                sundayTimings['Profile'] = _profileId;
                mondayTimings['Profile'] = _profileId;
                tuesdayTimings['Profile'] = _profileId;
                wednesdayTimings['Profile'] = _profileId;
                thursdayTimings['Profile'] = _profileId;
                fridayTimings['Profile'] = _profileId;
                saturdayTimings['Profile'] = _profileId;
                EasyLoading.dismiss();

                Get.showSnackbar(GetSnackBar(
                  duration: const Duration(seconds: 2),
                  backgroundColor: Theme.of(context).backgroundColor,
                  message: 'Successfully added the Profile',
                  title: 'Success',
                ));

                setState(() {
                  index = index + 1;
                });
              } else {
                EasyLoading.dismiss();
                // Get.defaultDialog(
                //   title: value['Response_Body'][0]['heading'],
                //   middleText: value['Response_Body'][0]['value'][0],
                //   confirm: TextButton(
                //     onPressed: () {
                //       Get.back();
                //     },
                //     child: const Text('ok'),
                //   ),
                // );
              }
            });
          }
        });
      });
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).backgroundColor,
        message: 'Something Went Wrong please check your credentials',
        title: 'Failed',
      ));
    }

    // print(profileSetUp);
  }

  Future<void> saveTimings() async {
    EasyLoading.show();
    List businessHours = [
      sundayTimings,
      mondayTimings,
      tuesdayTimings,
      wednesdayTimings,
      thursdayTimings,
      fridayTimings,
      saturdayTimings
    ];
    // print(businessHours);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .sendBusinessHours(businessHours, _profileId, token)
          .then((value) {
        if (value == 200 || value == 201) {
          EasyLoading.dismiss();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully Added data',
            title: 'Success',
          ));

          setState(() {
            index = index + 1;
          });
        } else {
          EasyLoading.dismiss();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Something Went Wrong please check your credentials',
            title: 'Failed',
          ));
        }
      });
    });
  }

  void saveBankPayment() {
    EasyLoading.show();
    _bankPaymentFormKey.currentState!.save();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      bankPaymentSetUp['Profile'] = _profileId;
      // print(bankPaymentSetUp);
      Provider.of<ApiCalls>(context, listen: false)
          .sendBankPaymentOptions(bankPaymentSetUp, _profileId, token)
          .then((value) async {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          EasyLoading.dismiss();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully Added payment Options',
            title: 'Success',
          ));

          String? deviceId = await _getId();
          final prefs = await SharedPreferences.getInstance();
          if (!prefs.containsKey('FCM')) {
            return false;
          }
          final extratedUserData =
              json.decode(prefs.getString('FCM')!) as Map<String, dynamic>;
          fcmDeviceModel['registration_id'] = extratedUserData['token'];
          fcmDeviceModel['name'] = _profileCode;

          fcmDeviceModel['device_id'] = deviceId;
          final profilePrefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              'profileId': _profileId,
            },
          );
          profilePrefs.setString('profile', userData);

          Provider.of<ApiCalls>(context, listen: false)
              .sendFCMDeviceModel(fcmDeviceModel, token)
              .then((value) {
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
              Get.toNamed(HomePageScreen.routeName, arguments: 1);
            } else {
              Get.toNamed(HomePageScreen.routeName, arguments: 1);
            }
          });
        } else {
          EasyLoading.dismiss();
          // Get.defaultDialog(
          //     title: 'Error',
          //     middleText: value['Response_Body'][0],
          //     confirm: TextButton(
          //         onPressed: () {
          //           Get.back();
          //         },
          //         child: const Text('ok')));
        }
      });
    });
  }

  void saveBPayment() {
    EasyLoading.show();
    _bPayPaymentFormKey.currentState!.save();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) async {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      bPaySetUp['Profile'] = _profileId;
      // print(bPaySetUp);
      final profilePrefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'profileId': _profileId,
        },
      );
      profilePrefs.setString('profile', userData);
      Provider.of<ApiCalls>(context, listen: false)
          .sendBpayDetails(bPaySetUp, _profileId, token)
          .then((value) async {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          EasyLoading.dismiss();
          Get.showSnackbar(
            GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully Added payment Options',
              title: 'Success',
            ),
          );

          String? deviceId = await _getId();
          final prefs = await SharedPreferences.getInstance();
          if (!prefs.containsKey('FCM')) {
            return false;
          }
          final extratedUserData =
              json.decode(prefs.getString('FCM')!) as Map<String, dynamic>;
          fcmDeviceModel['registration_id'] = extratedUserData['token'];
          fcmDeviceModel['name'] = _profileCode;

          fcmDeviceModel['device_id'] = deviceId;
          // print(fcmDeviceModel);

          Provider.of<ApiCalls>(context, listen: false)
              .sendFCMDeviceModel(fcmDeviceModel, token)
              .then((value) {
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
              Get.toNamed(HomePageScreen.routeName, arguments: 1);
            } else {
              Get.toNamed(HomePageScreen.routeName, arguments: 1);
            }
          });
        } else {
          EasyLoading.dismiss();
          // Get.defaultDialog(
          //     title: 'Error',
          //     middleText: value['Response_Body'][0],
          //     confirm: TextButton(
          //         onPressed: () {
          //           Get.back();
          //         },
          //         child: const Text('ok')));
        }
      });
    });
  }

  Future<void> sendFcmDeviceToken() async {
    EasyLoading.show();
    String? deviceId = await _getId();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('FCM')) {
      EasyLoading.dismiss();
      Get.toNamed(HomePageScreen.routeName, arguments: 1);
    }
    final extratedUserData =
        json.decode(prefs.getString('FCM')!) as Map<String, dynamic>;
    fcmDeviceModel['registration_id'] = extratedUserData['token'];
    fcmDeviceModel['name'] = _profileCode;

    fcmDeviceModel['device_id'] = deviceId;
    // print(fcmDeviceModel);
    final profilePrefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'profileId': _profileId,
      },
    );
    profilePrefs.setString('profile', userData);

    try {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .sendFCMDeviceModel(fcmDeviceModel, token)
            .then((value) {
          EasyLoading.dismiss();
          if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
            Get.toNamed(HomePageScreen.routeName, arguments: 1);
          } else {
            Get.toNamed(HomePageScreen.routeName, arguments: 1);
          }
        });
      });
    } catch (e) {
      // print(e.toString());

      Get.toNamed(HomePageScreen.routeName, arguments: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formWidth = MediaQuery.of(context).size.width / 1.2;
    var width = MediaQuery.of(context).size.width;
    businessCategory = Provider.of<ApiCalls>(context).businessCategoryList;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Theme(
              data: ThemeData(
                backgroundColor: Colors.white,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: const Color.fromRGBO(255, 114, 76, 1),
                    ),
              ),
              child: Stepper(
                currentStep: index,
                elevation: 0,
                type: StepperType.horizontal,

                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        index == 0
                            ? SizedBox(
                                width: formWidth * 0.1,
                              )
                            : GestureDetector(
                                onTap: details.onStepCancel,
                                child: Container(
                                  width: formWidth / 3.4,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(255, 114, 76, 1),
                                    ),
                                  ),
                                  child: const Text('Back'),
                                ),
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                        index == 0
                            ? GestureDetector(
                                onTap: () {
                                  print('exit');

                                  Get.defaultDialog(
                                      title: 'Alert',
                                      middleText:
                                          'You cannot go further without creating your profile',
                                      confirm: TextButton(
                                        onPressed: () {
                                          Get.offAllNamed(
                                            LogInPage.routeName,
                                          );
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(
                                              color: ProjectColors.themeColor),
                                        ),
                                      ),
                                      cancel: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color:
                                                    ProjectColors.themeColor),
                                          )));
                                },
                                child: Container(
                                  width: formWidth / 3.4,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(255, 114, 76, 1),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (index < 2) {
                                    setState(() {
                                      index = index + 1;
                                    });
                                  } else {
                                    if (index == 2) {
                                      sendFcmDeviceToken();
                                    }
                                  }
                                },
                                child: Container(
                                  width: formWidth / 3.4,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(255, 114, 76, 1),
                                    ),
                                  ),
                                  child: const Text('Skip'),
                                ),
                              ),
                        const SizedBox(
                          width: 20,
                        ),
                        paymentSelected == payment.none && index == 2
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 25),
                                child: SizedBox(
                                  width: formWidth / 3.4,
                                  height: 48,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromRGBO(255, 114, 76, 1),
                                        ),
                                      ),
                                      onPressed: details.onStepContinue,
                                      child: Text(
                                        'Next',
                                        style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                              255,
                                              254,
                                              254,
                                              1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
                onStepCancel: () {
                  if (index > 0) {
                    if (index == 1) {
                      setState(() {
                        index -= 1;
                        getProfile();
                      });
                    } else {
                      setState(() {
                        index -= 1;
                      });
                    }
                  }
                },
                onStepContinue: () {
                  if (index >= 0) {
                    if (index == 0) {
                      save();
                    } else if (index == 1) {
                      saveTimings();
                      // savePlantData();
                    } else if (index == 2) {
                      if (bankDetailsSelected == true) {
                        saveBankPayment();
                      } else {
                        saveBPayment();
                      }
                    }
                  }
                },
                // onStepTapped: (int value) {
                //   setState(() {
                //     index = value;
                //   });
                // },
                steps: [
                  Step(
                    isActive: _selected,
                    title: const SizedBox(),
                    content: profileSetup(width, formWidth),
                  ),
                  Step(
                    isActive: index >= 1 ? true : false,
                    title: const SizedBox(),
                    content: businessHours(width),
                  ),
                  Step(
                    isActive: index >= 2 ? true : false,
                    title: const SizedBox(),
                    content: paymentDetails(width),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void mondayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        mondaySwitch = data['switchState'];
      } else if (data['identity'] == 'openTime') {
        mondayOpenController.text = data['value'];
        mondayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        mondayCloseController.text = data['value'];
        mondayTimings['ClosesAt'] = data['value'];
      }
    });
  }

  void tuesdayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        tuesdaySwitch = data['switchState'];
      } else if (data['identity'] == 'openTime') {
        tuesdayOpenController.text = data['value'];
        tuesdayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        tuesdayCloseController.text = data['value'];
        tuesdayTimings['ClosesAt'] = data['value'];
      }
    });
  }

  void wednesdayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        wednesdaySwitch = data['switchState'];
      } else if (data['identity'] == 'openTime') {
        wednesdayOpenController.text = data['value'];
        wednesdayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        wednesdayCloseController.text = data['value'];
        wednesdayTimings['ClosesAt'] = data['value'];
      }
    });
  }

  void thursdayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        thursdaySwitch = data['switchState'];
      } else if (data['identity'] == 'openTime') {
        thursdayOpenController.text = data['value'];
        thursdayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        thursdayCloseController.text = data['value'];
        thursdayTimings['ClosesAt'] = data['value'];
      }
    });
  }

  void fridayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        fridaySwitch = data['switchState'];
      } else if (data['identity'] == 'openTime') {
        fridayOpenController.text = data['value'];
        fridayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        fridayCloseController.text = data['value'];
        fridayTimings['ClosesAt'] = data['value'];
      }
    });
  }

  void saturdayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        saturdaySwitch = data['switchState'];
      } else if (data['identity'] == 'openTime') {
        saturdayOpenController.text = data['value'];
        saturdayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        saturdayCloseController.text = data['value'];
        saturdayTimings['ClosesAt'] = data['value'];
      }
    });
  }

  Form profileSetup(double width, double formWidth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text('Profile Setup',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'First Name'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ])),
                ),
                Container(
                  width: width / 1.2,
                  height: _validate == true ? 40 : errorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                          hintText: 'Enter First Name',
                          border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          // showError('FirmCode');
                          return 'First name cannot be empty';
                        }
                      },
                      onSaved: (value) {
                        profileSetUp['First_Name'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Last Name'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ])),
                ),
                Container(
                  width: width / 1.2,
                  height: _validate == true ? 40 : errorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Last Name',
                          border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          // showError('FirmCode');
                          return 'Last name cannot be empty';
                        }
                      },
                      onSaved: (value) {
                        profileSetUp['Last_Name'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Business Name'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ])),
                ),
                Container(
                  width: width / 1.2,
                  height: _validate == true ? 40 : errorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      controller: businessNameController,
                      decoration: const InputDecoration(
                          hintText: 'Enter Business Name',
                          border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          // showError('FirmCode');
                          return 'Business Nname cannot be empty';
                        }
                      },
                      onSaved: (value) {
                        profileSetUp['Business_Name'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Business/Pickup Address'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ])),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width / 1.4,
                      height: _validate == true ? 80 : 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          enabled: false,
                          controller: businessAddressController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                              hintText: 'This would be used as pick-up address',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                validateAddress = false;
                              });

                              // showError('FirmCode');
                              return 'Business address cannot be empty';
                            } else {
                              setState(() {
                                validateAddress = true;
                              });
                            }
                          },
                          onSaved: (value) {
                            profileSetUp['Business_Address'] = value;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          result = await Get.toNamed(MapScreen.routeName);
                          if (result != null) {
                            setState(() {
                              businessAddressController.text =
                                  result['Address'];
                              latitude = result['Latitude'];
                              longitude = result['Longitude'];
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.map_sharp,
                          size: 40,
                          color: Color.fromRGBO(255, 114, 76, 1),
                        ))
                  ],
                ),
              ],
            ),
          ),
          validateAddress == true
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 18),
                  child: Row(
                    children: const [
                      Text(
                        'Address field cannot be empty',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Mobile Number'),
                    TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ])),
                ),
                Container(
                  width: width / 1.2,
                  height: _validate == true ? 40 : errorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          hintText: 'Enter valid 10 digit mobile number',
                          border: InputBorder.none),
                      validator: (value) {
                        if (value!.isEmpty) {
                          // showError('FirmCode');
                          return 'Mobile number cannot be empty';
                        } else if (value.length > 10) {
                          return 'Mobile number cannot be greater than 10 characters';
                        }
                      },
                      onSaved: (value) {
                        profileSetUp['Mobile'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(TextSpan(children: [
                    TextSpan(text: 'Australian Business Number (ABN)'),
                    // TextSpan(text: '*', style: TextStyle(color: Colors.red))
                  ])),
                ),
                Container(
                  width: width / 1.2,
                  height: _validate == true ? 40 : errorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      controller: abnController,
                      decoration: const InputDecoration(
                          hintText: 'Enter ABN (Optional) ',
                          border: InputBorder.none),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     // showError('FirmCode');
                      //     return 'ABN number cannot be empty';
                      //   }
                      // },
                      onSaved: (value) {
                        profileSetUp['ABN'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'LGA Licence No.'),
                        // TextSpan(text: '*', style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                ),
                Container(
                  width: width / 1.2,
                  height: _validate == true ? 40 : errorHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: TextFormField(
                      controller: lgaController,
                      decoration: const InputDecoration(
                          hintText: 'Approved Licence Number ',
                          border: InputBorder.none),
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     // showError('FirmCode');
                      //     return 'ABN number cannot be empty';
                      //   }
                      // },
                      onSaved: (value) {
                        profileSetUp['LGA_Licence_No'] = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     Radio(
          //         value: serviceFee.discount,
          //         groupValue: selectedService,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedService = value as serviceFee;
          //           });
          //         }),
          //     const SizedBox(
          //       width: 5,
          //     ),
          //     const Text('Delivery'),
          //     const SizedBox(
          //       width: 40,
          //     ),
          //     Radio(
          //         value: serviceFee.coupon,
          //         groupValue: selectedService,
          //         onChanged: (value) {
          //           setState(() {
          //             selectedService = value as serviceFee;
          //           });
          //         }),
          //     const SizedBox(
          //       width: 5,
          //     ),
          //     const Text('Coupon'),
          //   ],
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          // selectedService == serviceFee.discount
          //     ?
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width / 1.2,
                padding: const EdgeInsets.only(bottom: 12),
                child: const Text.rich(TextSpan(children: [
                  TextSpan(text: 'Delivery Fee (\$/km)'),
                  TextSpan(text: '*', style: TextStyle(color: Colors.red))
                ])),
              ),
              Container(
                width: width / 1.2,
                height: _validate == true ? 40 : errorHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter \$ amount',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isNum != true) {
                        // showError('FirmCode');
                        return 'Enter a valid delivery fee';
                      }
                    },
                    onSaved: (value) {
                      if (value == null || value.isEmpty) {
                        profileSetUp['Delivery_Charges'] = 0;
                      } else {
                        profileSetUp['Delivery_Charges'] = value;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          // : const SizedBox(),
          // const SizedBox(
          //   height: 15,
          // ),

          // selectedService == serviceFee.coupon
          // //     ?
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Container(
          //       width: width / 1.2,
          //       padding: const EdgeInsets.only(bottom: 12),
          //       child: const Text('Coupon Name'),
          //     ),
          //     Container(
          //       width: width / 1.2,
          //       height: 40,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(8),
          //         color: Colors.white,
          //         border: Border.all(color: Colors.black26),
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 12,
          //         ),
          //         child: TextFormField(
          //           decoration: const InputDecoration(
          //               hintText: 'Enter coupon name',
          //               border: InputBorder.none),
          //           validator: (value) {
          //             if (value!.isEmpty) {
          //               // showError('FirmCode');
          //               return '';
          //             }
          //           },
          //           onSaved: (value) {
          //             couponCode['Coupon'] = value;
          //           },
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // : const SizedBox(),
          // selectedService == serviceFee.coupon
          //     ? Padding(
          //         padding: const EdgeInsets.only(top: 24.0),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Container(
          //               width: width / 1.2,
          //               padding: const EdgeInsets.only(bottom: 12),
          //               child: const Text('Coupon discount'),
          //             ),
          //             Container(
          //               width: width / 1.2,
          //               height: 40,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8),
          //                 color: Colors.white,
          //                 border: Border.all(color: Colors.black26),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.symmetric(
          //                   horizontal: 12,
          //                 ),
          //                 child: TextFormField(
          //                   decoration: const InputDecoration(
          //                       hintText: 'Enter coupon discount',
          //                       border: InputBorder.none),
          //                   validator: (value) {
          //                     if (value!.isEmpty) {
          //                       // showError('FirmCode');
          //                       return '';
          //                     }
          //                   },
          //                   onSaved: (value) {
          //                     couponCode['Coupon_Discount'] = value;
          //                   },
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
          //     : const SizedBox(),
          // const SizedBox(
          //   height: 15,
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Align(
              // alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width / 1.2,
                    padding: const EdgeInsets.only(bottom: 6),
                    child: const Text.rich(TextSpan(children: [
                      TextSpan(text: 'Delivery Type'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ])),
                  ),
                  Container(
                    width: width / 1.2,
                    height: 47,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedDeliveryType,
                          items: ['PickUp', 'PickUp/Delivery', 'Catering Only']
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              child: Text(e),
                              value: e,
                              onTap: () {
                                profileSetUp['Delivery_Mode'] = e;
                                // _plantId = e['Plant_Id'];
                                // _plantName =
                                //     e['Plant_Name'];
                                // wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                              },
                            );
                          }).toList(),
                          hint: const Text('Choose Delivery Type'),
                          onChanged: (value) {
                            setState(() {
                              selectedDeliveryType = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Align(
              // alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width / 1.2,
                    padding: const EdgeInsets.only(bottom: 6),
                    child: const Text.rich(TextSpan(children: [
                      TextSpan(text: 'Business Category'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ])),
                  ),
                  Container(
                    width: width / 1.2,
                    height: 47,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: businessCategoryName,
                          items: businessCategory
                              .map<DropdownMenuItem<String>>((e) {
                            return DropdownMenuItem(
                              value: e['Business_Category'],
                              onTap: () {
                                _businessCategoryName =
                                    e['Business_Category_Id'];

                                // _plantId = e['Plant_Id'];
                                // _plantName =
                                //     e['Plant_Name'];
                                // wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                              },
                              child: Text(e['Business_Category']),
                            );
                          }).toList(),
                          hint: const Text('Choose Business Category'),
                          onChanged: (value) {
                            setState(() {
                              businessCategoryName = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Align(
              // alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width / 1.2,
                    padding: const EdgeInsets.only(bottom: 6),
                    child: const Text.rich(TextSpan(children: [
                      TextSpan(text: 'Frequency Of Food Supply'),
                      TextSpan(text: '*', style: TextStyle(color: Colors.red))
                    ])),
                  ),
                  Container(
                    width: width / 1.2,
                    height: 47,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                    ),
                    child: DropDownMultiSelect(
                        options: _frequencyFoodSupply,
                        selectedValues: _selectedFrequency,
                        onChanged: (List<String> value) {
                          setState(() {
                            _selectedFrequency = value;
                          });
                        },
                        whenEmpty: 'Select'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Align(
              // alignment: Alignment.topLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: width / 1.2,
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Consumer<ApiCalls>(builder: (context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.generalException.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: [
                                Text(
                                  value.generalException[index]['heading'] ??
                                      '',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.red),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  value.generalException[index]['value'][0] ??
                                      '',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form businessHours(var width) {
    return Form(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('Business Hours',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w700))),
          ),
        ),
        Container(
          width: width,
          child: Column(
            children: [
              Row(
                children: [
                  Container(width: 75, child: Text('Sunday')),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Switch(
                            value: sundaySwitch,
                            onChanged: (value) {
                              setState(() {
                                sundaySwitch = value;
                              });
                            }),
                        sundaySwitch == false
                            ? const Text('closed')
                            : const Text('Open')
                      ],
                    ),
                  )
                ],
              ),
              sundaySwitch == false
                  ? SizedBox()
                  : Row(
                      children: [
                        Container(
                          width: 100,
                          height: 20,
                          child: GestureDetector(
                            onTap: () async {
                              final TimeOfDay? newTime = await showTimePicker(
                                initialEntryMode: TimePickerEntryMode.input,
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 7, minute: 15),
                              );
                              print(newTime!.format(context).characters);
                              setState(() {
                                sundayOpenController.text = newTime
                                    .format(context)
                                    .characters
                                    .toString();
                                sundayTimings['OpensAt'] =
                                    sundayOpenController.text;
                              });
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: sundayOpenController,
                              decoration: const InputDecoration(
                                  hintText: 'Opens At',
                                  hintStyle: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 30,
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 20,
                          child: GestureDetector(
                            onTap: () async {
                              final TimeOfDay? newTime = await showTimePicker(
                                initialEntryMode: TimePickerEntryMode.input,
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 7, minute: 15),
                              );
                              print(newTime!.format(context).characters);
                              setState(() {
                                sundayCloseController.text = newTime
                                    .format(context)
                                    .characters
                                    .toString();
                                sundayTimings['ClosesAt'] =
                                    sundayCloseController.text;
                              });
                            },
                            child: TextFormField(
                              enabled: false,
                              controller: sundayCloseController,
                              decoration: const InputDecoration(
                                  hintText: 'Closes At',
                                  hintStyle: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
        designMethod(
          width,
          'Monday',
          mondaySwitch,
          mondayOpenController,
          mondayCloseController,
          mondayState,
        ),
        designMethod(
          width,
          'Tuesday',
          tuesdaySwitch,
          tuesdayOpenController,
          tuesdayCloseController,
          tuesdayState,
        ),
        designMethod(
          width,
          'Wednesday',
          wednesdaySwitch,
          wednesdayOpenController,
          wednesdayCloseController,
          wednesdayState,
        ),
        designMethod(
          width,
          'Thursday',
          thursdaySwitch,
          thursdayOpenController,
          thursdayCloseController,
          thursdayState,
        ),
        designMethod(
          width,
          'Friday',
          fridaySwitch,
          fridayOpenController,
          fridayCloseController,
          fridayState,
        ),
        designMethod(
          width,
          'Saturday',
          saturdaySwitch,
          saturdayOpenController,
          saturdayCloseController,
          saturdayState,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Align(
            // alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: width / 1.2,
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Consumer<ApiCalls>(builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.generalException.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(
                            children: [
                              Text(
                                value.generalException[index]['heading'] ?? '',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.red),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                value.generalException[index]['value'][0] ?? '',
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  var startTime;
  var endTime;

  Padding designMethod(
    width,
    String weekName,
    bool switchName,
    TextEditingController controllerOpen,
    TextEditingController controllerClose,
    ValueChanged<Map<String, dynamic>> valueChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: width,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 75, child: Text(weekName)),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Row(
                    children: [
                      Switch(
                          value: switchName,
                          onChanged: (value) {
                            // print(value);
                            valueChanged({
                              'switchState': value,
                              'identity': 'Switch',
                            });
                            setState(
                              () {
                                switchName = value;
                              },
                            );
                          }),
                      switchName == false
                          ? const Text('closed')
                          : const Text('Open')
                    ],
                  ),
                )
              ],
            ),
            switchName == false
                ? const SizedBox()
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 20,
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? newTime = await showTimePicker(
                                  initialEntryMode: TimePickerEntryMode.input,
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 7, minute: 15),
                                );
                                print(newTime!.format(context).characters);
                                startTime = newTime.hour;
                                // print(startTime);

                                valueChanged({
                                  'value': newTime
                                      .format(context)
                                      .characters
                                      .toString(),
                                  'identity': 'openTime',
                                });
                                // setState(() {
                                //   controllerOpen.text =
                                //       newTime.format(context).characters.toString();
                                //   selectedOpenTime = controllerOpen.text;
                                // });
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: controllerOpen,
                                decoration: const InputDecoration(
                                    hintText: 'Opens At',
                                    hintStyle: TextStyle(fontSize: 15)),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: SizedBox(
                              width: 30,
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 20,
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? newTime = await showTimePicker(
                                  initialEntryMode: TimePickerEntryMode.input,
                                  context: context,
                                  initialTime:
                                      const TimeOfDay(hour: 7, minute: 15),
                                );
                                print(newTime!.format(context).characters);
                                endTime = newTime.hour;
                                print(endTime);
                                print(startTime);
                                if (endTime < startTime) {
                                  Get.defaultDialog(
                                      title: 'Alert',
                                      middleText:
                                          'Start time Cannot be Greater then End Time',
                                      confirm: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Ok')));
                                } else {
                                  valueChanged({
                                    'value': newTime
                                        .format(context)
                                        .characters
                                        .toString(),
                                    'identity': 'closeTime',
                                  });
                                }

                                // setState(() {
                                //   controllerClose.text =
                                //       newTime.format(context).characters.toString();
                                //   selectedCloseTime = controllerClose.text;
                                // });
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: controllerClose,
                                decoration: const InputDecoration(
                                  hintText: 'Closes At',
                                  hintStyle: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 15.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       TextButton(
                      //           onPressed: () {},
                      //           child: const Text('Add Hours'))
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Column paymentDetails(double width) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Payment SetUp',
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700))),
        ),
        Row(
          children: [
            Radio(
                value: payment.none,
                groupValue: paymentSelected,
                onChanged: (value) {
                  setState(() {
                    paymentSelected = value as payment;
                    bankDetailsSelected = false;
                    bPaySelected = false;
                  });
                }),
            // Checkbox(
            //     value: bankDetailsSelected,
            //     onChanged: (value) {
            //       setState(() {
            //         bankDetailsSelected = value!;
            //         bPaySelected = false;
            //       });
            //     }),
            const Text('none')
          ],
        ),
        Row(
          children: [
            Radio(
                value: payment.bankDetails,
                groupValue: paymentSelected,
                onChanged: (value) {
                  setState(() {
                    paymentSelected = value as payment;
                    bankDetailsSelected = true;
                    bPaySelected = false;
                  });
                }),
            // Checkbox(
            //     value: bankDetailsSelected,
            //     onChanged: (value) {
            //       setState(() {
            //         bankDetailsSelected = value!;
            //         bPaySelected = false;
            //       });
            //     }),
            const Text('Add Bank Details')
          ],
        ),
        bankDetailsSelected == false
            ? SizedBox()
            : Form(
                key: _bankPaymentFormKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: width / 1.2,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text.rich(TextSpan(children: [
                                TextSpan(text: 'Bank Name'),
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red))
                              ])),
                            ),
                            Container(
                              width: width / 1.2,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Enter Bank Name',
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      // showError('FirmCode');
                                      return '';
                                    }
                                  },
                                  onSaved: (value) {
                                    bankPaymentSetUp['Bank_Name'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: width / 1.2,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text.rich(TextSpan(children: [
                                TextSpan(text: 'Bank State Branch(BSB)'),
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red))
                              ])),
                            ),
                            Container(
                              width: width / 1.2,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Enter BSB(Bank State Branch)',
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      // showError('FirmCode');
                                      return '';
                                    }
                                  },
                                  onSaved: (value) {
                                    bankPaymentSetUp['BSB'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: width / 1.2,
                              padding: const EdgeInsets.only(bottom: 12),
                              child: const Text.rich(TextSpan(children: [
                                TextSpan(text: 'Account Number'),
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red))
                              ])),
                            ),
                            Container(
                              width: width / 1.2,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                      hintText: 'Account Number',
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      // showError('FirmCode');
                                      return '';
                                    }
                                  },
                                  onSaved: (value) {
                                    bankPaymentSetUp['Account_Number'] = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Align(
                          // alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width / 1.2,
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Consumer<ApiCalls>(
                                    builder: (context, value, child) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: value.generalException.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              value.generalException[index]
                                                      ['heading'] ??
                                                  '',
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              value.generalException[index]
                                                      ['value'][0] ??
                                                  '',
                                              style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Radio(
                  value: payment.bPay,
                  groupValue: paymentSelected,
                  onChanged: (value) {
                    setState(() {
                      paymentSelected = value as payment;
                      bankDetailsSelected = false;
                      bPaySelected = true;
                    });
                  }),
              // Checkbox(
              //     value: bPaySelected,
              //     onChanged: (value) {
              //       setState(() {
              //         bPaySelected = value!;
              //         bankDetailsSelected = false;
              //       });
              //     }),
              const Text('Add BPay')
            ],
          ),
        ),
        bPaySelected == false
            ? SizedBox()
            : Form(
                key: _bPayPaymentFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: width / 1.2,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text.rich(TextSpan(children: [
                              TextSpan(text: 'Bpay Number'),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red))
                            ])),
                          ),
                          Container(
                            width: width / 1.2,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter BPay Number',
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return '';
                                  }
                                },
                                onSaved: (value) {
                                  bPaySetUp['BPay'] = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Align(
                        // alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: width / 1.2,
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Consumer<ApiCalls>(
                                  builder: (context, value, child) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: value.generalException.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            value.generalException[index]
                                                    ['heading'] ??
                                                '',
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            value.generalException[index]
                                                    ['value'][0] ??
                                                '',
                                            style: GoogleFonts.roboto(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
      ],
    );
  }
}
