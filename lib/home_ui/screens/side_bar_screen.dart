import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/authentication/screens/log_in_screen.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/all_orders_history.dart';
import 'package:oota_business/home_ui/screens/bank_details_screen.dart';
import 'package:oota_business/home_ui/screens/chat_history.dart';
import 'package:oota_business/home_ui/screens/coupons_screen.dart';
import 'package:oota_business/home_ui/screens/edit_bank_details.dart';
import 'package:oota_business/home_ui/screens/edit_bpay_details.dart';
import 'package:oota_business/home_ui/screens/edit_business_profile.dart';
import 'package:oota_business/home_ui/screens/edit_outlet_timings.dart';
import 'package:oota_business/home_ui/screens/privacy_policy_internal.dart';
import 'package:provider/provider.dart';

class SideBarScreen extends StatefulWidget {
  const SideBarScreen({Key? key}) : super(key: key);
  static const routeName = '/SideBarScreen';

  @override
  _SideBarScreenState createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  List _profileDetailsList = [];

  Map<String, dynamic> _userData = {};

  Color color = Colors.grey;

  double iconSize = 20;

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) async {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {}
      });
      Provider.of<ApiCalls>(context, listen: false)
          .fetchUser(token)
          .then((value) async {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {}
      });
    });
    super.initState();
  }

  Future<void> fetchBankDetails(var id) async {
    EasyLoading.show();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchBankPaymentOptions(id, token)
          .then((value) async {
        if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
          EasyLoading.dismiss();

          Get.defaultDialog(
            title: '',
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Bank Details',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(EditBankDetails.routeName, arguments: {
                          'BankName': value['ResponseData']['Bank_Name'],
                          'BSB': value['ResponseData']['BSB'],
                          'AccountNumber': value['ResponseData']
                              ['Account_Number'],
                          'Profile_Id': _profileDetailsList[0]['Profile_Id']
                        });
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8.0, top: 20, left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: value['ResponseData'] == null
                        ? const Text('Bank Name:')
                        : Text(
                            'Bank Name: ${value['ResponseData']['Bank_Name']}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: value['ResponseData'] == null
                          ? const Text('BSB:')
                          : Text('BSB: ${value['ResponseData']['BSB']}')),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, left: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: value['ResponseData'] == null
                        ? const Text('Account Number: ')
                        : Text(
                            'Account Number: ${value['ResponseData']['Account_Number']}'),
                  ),
                ),
              ],
            ),
            // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))]
          );
        }
      });
      Provider.of<ApiCalls>(context, listen: false)
          .fetchBpayDetails(id, token)
          .then((value) async {
        if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
          EasyLoading.dismiss();
          Get.defaultDialog(
            titlePadding: EdgeInsets.all(0),
            title: '',
            content: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'BPay Number',
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                          Get.toNamed(EditbPayDetails.routeName, arguments: {
                            'BPay': value['ResponseData']['BPay'],
                            'Profile_Id': _profileDetailsList[0]['Profile_Id']
                          });
                        },
                        icon: const Icon(Icons.edit)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: value['ResponseData'] == null
                      ? const Text('BPay Number: ')
                      : Text(
                          'BPay Number: ${value['ResponseData']['BPay'] ?? ''}'),
                )
              ],
            ),
            // actions: [
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            //     ],
            //   )
            // ],
          );
        }
      });
    });
  }

  void _modalBottomSheetMenu(var userName, var mobileNumber, var email) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 200.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Profile',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(Icons.cancel))
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  userName ?? 'Name',
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Text(
                                  mobileNumber.toString(),
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Text(
                                  email ?? '',
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            Text('Owner')
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAll(() => const LogInPage(title: ''));
                            Provider.of<Authenticate>(context, listen: false)
                                .logout();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 24,
                            height: 25,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Log Out')),
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  void _modalBottomSheetProfile(
      {var businessName,
      var businessAddress,
      var businessCategory,
      var abn,
      var lgaNumber}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          var bottomSheetWidth = MediaQuery.of(context).size.width - 24;
          return Container(
              height: height * 0.7,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Business Profile',
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(Icons.cancel))
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 15, right: 15),
                              child: Column(
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: bottomSheetWidth * 0.35,
                                        child: Text(
                                          'Business Name:',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      Container(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          '$businessName',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          'Business Address:',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      Container(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          '$businessAddress',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          'Business Category:',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          '$businessCategory',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          'ABN:',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          '$abn',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          'LGA Licence Number',
                                          style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: bottomSheetWidth * 0.4,
                                        child: Text(
                                          lgaNumber == null
                                              ? 'N/A'
                                              : lgaNumber.toString(),
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 30,
                                child: TextButton(
                                    onPressed: () {
                                      Get.toNamed(
                                          EditBusinessProfileScreen.routeName,
                                          arguments: _profileDetailsList);
                                    },
                                    child: const Text('Edit Business Profile')),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 30,
                              child: TextButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.toNamed(EditOutLetTimings.routeName,
                                        arguments: _profileDetailsList[0]
                                            ['Profile_Id']);
                                  },
                                  child: const Text('Outlet timings')),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 30,
                              child: TextButton(
                                  onPressed: () {
                                    fetchBankDetails(
                                        _profileDetailsList[0]['Profile_Id']);

                                    // Get.toNamed(BankDetailsScreen.routeName,
                                    //     arguments: _profileDetailsList[0]
                                    //         ['Profile_Id']);
                                  },
                                  child: const Text('Bank Details')),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: 30,
                              child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Contact Details')),
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    _userData = Provider.of<ApiCalls>(
      context,
    ).user;

    _profileDetailsList = Provider.of<ApiCalls>(
      context,
    ).profileDetails;
    print(_profileDetailsList);
    print(_userData);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Outlet Settings',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _modalBottomSheetMenu(
                  '${_profileDetailsList[0]['First_Name'] + _profileDetailsList[0]['Last_Name']}',
                  _profileDetailsList[0]['Mobile'],
                  _userData['email']);
            },
            icon: const Icon(Icons.person, color: Colors.black),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _modalBottomSheetProfile(
                  businessName: _profileDetailsList[0]['Business_Name'],
                  businessCategory: _profileDetailsList[0]
                      ['Business_Category__Business_Category'],
                  businessAddress: _profileDetailsList[0]['Business_Address'],
                  abn: _profileDetailsList[0]['ABN'],
                  lgaNumber: _profileDetailsList[0]['LGA_Licence_No'],
                );
              },
              child: Container(
                width: width - 16,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileDetailsList.isEmpty
                            ? const Text('N/A')
                            : Text(
                                _profileDetailsList[0]['Business_Name'],
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ),
                        _profileDetailsList.isEmpty
                            ? const Text('N/A')
                            : Text(
                                _profileDetailsList[0]
                                        ['Business_Category__Business_Category']
                                    .toString(),
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: color,
                      size: iconSize,
                    )
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              // thickness: 5,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AllOrdersHistory.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: width - 16,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order History'),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: iconSize,
                        color: color,
                      )
                    ],
                  ),
                ),
              ),
            ),
            // const Divider(
            //   color: Colors.grey,
            //   // thickness: 5,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: Container(
            //     width: width - 16,
            //     height: 30,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const Text('Reviews'),
            //         Icon(
            //           Icons.arrow_forward_ios_outlined,
            //           color: color,
            //           size: iconSize,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // const Divider(
            //   color: Colors.grey,
            //   // thickness: 5,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: Container(
            //     width: width - 16,
            //     height: 30,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const Text('Help Centre'),
            //         Icon(
            //           Icons.arrow_forward_ios_outlined,
            //           color: color,
            //           size: iconSize,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                width: width - 16,
                height: 30,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(CouponsScreen.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Coupons'),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: color,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),
            ),

            // Padding(♂
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: Container(
            //     width: width - 16,
            //     height: 30,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const Text('Manage Notifications'),
            //         Icon(
            //           Icons.arrow_forward_ios_outlined,
            //           color: color,
            //           size: iconSize,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(ChatHistoryPage.routeName,
                      arguments: _profileDetailsList[0]['Chat_Unique_Id']);
                },
                child: Container(
                  width: width - 16,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Chats'),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: color,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(InternalPrivacyPolicy.routeName);
                },
                child: Container(
                  width: width - 16,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Privacy Policy'),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: color,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),
            ),
            // const Divider(
            //   color: Colors.grey,
            //   // thickness: 5,
            // ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.offAll(() => const LogInPage(title: ''));
                Provider.of<Authenticate>(context, listen: false).logout();
              },
              child: Container(
                  height: 42,
                  width: width - 28,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red)),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
