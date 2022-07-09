import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:oota_business/colors.dart';
import 'package:oota_business/home_ui/screens/add_coupons.dart';
import 'package:oota_business/home_ui/screens/edit_coupons_page.dart';
import 'package:oota_business/styles.dart';
import 'package:provider/provider.dart';

import '../../authentication/providers/authenticate.dart';
import '../providers/api_calls.dart';

class CouponsScreen extends StatefulWidget {
  CouponsScreen({Key? key}) : super(key: key);
  static const routeName = '/CouponsScreen';

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  List _couponList = [];

  bool _Coupons = true;

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        profileDetails =
            Provider.of<ApiCalls>(context, listen: false).profileDetails;

        Provider.of<ApiCalls>(context, listen: false)
            .getCoupons(token, profileDetails[0]['Profile_Id'])
            .then((value) {
          if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
            if (value['Response_Body'].isEmpty) {
              setState(() {
                _Coupons = false;
              });
            }
          }
        });
      });
    });
    super.initState();
  }

  var profileDetails;

  void getCoupons() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        profileDetails =
            Provider.of<ApiCalls>(context, listen: false).profileDetails;

        Provider.of<ApiCalls>(context, listen: false)
            .getCoupons(token, profileDetails[0]['Profile_Id'])
            .then((value) {
          if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
            if (value['Response_Body'].isEmpty) {
              setState(() {
                _Coupons = false;
              });
            }
          }
        });
      });
    });
  }

  TextStyle headingStyle() {
    return GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle valuesStyle() {
    return GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  void delete(var id) {
    EasyLoading.show();
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .deleteCouponsData(id, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value['Status_Code'] == 204 || value['Status_Code'] == 201) {
          Get.showSnackbar(const GetSnackBar(
            title: 'Success',
            message: 'Successfully Deleted the coupon',
            duration: Duration(seconds: 2),
          ));
          getCoupons();
        } else {
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
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _couponList = Provider.of<ApiCalls>(context).couponList;
    if (_couponList.isEmpty) {
      print('empty');
    } else {
      print('Not empty');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Coupons',
          style: ProjectStyles.appbarTitleStyle(),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Get.toNamed(AddCouponsPage.routeName);
                if (result == 'Success') {
                  getCoupons();
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: _couponList.isEmpty && _Coupons == true
          ? const Center(
              child: Text('Loading'),
            )
          : _couponList.isEmpty && _Coupons == false
              ? const Center(
                  child: Text('You have not added any coupons to display'),
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _couponList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var toDate = DateFormat("dd-MM-yyyy").format(
                                DateTime.parse(_couponList[index]['End_Date']));
                            var fromDate = DateFormat("dd-MM-yyyy").format(
                                DateTime.parse(
                                    _couponList[index]['Start_Date']));

                            return Container(
                              key: UniqueKey(),
                              width: size.width * 0.7,
                              child: Card(
                                shadowColor: ProjectColors.themeColor,
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Coupon Code Name:',
                                            style: headingStyle(),
                                          ),
                                          Text(
                                            _couponList[index]['Coupon'] ?? '',
                                            style: valuesStyle(),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Discount:',
                                            style: headingStyle(),
                                          ),
                                          Text(
                                            '${_couponList[index]['Discount'] ?? 'N/A'} %',
                                            style: valuesStyle(),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Discount For:',
                                            style: headingStyle(),
                                          ),
                                          Text(
                                            _couponList[index]
                                                    ['Discount_Purpose'] ??
                                                '',
                                            style: valuesStyle(),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Start Data:',
                                            style: headingStyle(),
                                          ),
                                          Text(
                                            fromDate,
                                            style: valuesStyle(),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'End Date:',
                                            style: headingStyle(),
                                          ),
                                          Text(
                                            toDate,
                                            style: valuesStyle(),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    delete(_couponList[index]
                                                        ['id']);
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete)),
                                              Text(
                                                'Delete',
                                                style: headingStyle(),
                                              )
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    var result =
                                                        await Get.toNamed(
                                                            EditCouponsPage
                                                                .routeName,
                                                            arguments:
                                                                _couponList[
                                                                    index]);

                                                    if (result == 'Success') {
                                                      getCoupons();
                                                    }
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              Text(
                                                'Edit',
                                                style: headingStyle(),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
