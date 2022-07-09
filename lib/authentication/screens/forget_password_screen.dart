import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/ForgetPasswordScreen';

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, dynamic> forgetPassword = {
    'Email': '',
  };

  Future<void> save() async {
    _formKey.currentState!.save();
    Provider.of<Authenticate>(context, listen: false)
        .forgetPassword(forgetPassword)
        .then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    var formWidth = MediaQuery.of(context).size.width / 1.2;
    return SafeArea(
      child: Scaffold(
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Forget Password',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700))),
                    ),
                    formDesign(context, 'Email', 'Enter Email Id',
                        forgetPassword['Email']),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Container(
                          width: formWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 45,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                      const Color.fromRGBO(124, 209, 184, 1),
                                    )),
                                    onPressed: save,
                                    child: Text(
                                      'Send',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    )),
                              ),
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          124, 209, 184, 1),
                                    )),
                                child: TextButton(
                                    // style: ButtonStyle(
                                    //   shape: MaterialStateProperty.all(),
                                    //     backgroundColor: MaterialStateProperty.all(
                                    //   const Color.fromRGBO(124, 209, 184, 1),
                                    // )),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black)),
                                    )),
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
