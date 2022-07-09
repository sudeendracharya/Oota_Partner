import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/privacy_policy.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../helper/helperfunctions.dart';
import '../../services/auth.dart';
import '../../services/database.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/SignUpScreen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool passwordSelected = false;

  Map<String, dynamic> signUp = {
    'email': '',
    'password1': '',
    'password2': '',
  };

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  var validate = true;

  double errorHeight = 60;
  bool _obscureText = true;
  bool _reenterObscureText = true;

  bool _selected = false;
  Future<void> save() async {
    if (_selected == false) {
      Get.defaultDialog(
        title: 'Alert',
        // titleStyle: const TextStyle(fontSize: 16),
        middleText:
            'Read and select terms of service acceptance checkbox to proceed',
        // middleText: 'Agree to Terms of service',
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
      return;
    }
    validate = _formKey.currentState!.validate();
    if (validate != true) {
      setState(() {
        validate = false;
      });
      return;
    }
    _formKey.currentState!.save();
    print(signUp);

    EasyLoading.show();

    Provider.of<Authenticate>(context, listen: false)
        .signUp(signUp)
        .then((value) async {
      if (value == 200 || value == 201) {
        // await authService
        //     .signUpWithEmailAndPassword(signUp['email'], 'Oota@2022')
        //     .then((result) {
        //   if (result != null) {
        //     // Navigator.pushReplacement(
        //     //     context, MaterialPageRoute(builder: (context) => ChatRoom()));
        //   }
        // });
        Map<String, String> userDataMap = {
          "userName": signUp['email'],
          "userEmail": signUp['email'],
        };

        databaseMethods.addUserInfo(userDataMap);

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserNameSharedPreference(
          signUp['email'],
        );
        HelperFunctions.saveUserEmailSharedPreference(
          signUp['email'],
        );
        EasyLoading.dismiss();
        Get.back();
        Get.defaultDialog(
          title: 'Alert',
          middleText:
              'An email verification link is sent to your email address please verify',
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
  }

  @override
  Widget build(BuildContext context) {
    var formWidth = MediaQuery.of(context).size.width / 1.2;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Sign Up',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              setState(() {
                passwordSelected = false;
              });
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: width / 1.2,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text('Email'),
                          ),
                          Container(
                            width: width / 1.2,
                            height: validate == true ? 40 : errorHeight,
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
                                onTap: () {
                                  setState(() {
                                    passwordSelected = false;
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintStyle: TextStyle(fontSize: 14),
                                    hintText: 'Enter email',
                                    contentPadding: EdgeInsets.only(bottom: 10),
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    // showError('FirmCode');
                                    return 'Email id should not be empty';
                                  }
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);

                                  if (emailValid != true) {
                                    return 'Provide a valid Email Address';
                                  }
                                },
                                onSaved: (value) {
                                  signUp['email'] = value;
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
                            child: const Text(
                              'Password',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            width: width / 1.2,
                            height: validate == true ? 40 : errorHeight,
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
                                    child: TextFormField(
                                      obscureText: _obscureText,
                                      controller: password,
                                      onTap: () {
                                        setState(() {
                                          passwordSelected = true;
                                        });
                                      },

                                      // ignore: prefer_const_constructors
                                      decoration: InputDecoration(
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          hintText: 'Enter password',
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 10),
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return 'Password should not be empty';
                                        }
                                        if (value.length < 8) {
                                          return 'Password length cannot be less than 8 characters';
                                        }
                                        bool passwordValid = RegExp(
                                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                            .hasMatch(value);

                                        if (passwordValid != true) {
                                          return 'Password doesn\'t satisfy below criteria';
                                        }
                                      },
                                      onSaved: (value) {
                                        signUp['password1'] = value;
                                        // firmData['Firm_Code'] = value!;
                                      },
                                    ),
                                  ),
                                  _obscureText == false
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = true;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: 40,
                                            height: 25,
                                            child: Image.asset(
                                              'assets/images/invisible.png',
                                              fit: BoxFit.contain,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = false;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            width: 40,
                                            height: 25,
                                            child: Image.asset(
                                              'assets/images/view.png',
                                              fit: BoxFit.contain,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                  // _obscureText == false
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    passwordSelected == false
                        ? const SizedBox()
                        : const SizedBox(
                            height: 15,
                          ),

                    passwordSelected == false
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password must comprise of :',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                      'Min. 8 characters. \nOne upper case letter. \nOne special character. \nOne number. ')
                                ],
                              ),
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
                            child: const Text(
                              'Confirm password',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                          Container(
                            width: width / 1.2,
                            height: validate == true ? 40 : errorHeight,
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
                                    child: TextFormField(
                                      obscureText: _reenterObscureText,
                                      controller: confirmPassword,
                                      // ignore: prefer_const_constructors
                                      decoration: InputDecoration(
                                          // suffix: Container(
                                          //   alignment: Alignment.bottomCenter,
                                          //   width: 40,
                                          //   height: 25,
                                          //   child: Image.asset(
                                          //     'assets/images/view.png',
                                          //     fit: BoxFit.contain,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          hintStyle:
                                              const TextStyle(fontSize: 14),
                                          contentPadding:
                                              const EdgeInsets.only(bottom: 10),
                                          hintText: 'Enter confirm password',
                                          border: InputBorder.none),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          // showError('FirmCode');
                                          return 'Confirm password should not be empty';
                                        } else if (value != password.text) {
                                          return 'Password and confirm password should match ';
                                        }
                                      },
                                      onSaved: (value) {
                                        signUp['password2'] = value;
                                        // firmData['Firm_Code'] = value!;
                                      },
                                    ),
                                  ),
                                  // _reenterObscureText == false
                                  //     ? GestureDetector(
                                  //         onTap: () {
                                  //           setState(() {
                                  //             _reenterObscureText = true;
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           alignment: Alignment.bottomCenter,
                                  //           width: 40,
                                  //           height: 25,
                                  //           child: Image.asset(
                                  //             'assets/images/invisible.png',
                                  //             fit: BoxFit.contain,
                                  //             color: Colors.black,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : GestureDetector(
                                  //         onTap: () {
                                  //           setState(() {
                                  //             _reenterObscureText = false;
                                  //           });
                                  //         },
                                  //         child: Container(
                                  //           alignment: Alignment.bottomCenter,
                                  //           width: 40,
                                  //           height: 25,
                                  //           child: Image.asset(
                                  //             'assets/images/view.png',
                                  //             fit: BoxFit.contain,
                                  //             color: Colors.black,
                                  //           ),
                                  //         ),
                                  //       ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // formDesign(context, 'Password', 'Enter Password',
                    //     signUp['password1']),
                    // formDesign(context, 'Confirm Password',
                    //     'Enter Confirm Password', signUp['password2']),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Checkbox(
                              value: _selected,
                              onChanged: (value) {
                                setState(() {
                                  _selected = value!;
                                });
                              }),
                          Container(
                            width: width * 0.7,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                Get.toNamed(PrivacyPolicy.routeName);

                                // const url =
                                // "https://github.com/sudeendracharya/Oota-privacy/blob/main/privacy-policy.md";
                                // if (await canLaunch(url)) {
                                //   await launch(url);
                                // } else
                                //   // can't launch url, there is some error
                                //   throw "Could not launch $url";
                                // window.open(
                                //     'https://github.com/sudeendracharya/Oota-privacy/blob/main/privacy-policy.md',
                                //     'Terms of Services');
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    // TextSpan(
                                    //   text: 'Click on  ',
                                    //   style: GoogleFonts.roboto(
                                    //     textStyle: const TextStyle(
                                    //         color: Colors.black),
                                    //   ),
                                    // ),
                                    TextSpan(
                                      text: 'Agree to Terms of Service',
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                          width: formWidth,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 42,
                                    width: width / 1.2,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                          const Color.fromRGBO(245, 148, 2, 1),
                                        )),
                                        onPressed: save,
                                        child: Text(
                                          'Sign Up',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                        )),
                                  ),
                                  // Container(
                                  //   height: 45,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(8),
                                  //       border: Border.all(
                                  //         color: const Color.fromRGBO(
                                  //             124, 209, 184, 1),
                                  //       )),
                                  //   child: TextButton(
                                  //       // style: ButtonStyle(
                                  //       //   shape: MaterialStateProperty.all(),
                                  //       //     backgroundColor: MaterialStateProperty.all(
                                  //       //   const Color.fromRGBO(124, 209, 184, 1),
                                  //       // )),
                                  //       onPressed: () {
                                  //         Get.back();
                                  //       },
                                  //       child: Text(
                                  //         'Cancel',
                                  //         style: GoogleFonts.roboto(
                                  //             textStyle: const TextStyle(
                                  //                 fontSize: 25,
                                  //                 fontWeight: FontWeight.w500,
                                  //                 color: Colors.black)),
                                  //       )),
                                  // )
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text.rich(TextSpan(children: [
                                  TextSpan(
                                    text: 'Already a registered Partner?',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Login here',
                                    style: TextStyle(
                                        color: Color.fromRGBO(245, 148, 2, 1),
                                        decoration: TextDecoration.underline),
                                  ),
                                ])),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding formDesign(
      BuildContext context, String formName, String hintText, var data) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width / 1.2,
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(formName),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: hintText, border: InputBorder.none),
                validator: (value) {
                  if (value!.isEmpty) {
                    // showError('FirmCode');
                    return '';
                  }
                },
                onSaved: (value) {
                  data = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
