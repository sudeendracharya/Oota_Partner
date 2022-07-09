import 'dart:convert';

import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/authentication/screens/sign_up_screen.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/home_page.dart';
import 'package:oota_business/home_ui/screens/log_in_splash_screen.dart';
import 'package:oota_business/home_ui/screens/profile_setup_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors.dart';
import '../../helper/helperfunctions.dart';
import '../../main.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key, required this.title}) : super(key: key);

  static const routeName = '/LogInPage';

  final String title;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // var baseUrl = 'https://ootaonline.herokuapp.com/';
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _url = '';
  FocusNode _focus = FocusNode();

  bool _obscureText = true;

  bool _isLoading = false;

  var phoneType;

  bool _passwordTyped = false;

  @override
  void initState() {
    _url = '${baseUrl}accounts/password/reset/';

    phoneType = getDeviceType();

    // print(phoneType);

    super.initState();
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }

  Map<String, dynamic> logIn = {
    'email': '',
    'password': '',
  };
  Map<String, dynamic> fcmDeviceModel = {
    'registration_id': '',
    'name': '',
    'device_id': '',
    'type': '',
  };

  TextStyle normalStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white));
  }

  Future<String?> _getId() async {
    print('Getting Id');
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

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  AuthService authService = AuthService();

  void showErrorDialog(var errorMessage) {
    Get.defaultDialog(
      title: 'Validation Error',
      middleText: errorMessage,
      confirm: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          'Ok',
          style: TextStyle(color: ProjectColors.themeColor),
        ),
      ),
    );
  }

  Future<void> save() async {
    if (emailEditingController.text.isEmpty) {
      showErrorDialog('Email id cannot be empty');
      return;
    } else if (emailEditingController.text.isEmail != true) {
      showErrorDialog('Enter a valid email id it cannot have any spaces');
      return;
    } else if (emailEditingController.text.contains(' ')) {
      showErrorDialog('Email id cannot have any spaces');
      return;
    } else if (passwordEditingController.text.isEmpty) {
      showErrorDialog('Password cannot be empty');
      return;
    }

    _formKey.currentState!.save();
    print(logIn);

    EasyLoading.show();

    Provider.of<Authenticate>(context, listen: false)
        .logIn(logIn)
        .then((value) async {
      if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
        QuerySnapshot userInfoSnapshot =
            await DatabaseMethods().getUserInfo(logIn['email']);

        var userName = userInfoSnapshot.docs[0].get('userName');
        var userEmail = userInfoSnapshot.docs[0].get('userEmail');

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(userName);
        HelperFunctions.saveUserEmailSharedPreference(userEmail);

        print('Login Success');
        // await authService
        //     .signInWithEmailAndPassword(logIn['email'], 'Oota@2022')
        //     .then((result) async {
        //   print('result $result');
        //   if (result != null) {

        //     // Navigator.pushReplacement(
        //     //     context, MaterialPageRoute(builder: (context) => ChatRoom()));
        //   } else {
        //     // setState(() {
        //     //   isLoading = false;
        //     //   //show snackbar
        //     // });
        //   }
        // });
        Provider.of<Authenticate>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Authenticate>(context, listen: false).token;

          Provider.of<ApiCalls>(context, listen: false)
              .fetchProfileDetails(token)
              .then((value) async {
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
              EasyLoading.dismiss();
              if (value['Response_Body'].isEmpty) {
                Get.toNamed(ProfileSetUpPage.routeName);
              } else {
                Get.toNamed(LogInSplashScreen.routeName,
                    arguments: {'value': value, 'token': token});
                // sendFcmDevice(value, token);
                // Get.toNamed(HomePageScreen.routeName);
              }
              // Get.showSnackbar(GetSnackBar(
              //   duration: const Duration(seconds: 2),
              //   backgroundColor: Theme.of(context).backgroundColor,
              //   message:
              //       'Successfully signed up an verification email is sent to your email id please verify',
              //   title: 'Success',
              // ));
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
      } else {
        EasyLoading.dismiss();
        showErrorMessage('Alert', value['Body']);
      }
    });
  }

  Future<void> sendFcmDevice(Map<String, dynamic> value, var token) async {
    final profilePrefs = await SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'profileId': value['Response_Body'][0]['Profile_Id'],
      },
    );
    profilePrefs.setString('profile', userData);
    String? deviceId = await _getId();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('FCM')) {
      return;
    }
    final extratedUserData =
        json.decode(prefs.getString('FCM')!) as Map<String, dynamic>;
    fcmDeviceModel['registration_id'] = extratedUserData['token'];
    fcmDeviceModel['name'] = value['Response_Body'][0]['Profile_Code'];

    fcmDeviceModel['device_id'] = deviceId;

    Provider.of<ApiCalls>(context, listen: false)
        .sendFCMDeviceModel(fcmDeviceModel, token)
        .then((value) {
      if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
        print('Fcm success');
        EasyLoading.dismiss();
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.blue.withOpacity(0.5),
          message: 'Successfully logged in',
          title: 'Success',
        ));
        Get.toNamed(HomePageScreen.routeName);
      } else {
        EasyLoading.dismiss();
        Get.toNamed(HomePageScreen.routeName);
      }
    });
  }

  void showErrorMessage(String title, List body) {
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Theme.of(context).backgroundColor,
      message: body[0],
      title: title,
    ));
  }

  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    print(height);
    var width = MediaQuery.of(context).size.width;
    var headingConatinerHeight = MediaQuery.of(context).size.height / 2;
    return phoneType == 'tablet'
        ? Scaffold(
            // backgroundColor: Theme.of(context).backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        height: height,
                        child: Image.asset(
                          'assets/images/food.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        top: height * 0.02,
                        left: width * 0.35,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Oota',
                            style: TextStyle(
                              fontFamily: 'MoonDance',
                              fontSize: 120,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.15,
                        left: width / 2.39,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Partners',
                            style: TextStyle(
                              fontFamily: 'MoonDance',
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: height * 0.30,
                      //   left: width * 0.45,
                      //   child: const Padding(
                      //     padding: EdgeInsets.only(top: 20.0),
                      //     child: Text(
                      //       'Log In',
                      //       style: TextStyle(
                      //         fontFamily: 'MoonDance',
                      //         fontSize: 30,
                      //         fontWeight: FontWeight.w700,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        top: height * 0.33,
                        left: width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width / 1.2,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text(
                                  'Email Id',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                width: width / 1.2,
                                height: 40,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(8),
                                  // color: Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller: emailEditingController,
                                    decoration: const InputDecoration(
                                      errorStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      hintText: 'Email Id',
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        // showError('FirmCode');
                                        return 'Email id cannot be empty ';
                                      } else if (value.contains(' ')) {
                                        return 'Email id cannot contains empty spaces';
                                      } else {
                                        return '';
                                      }
                                    },
                                    onSaved: (value) {
                                      logIn['email'] = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.44,
                        left: width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width / 1.2,
                                padding: const EdgeInsets.only(bottom: 12),
                                child: const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                width: width / 1.2,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white.withOpacity(0.8),
                                  border: Border.all(color: Colors.black26),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: FocusScope(
                                          child: Focus(
                                            onFocusChange: (value) {
                                              if (value == true) {
                                                setState(() {
                                                  _passwordTyped = true;
                                                });
                                              } else {
                                                setState(() {
                                                  _passwordTyped = false;
                                                });
                                              }
                                            },
                                            child: TextFormField(
                                              obscureText: _obscureText,
                                              controller:
                                                  passwordEditingController,

                                              // autovalidateMode: AutovalidateMode.always,
                                              // ignore: prefer_const_constructors
                                              decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14),
                                                  hintText: 'Password',
                                                  border: InputBorder.none),

                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  // showError('FirmCode');
                                                  return 'password cannot be empty';
                                                }
                                              },

                                              onSaved: (value) {
                                                logIn['password'] = value;
                                                // firmData['Firm_Code'] = value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      _passwordTyped == true &&
                                              _obscureText == false
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _obscureText = true;
                                                });
                                              },
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                width: 40,
                                                height: 25,
                                                child: Image.asset(
                                                  'assets/images/invisible.png',
                                                  fit: BoxFit.contain,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : _passwordTyped == true &&
                                                  _obscureText == true
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _obscureText = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    width: 40,
                                                    height: 25,
                                                    child: Image.asset(
                                                      'assets/images/view.png',
                                                      fit: BoxFit.contain,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.60,
                        left: width * 0.40,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 150,
                              height: 60,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    // const Color.fromRGBO(255, 193, 7, 1),
                                    // const Color.fromRGBO(255, 171, 76, 1),
                                    Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                onPressed: save,
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.71,
                        left: width * 0.42,
                        child: TextButton(
                          onPressed: _launchURL,
                          child: Text(
                            'Forgot Password?',
                            style: normalStyle(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.80,
                        left: width * 0.50,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Or',
                            style: TextStyle(
                                fontSize: 18,
                                // decoration: TextDecoration.underline,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.85,
                        left: width * 0.38,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(SignUpScreen.routeName);
                          },
                          child: Text(
                            'Create New Account',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            // backgroundColor: Theme.of(context).backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                  setState(() {
                    _obscureText = true;
                    _passwordTyped = false;
                  });
                }
              },
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        height: height,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: Image.asset(
                            'assets/images/food.jpg',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Container(
                        width: width,
                        height: height,
                        decoration: const BoxDecoration(
                          backgroundBlendMode: BlendMode.darken,
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(88, 70, 66, 55),
                              Color.fromARGB(88, 70, 66, 55),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.09,
                        left: width * 0.15,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Oota Partners',
                            style:
                                //  GoogleFonts.openSans(
                                //   fontWeight: FontWeight.w600,
                                //   color: Colors.white,
                                //   fontSize: 34,
                                // ),
                                TextStyle(
                              fontFamily: 'MoonDance',
                              fontSize: 64,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.20,
                        left: width * 0.15,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text('For the Love of Food!!',
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 20,
                              )),
                        ),
                      ),
                      Positioned(
                        top: height * 0.28,
                        left: width * 0.13,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Container(
                              //   width: width / 1.2,
                              //   padding: const EdgeInsets.only(bottom: 12),
                              //   child: const Text(
                              //     'Email Id',
                              //     style: TextStyle(color: Colors.white),
                              //   ),
                              // ),
                              Container(
                                width: width * 0.75,
                                height: 45,
                                decoration: const BoxDecoration(
                                  // borderRadius: BorderRadius.circular(8),
                                  // color: Colors.white.withOpacity(0.8),
                                  border: Border(
                                      bottom: BorderSide(color: Colors.white)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: TextFormField(
                                    controller: emailEditingController,
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email Id',
                                      hintStyle: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Email id cannot be empty ';
                                    //   } else if (value.contains(' ')) {
                                    //     return 'Email id cannot contains empty spaces';
                                    //   } else {
                                    //     return '';
                                    //   }
                                    // },
                                    onSaved: (value) {
                                      logIn['email'] = value;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.38,
                        left: width * 0.13,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Container(
                              //   width: width / 1.2,
                              //   padding: const EdgeInsets.only(bottom: 12),
                              //   child: const Text(
                              //     'Password',
                              //     style: TextStyle(color: Colors.white),
                              //   ),
                              // ),
                              Container(
                                width: width * 0.75,
                                height: 40,
                                decoration: const BoxDecoration(
                                  // borderRadius: BorderRadius.circular(8),
                                  // color: Colors.white.withOpacity(0.8),
                                  border: Border(
                                      bottom: BorderSide(color: Colors.white)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: FocusScope(
                                          child: Focus(
                                            onFocusChange: (value) {
                                              // print(value.toString());
                                              if (value == true) {
                                                setState(() {
                                                  _passwordTyped = true;
                                                  _obscureText = true;
                                                });
                                              } else {
                                                setState(() {
                                                  _passwordTyped = false;
                                                  _obscureText = true;
                                                });
                                              }
                                            },
                                            child: TextFormField(
                                              controller:
                                                  passwordEditingController,
                                              obscureText: _obscureText,
                                              // ignore: prefer_const_constructors
                                              style: GoogleFonts.openSans(
                                                textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              decoration: InputDecoration(
                                                  errorStyle: const TextStyle(
                                                      color: Colors.white),
                                                  hintText: 'Password',
                                                  hintStyle:
                                                      GoogleFonts.openSans(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                  border: InputBorder.none),
                                              // validator: (value) {
                                              //   if (value!.isEmpty) {
                                              //     // showError('FirmCode');
                                              //     return 'Password cannot be empty';
                                              //   }
                                              // },
                                              onSaved: (value) {
                                                logIn['password'] = value;
                                                // firmData['Firm_Code'] = value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      _passwordTyped == true &&
                                              _obscureText == false
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _obscureText = true;
                                                });
                                              },
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                width: 40,
                                                height: 25,
                                                child: Image.asset(
                                                  'assets/images/invisible.png',
                                                  fit: BoxFit.contain,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : _passwordTyped == true &&
                                                  _obscureText == true
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _obscureText = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    width: 40,
                                                    height: 25,
                                                    child: Image.asset(
                                                      'assets/images/view.png',
                                                      fit: BoxFit.contain,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      //     top: height * 0.46,
                      //     left: width * 0.13,
                      //     child: Container(
                      //       width: width * 0.75,
                      //       height: 60,
                      //       // color: Colors.amber.withOpacity(0.5),
                      //       child: Consumer<Authenticate>(
                      //           builder: (context, value, child) {
                      //         return ListView.builder(
                      //           shrinkWrap: true,
                      //           physics: const NeverScrollableScrollPhysics(),
                      //           itemCount: value.authenticateException.length,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             return Container(
                      //               child: Column(
                      //                 children: [
                      //                   // Text(
                      //                   //   value.authenticateException[index]
                      //                   //           ['key'] ??
                      //                   //       '',
                      //                   //   style: GoogleFonts.roboto(
                      //                   //       fontWeight: FontWeight.w400,
                      //                   //       fontSize: 16,
                      //                   //       color: Colors.white),
                      //                   // ),
                      //                   const SizedBox(
                      //                     height: 8,
                      //                   ),
                      //                   Text(
                      //                     value.authenticateException[index]
                      //                             ['value'][0] ??
                      //                         '',
                      //                     style: GoogleFonts.roboto(
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w800,
                      //                         color: Colors.red),
                      //                   )
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         );
                      //       }),
                      //     )),
                      Positioned(
                        top: height * 0.51,
                        left: width * 0.13,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: width * 0.75,
                              height: 60,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    // const Color.fromRGBO(255, 193, 7, 1),
                                    // const Color.fromRGBO(255, 171, 76, 1),
                                    const Color.fromRGBO(245, 148, 2, 1),
                                  ),
                                ),
                                onPressed: save,
                                child: Text(
                                  'Log In',
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.64,
                        left: width * 0.33,
                        child: TextButton(
                          onPressed: _launchURL,
                          child: Text(
                            'Forgot Password?',
                            style: normalStyle(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.75,
                        left: width * 0.45,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            'Or',
                            style: TextStyle(
                                fontSize: 18,
                                // decoration: TextDecoration.underline,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.80,
                        left: width * 0.26,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(SignUpScreen.routeName);
                          },
                          child: Text(
                            'Create New Account',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
