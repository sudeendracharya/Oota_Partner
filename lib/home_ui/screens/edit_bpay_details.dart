import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:provider/provider.dart';

class EditbPayDetails extends StatefulWidget {
  EditbPayDetails({Key? key}) : super(key: key);
  static const routeName = '/EditbankDetails';

  @override
  _EditbPayDetailsState createState() => _EditbPayDetailsState();
}

class _EditbPayDetailsState extends State<EditbPayDetails> {
  final GlobalKey<FormState> _bankPaymentFormKey = GlobalKey();
  final GlobalKey<FormState> _bPayPaymentFormKey = GlobalKey();

  var _bPayNumber;
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
  var bankDetailsSelected = false;

  var bPaySelected = false;

  Future<void> save() async {
    _bPayPaymentFormKey.currentState!.save();
    // print(bPaySetUp);

    EasyLoading.show();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .updateBpayDetails(bPaySetUp, bPaySetUp['Profile'], token)
          .then((value) async {
        if (value['StatusCode'] == 202 || value['StatusCode'] == 201) {
          EasyLoading.showSuccess('Success');
          Get.back();
        } else {
          EasyLoading.showError('Failed with Error');
        }
      });
    });
  }

  @override
  void initState() {
    var data = Get.arguments;
    _bPayNumber = data['BPay'];
    bPaySetUp['Profile'] = data['Profile_Id'];
    Provider.of<ApiCalls>(context, listen: false).generalException.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Edit bank Details',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(color: Colors.black)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: paymentDetails(width),
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
        // Row(
        //   children: [
        //     Checkbox(
        //         value: bankDetailsSelected,
        //         onChanged: (value) {
        //           setState(() {
        //             bankDetailsSelected = value!;
        //             bPaySelected = false;
        //           });
        //         }),
        //     const Text('Add Bank Details')
        //   ],
        // ),
        // bankDetailsSelected == false
        //     ? SizedBox()
        //     : Form(
        //         key: _bankPaymentFormKey,
        //         child: Padding(
        //           padding: const EdgeInsets.only(top: 8.0),
        //           child: Column(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 15.0,
        //                 ),
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Container(
        //                       width: width / 1.3,
        //                       padding: const EdgeInsets.only(bottom: 12),
        //                       child: const Text('Name'),
        //                     ),
        //                     Container(
        //                       width: width / 1.3,
        //                       height: 40,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(8),
        //                         color: Colors.white,
        //                         border: Border.all(color: Colors.black26),
        //                       ),
        //                       child: Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 12, vertical: 6),
        //                         child: TextFormField(
        //                           decoration: const InputDecoration(
        //                               hintText: 'Enter Name',
        //                               border: InputBorder.none),
        //                           validator: (value) {
        //                             if (value!.isEmpty) {
        //                               // showError('FirmCode');
        //                               return '';
        //                             }
        //                           },
        //                           onSaved: (value) {
        //                             bankPaymentSetUp['Bank_Name'] = value;
        //                           },
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 24.0,
        //                 ),
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Container(
        //                       width: width / 1.3,
        //                       padding: const EdgeInsets.only(bottom: 12),
        //                       child: const Text('BSD'),
        //                     ),
        //                     Container(
        //                       width: width / 1.3,
        //                       height: 40,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(8),
        //                         color: Colors.white,
        //                         border: Border.all(color: Colors.black26),
        //                       ),
        //                       child: Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 12, vertical: 6),
        //                         child: TextFormField(
        //                           decoration: const InputDecoration(
        //                               hintText: 'Enter BSD',
        //                               border: InputBorder.none),
        //                           validator: (value) {
        //                             if (value!.isEmpty) {
        //                               // showError('FirmCode');
        //                               return '';
        //                             }
        //                           },
        //                           onSaved: (value) {
        //                             bankPaymentSetUp['BSB'] = value;
        //                           },
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 24.0,
        //                 ),
        //                 child: Column(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     Container(
        //                       width: width / 1.3,
        //                       padding: const EdgeInsets.only(bottom: 12),
        //                       child: const Text('Account Number'),
        //                     ),
        //                     Container(
        //                       width: width / 1.3,
        //                       height: 40,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(8),
        //                         color: Colors.white,
        //                         border: Border.all(color: Colors.black26),
        //                       ),
        //                       child: Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 12, vertical: 6),
        //                         child: TextFormField(
        //                           decoration: const InputDecoration(
        //                               hintText: 'Account Number',
        //                               border: InputBorder.none),
        //                           validator: (value) {
        //                             if (value!.isEmpty) {
        //                               // showError('FirmCode');
        //                               return '';
        //                             }
        //                           },
        //                           onSaved: (value) {
        //                             bankPaymentSetUp['Account_Number'] = value;
        //                           },
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 8.0),
        //   child: Row(
        //     children: [
        //       Checkbox(
        //           value: bPaySelected,
        //           onChanged: (value) {
        //             setState(() {
        //               bPaySelected = value!;
        //               bankDetailsSelected = false;
        //             });
        //           }),
        //       const Text('Add BPay')
        //     ],
        //   ),
        // ),
        // bPaySelected == false
        //     ? SizedBox()
        //     :
        Form(
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
                      width: width / 1.3,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('BPay Number'),
                    ),
                    Container(
                      width: width / 1.3,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: TextFormField(
                          initialValue: _bPayNumber ?? '',
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
                            itemBuilder: (BuildContext context, int index) {
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
                                      value.generalException[index]['value']
                                              [0] ??
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

        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(onPressed: save, child: const Text('Update')),
        )
      ],
    );
  }
}
