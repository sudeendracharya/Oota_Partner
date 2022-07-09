import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/colors.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/styles.dart';
import 'package:provider/provider.dart';

class AddCouponsPage extends StatefulWidget {
  AddCouponsPage({Key? key}) : super(key: key);
  static const routeName = '/AddCouponsPage';

  @override
  State<AddCouponsPage> createState() => _AddCouponsPageState();
}

enum deductFrom { deliveryCharge, totalFoodPricee }

class _AddCouponsPageState extends State<AddCouponsPage> {
  deductFrom selectedDeduction = deductFrom.totalFoodPricee;
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController couponController = TextEditingController();
  Map<String, dynamic> couponDetails = {
    'Profile': '',
    'Coupon': '',
    'Start_Date': '',
    'End_Date': '',
    'Discount': '0',
    'Discount_Purpose': '',
  };

  List _profileDetails = [];

  int _startDate = 0;

  double _errorSize = 80;

  @override
  void initState() {
    super.initState();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        couponDetails['Profile'] = _profileDetails[0]['Profile_Id'];
        couponDetails['Discount_Purpose'] = 'Total_Food_Price';
        // print(couponDetails['Discount_Purpose']);
      });
    });
  }

  //Delivery
  //Total_Food_Price
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  void _fromDatePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themeColor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      _startDate = pickedDate.millisecondsSinceEpoch;
      fromDateController.text =
          DateFormat('dd-MM-yyyy   (HH-mm-ss)').format(pickedDate);
      couponDetails['Start_Date'] =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

      setState(() {});
    });
  }

  void _toDatePicker() {
    showDatePicker(
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ProjectColors.themeColor, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.green, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!);
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //  _endDate = pickedDate;
      if (_startDate != 0) {
        if (_startDate > pickedDate.millisecondsSinceEpoch) {
          Get.defaultDialog(
              title: 'Alert',
              middleText: 'To date cannot be less than from date',
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
        toDateController.text =
            DateFormat('dd-MM-yyyy  (23-59-00)').format(pickedDate);
        couponDetails['End_Date'] =
            DateFormat("yyyy-MM-dd'T'23:59:00'Z'").format(pickedDate);
//yyyy-MM-ddTHH:mm:ss.mmmuuuZ
        setState(() {});
      } else {
        Get.defaultDialog(
            title: 'Alert',
            middleText: 'Please select the start date first',
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
  }

  bool validate = true;
  void save() {
    validate = _formKey.currentState!.validate();
    if (validate != true) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();
    print(couponDetails);
    EasyLoading.show();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .addCouponsData(couponDetails, token)
          .then((value) {
        EasyLoading.dismiss();
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          Get.back(result: 'Success');
          Get.showSnackbar(const GetSnackBar(
            title: 'Success',
            message: 'Successfully added the coupon',
            duration: Duration(seconds: 2),
          ));
        } else {
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

//coupon code should not contaion spaces and everything should be caps
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    _profileDetails =
        Provider.of<ApiCalls>(context, listen: false).profileDetails;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Coupons',
          style: ProjectStyles.appbarTitleStyle(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width * 0.8,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'Coupon Code Name'),
                          // TextSpan(
                          //     text: '*', style: TextStyle(color: Colors.red))
                        ]),
                      ),
                    ),
                    Container(
                      width: width * 0.8,
                      height: validate == true ? 40 : _errorSize,
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
                          controller: couponController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                              hintText: 'Enter coupon code name',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              // showError('FirmCode');
                              return 'Name cannot be empty';
                            } else if (value.contains(' ')) {
                              return 'Code name should not contain any spaces';
                            }
                          },
                          onSaved: (value) {
                            couponDetails['Coupon'] = value?.toUpperCase();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                gapSize(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.8,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'From Date'),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red))
                        ]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.7,
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
                              controller: fromDateController,
                              enabled: false,
                              decoration: const InputDecoration(
                                  hintText: 'From date',
                                  border: InputBorder.none),

                              // onSaved: (value) {
                              //   couponDetails['Start_Date'] = value;
                              // },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: _fromDatePicker,
                            icon: Icon(
                              Icons.date_range_outlined,
                              color: ProjectColors.themeColor,
                              size: 30,
                            ))
                      ],
                    ),
                  ],
                ),
                gapSize(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.8,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text.rich(
                        TextSpan(children: [
                          TextSpan(text: 'To Date'),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red))
                        ]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.7,
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
                              controller: toDateController,
                              enabled: false,
                              decoration: const InputDecoration(
                                  hintText: 'To date',
                                  border: InputBorder.none),

                              // onSaved: (value) {
                              //   couponDetails['End_Date'] = value;
                              // },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: _toDatePicker,
                            icon: Icon(
                              Icons.date_range_outlined,
                              color: ProjectColors.themeColor,
                              size: 30,
                            ))
                      ],
                    ),
                  ],
                ),
                gapSize(),
                selectedDeduction == deductFrom.deliveryCharge
                    ? const SizedBox()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: width * 0.8,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text.rich(
                              TextSpan(children: [
                                TextSpan(text: 'Discount %'),
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red))
                              ]),
                            ),
                          ),
                          Container(
                            width: width * 0.8,
                            height: validate == true ? 40 : _errorSize,
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
                                    suffixIcon: Icon(
                                      Icons.percent,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Enter discount %',
                                    border: InputBorder.none),
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     // showError('FirmCode');
                                //     return 'discount percentage cannot be empty';
                                //   }
                                // },
                                onSaved: (value) {
                                  couponDetails['Discount'] = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                gapSize(),
                Row(
                  children: [
                    Radio(
                        activeColor: ProjectColors.themeColor,
                        value: deductFrom.deliveryCharge,
                        groupValue: selectedDeduction,
                        onChanged: (value) {
                          setState(() {
                            selectedDeduction = value as deductFrom;
                            couponDetails['Discount_Purpose'] = 'Delivery';
                          });
                        }),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Waive Delivery Charges'),
                  ],
                ),
                gapSize(),
                Row(
                  children: [
                    Radio(
                        activeColor: ProjectColors.themeColor,
                        value: deductFrom.totalFoodPricee,
                        groupValue: selectedDeduction,
                        onChanged: (value) {
                          setState(() {
                            selectedDeduction = value as deductFrom;
                            couponDetails['Discount_Purpose'] =
                                'Total_Food_Price';
                          });
                        }),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Discount % on Total Food Price'),
                  ],
                ),
                gapSize(),
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
                gapSize(),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: width * 0.6,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ProjectColors.themeColor),
                      ),
                      onPressed: save,
                      child: const Text('Add'),
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

  SizedBox gapSize() {
    return const SizedBox(
      height: 20,
    );
  }
}
