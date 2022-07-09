import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOutLetTimings extends StatefulWidget {
  EditOutLetTimings({Key? key}) : super(key: key);

  static const routeName = '/EditOutLetTimings';

  @override
  _EditOutLetTimingsState createState() => _EditOutLetTimingsState();
}

class _EditOutLetTimingsState extends State<EditOutLetTimings> {
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
  Map<String, dynamic> sundayTimings = {
    'id': '',
    'Day': 'Sunday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> mondayTimings = {
    'id': '',
    'Day': 'Monday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> tuesdayTimings = {
    'id': '',
    'Day': 'Tuesday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> wednesdayTimings = {
    'id': '',
    'Day': 'Wednesday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> thursdayTimings = {
    'id': '',
    'Day': 'Thursday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> fridayTimings = {
    'id': '',
    'Day': 'Friday',
    'OpensAt': '',
    'ClosesAt': '',
  };
  Map<String, dynamic> saturdayTimings = {
    'id': '',
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

  var _profileId;

  var save;

  var horizontalPadding = 20;

  List _businessHours = [];

  bool _businessHoursData = true;

  @override
  void initState() {
    EasyLoading.show();
    Provider.of<ApiCalls>(context, listen: false).generalException.clear();
    getProfileId().then((value) {
      // print(_profileId);
      if (_profileId != null) {
        Provider.of<Authenticate>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          var token = Provider.of<Authenticate>(context, listen: false).token;
          Provider.of<ApiCalls>(context, listen: false)
              .fetchBusinessHours(_profileId, token)
              .then((value) {
            EasyLoading.dismiss();
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
              _businessHours = value['Response_Body'];
              if (_businessHours.isEmpty) {
                setState(() {
                  _businessHoursData = false;
                });
              } else {
                for (int i = 0; i < _businessHours.length; i++) {
                  if (_businessHours[i]['Day'] == 'Sunday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      sundaySwitch = true;
                      sundayOpenController.text = _businessHours[i]['OpensAt'];
                      sundayTimings['OpensAt'] = _businessHours[i]['OpensAt'];
                      sundayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      sundayTimings['ClosesAt'] = _businessHours[i]['ClosesAt'];
                    }
                  } else if (_businessHours[i]['Day'] == 'Monday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      mondaySwitch = true;
                      mondayOpenController.text = _businessHours[i]['OpensAt'];
                      mondayTimings['OpensAt'] = _businessHours[i]['OpensAt'];
                      mondayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      mondayTimings['ClosesAt'] = _businessHours[i]['ClosesAt'];
                    }
                  } else if (_businessHours[i]['Day'] == 'Tuesday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      tuesdaySwitch = true;
                      tuesdayOpenController.text = _businessHours[i]['OpensAt'];
                      tuesdayTimings['OpensAt'] = _businessHours[i]['OpensAt'];
                      tuesdayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      tuesdayTimings['ClosesAt'] =
                          _businessHours[i]['ClosesAt'];
                    }
                  } else if (_businessHours[i]['Day'] == 'Wednesday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      wednesdaySwitch = true;
                      wednesdayOpenController.text =
                          _businessHours[i]['OpensAt'];
                      wednesdayTimings['OpensAt'] =
                          _businessHours[i]['OpensAt'];
                      wednesdayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      wednesdayTimings['ClosesAt'] =
                          _businessHours[i]['ClosesAt'];
                    }
                  } else if (_businessHours[i]['Day'] == 'Friday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      fridaySwitch = true;
                      fridayOpenController.text = _businessHours[i]['OpensAt'];
                      fridayTimings['OpensAt'] = _businessHours[i]['OpensAt'];
                      fridayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      fridayTimings['ClosesAt'] = _businessHours[i]['ClosesAt'];
                    }
                  } else if (_businessHours[i]['Day'] == 'Saturday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      saturdaySwitch = true;
                      saturdayOpenController.text =
                          _businessHours[i]['OpensAt'];
                      saturdayTimings['OpensAt'] = _businessHours[i]['OpensAt'];
                      saturdayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      saturdayTimings['ClosesAt'] =
                          _businessHours[i]['ClosesAt'];
                    }
                  } else if (_businessHours[i]['Day'] == 'Thursday') {
                    if (_businessHours[i]['OpensAt'] != "") {
                      thursdaySwitch = true;
                      thursdayOpenController.text =
                          _businessHours[i]['OpensAt'];
                      thursdayTimings['OpensAt'] = _businessHours[i]['OpensAt'];
                      thursdayCloseController.text =
                          _businessHours[i]['ClosesAt'];
                      thursdayTimings['ClosesAt'] =
                          _businessHours[i]['ClosesAt'];
                    }
                  }
                  setState(() {});
                }
              }
              // Get.showSnackbar(GetSnackBar(
              //   duration: const Duration(seconds: 2),
              //   backgroundColor: Theme.of(context).backgroundColor,
              //   message: 'Successfully Added data',
              //   title: 'Success',
              // ));
            } else {
              // Get.showSnackbar(GetSnackBar(
              //   duration: const Duration(seconds: 2),
              //   backgroundColor: Theme.of(context).backgroundColor,
              //   message: 'Something Went Wrong please check your credentials',
              //   title: 'Failed',
              // ));
            }
          });
        });
      }
    });

    super.initState();
  }

  Future<void> getProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('profile')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('profile')!) as Map<String, dynamic>;

    _profileId = extratedUserData['profileId'];
  }

  Future<void> saveTimings() async {
    List businessHours = [
      sundayTimings,
      mondayTimings,
      tuesdayTimings,
      wednesdayTimings,
      thursdayTimings,
      fridayTimings,
      saturdayTimings
    ];

    // print(_businessHours.length);
    if (_businessHours.isNotEmpty) {
      sundayTimings['Profile'] = _profileId;
      mondayTimings['Profile'] = _profileId;
      tuesdayTimings['Profile'] = _profileId;
      wednesdayTimings['Profile'] = _profileId;
      thursdayTimings['Profile'] = _profileId;
      fridayTimings['Profile'] = _profileId;
      saturdayTimings['Profile'] = _profileId;
      for (int i = 0; i < _businessHours.length; i++) {
        businessHours[i]['id'] = _businessHours[i]['id'];
        // businessHours[i]['Profile'] = _businessHours[i]['Profile'];
      }
      print(businessHours);
      EasyLoading.show();
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .editBusinessHours(businessHours, _profileId, token)
            .then((value) {
          EasyLoading.dismiss();
          if (value == 202 || value == 201) {
            Get.back();
            Get.showSnackbar(GetSnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Theme.of(context).backgroundColor,
              message: 'Successfully Updated the timings',
              title: 'Success',
            ));
          } else {
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
      sundayTimings['Profile'] = _profileId;
      mondayTimings['Profile'] = _profileId;
      tuesdayTimings['Profile'] = _profileId;
      wednesdayTimings['Profile'] = _profileId;
      thursdayTimings['Profile'] = _profileId;
      fridayTimings['Profile'] = _profileId;
      saturdayTimings['Profile'] = _profileId;
      print(businessHours);
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
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // _businessHours = Provider.of<ApiCalls>(context).businessHours;
    // if (_businessHours.isEmpty && _businessHoursData == true) {
    //   EasyLoading.show();
    // } else {
    //   print(_businessHours);
    //   EasyLoading.dismiss();
    // }

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   iconTheme: const IconThemeData(color: Colors.black),
        //   title: Text(
        //     'Business Hours',
        //     style: GoogleFonts.roboto(
        //       textStyle: const TextStyle(color: Colors.black),
        //     ),
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20, top: 20, bottom: 100),
          child: SingleChildScrollView(child: businessHours(width)),
        ),
        bottomSheet: Container(
          width: width,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: width - horizontalPadding,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: saveTimings,
                    child: Text(
                      'save',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mondayState(Map<String, dynamic> data) {
    setState(() {
      if (data['identity'] == 'Switch') {
        mondaySwitch = data['switchState'];
        if (mondaySwitch == false) {
          mondayTimings['OpensAt'] = '';
          mondayTimings['ClosesAt'] = '';
          mondayOpenController.text = '';
          mondayCloseController.text = '';
        }
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
        if (tuesdaySwitch == false) {
          tuesdayTimings['OpensAt'] = '';
          tuesdayTimings['ClosesAt'] = '';
          tuesdayOpenController.text = '';
          tuesdayCloseController.text = '';
        }
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
        if (wednesdaySwitch == false) {
          wednesdayTimings['OpensAt'] = '';
          wednesdayTimings['ClosesAt'] = '';
          wednesdayOpenController.text = '';
          wednesdayCloseController.text = '';
        }
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
        if (thursdaySwitch == false) {
          thursdayTimings['OpensAt'] = '';
          thursdayTimings['ClosesAt'] = '';
          thursdayOpenController.text = '';
          thursdayCloseController.text = '';
        }
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
        if (fridaySwitch == false) {
          fridayTimings['OpensAt'] = '';
          fridayTimings['ClosesAt'] = '';
          fridayOpenController.text = '';
          fridayCloseController.text = '';
        }
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
        if (saturdaySwitch == false) {
          saturdayTimings['OpensAt'] = '';
          saturdayTimings['ClosesAt'] = '';
          saturdayOpenController.text = '';
          saturdayCloseController.text = '';
        }
      } else if (data['identity'] == 'openTime') {
        saturdayOpenController.text = data['value'];
        saturdayTimings['OpensAt'] = data['value'];
      } else if (data['identity'] == 'closeTime') {
        saturdayCloseController.text = data['value'];
        saturdayTimings['ClosesAt'] = data['value'];
      }
    });
  }

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
                Container(width: 75, child: Text(weekName)),
                const SizedBox(
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
                ? SizedBox()
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
                                // print(newTime!.format(context).characters);
                                valueChanged({
                                  'value': newTime!
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
                                valueChanged({
                                  'value': newTime
                                      .format(context)
                                      .characters
                                      .toString(),
                                  'identity': 'closeTime',
                                });
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
        // Container(
        //   width: width,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text('Hours'),
        //       Container(
        //         // width: 300,
        //         child: Row(
        //           children: [
        //             TextButton(
        //               onPressed: () {},
        //               child: const Text('Cancel'),
        //             ),
        //             TextButton(
        //               onPressed: () {},
        //               child: const Text('Apply'),
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
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
}
