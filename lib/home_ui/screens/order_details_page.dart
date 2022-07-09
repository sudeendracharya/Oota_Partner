import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/colors.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:provider/provider.dart';

import '../../chat.dart';
import '../../helper/helperfunctions.dart';
import '../../services/database.dart';

class OrderDetailsPage extends StatefulWidget {
  OrderDetailsPage({Key? key}) : super(key: key);

  static const routeName = '/OrderDetailsPage';

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String, dynamic> orderDetails = {};

  var date;

  var status;
  var section;

  TextEditingController acceptDateController = TextEditingController();

  TextEditingController acceptTimeController = TextEditingController();

  TextEditingController cancelReasonController = TextEditingController();

  List _profileDetailsList = [];

  var profileCode;

  var hotelName;
  @override
  void initState() {
    status = null;
    var data = Get.arguments;

    print(data);

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

    if (data != null) {
      print('data is not null');
      section = data['Section'];
      print(section);

      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false)
            .fetchOrderDetails(data['Order_Id'], token)
            .then((value) => null);
      });
    }

    super.initState();
  }

  void reRun() {
    setState(() {});
  }

  TextStyle generalStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ));
  }

  TextStyle specialStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ));
  }

  Future<void> selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 15),
    );
    acceptTimeController.text = newTime!.format(context).characters.toString();
  }

  void startDatePicker() {
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
      // _startDate = pickedDate.millisecondsSinceEpoch;
      acceptDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      // startDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(pickedDate);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    orderDetails = Provider.of<ApiCalls>(context).orderDetails;
    if (orderDetails.isNotEmpty) {
      date = DateFormat.yMMMEd()
          .format(DateTime.parse(orderDetails['Created_On']));
      if (orderDetails['Status'] == '' || orderDetails['Status'] == null) {
        status = 'Pending';
      } else {
        status = orderDetails['Status'];
      }
    }
    _profileDetailsList = Provider.of<ApiCalls>(
      context,
    ).profileDetails;

    if (_profileDetailsList.isNotEmpty) {
      profileCode = _profileDetailsList[0]['Profile_Code'];
      hotelName = _profileDetailsList[0]['Business_Name'];
    }
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'false');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Order Details',
            style: GoogleFonts.roboto(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summery',
                  style: GoogleFonts.roboto(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status',
                      style: specialStyle(),
                    ),
                    Text(
                      status ?? '',
                      style: generalStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: specialStyle(),
                    ),
                    Text(
                      '${orderDetails['First_Name'] ?? ''}${orderDetails['Last_Name'] ?? ''}',
                      style: generalStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Address',
                      style: specialStyle(),
                    ),
                    Container(
                      width: width * 0.3,
                      alignment: Alignment.topRight,
                      child: Text(
                        orderDetails['Street'] ?? '',
                        style: generalStyle(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mobile Number',
                      style: specialStyle(),
                    ),
                    Text(
                      orderDetails['Mobile'] ?? '',
                      style: generalStyle(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Code',
                      style: specialStyle(),
                    ),
                    Text(
                      orderDetails['Order_Code'] ?? '',
                      style: generalStyle(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Date',
                      style: specialStyle(),
                    ),
                    Text(
                      date ?? '',
                      style: generalStyle(),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Text(
                        'Item Details',
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                orderDetails.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orderDetails['Items'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  orderDetails['Items'][index]['Food_Quantity']
                                      .toString(),
                                  style: generalStyle(),
                                ),
                                Text(
                                  ' X ',
                                  style: generalStyle(),
                                ),
                                Text(
                                  orderDetails['Items'][index]['Food_Name'],
                                  style: generalStyle(),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${orderDetails['Items'][index]['Total_Food_Price'].toString()} \$',
                                      style: generalStyle(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Text(
                      'Service Fee',
                      style: specialStyle()
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${orderDetails['Service_fee'].toString()} \$',
                          style: generalStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                orderDetails['Applied_Coupons'] == null
                    ? const SizedBox()
                    : orderDetails['Applied_Coupons'].isEmpty
                        ? const SizedBox()
                        : orderDetails['Applied_Coupons'][0]
                                    ['Discount_Purpose'] ==
                                'Total_Food_Price'
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Coupon Applied (${orderDetails['Applied_Coupons'][0]['Coupon']})',
                                      style: specialStyle().copyWith(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${orderDetails['Applied_Coupons'][0]['Discount']} %',
                                          style: generalStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                orderDetails['Applied_Coupons'] == null
                    ? const SizedBox()
                    : orderDetails['Applied_Coupons'].isEmpty
                        ? orderDetails['Delivery_Type'] == 'Self Pick-Up'
                            ? Row(
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: specialStyle().copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0 \$',
                                        style: generalStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: specialStyle()
                                      ..copyWith(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${orderDetails['Delivery_Charge']} \$',
                                        style: generalStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : orderDetails['Delivery_Type'] == 'Self Pick-Up' &&
                                orderDetails['Applied_Coupons'][0]
                                        ['Discount_Purpose'] ==
                                    'Total_Food_Price'
                            ? Row(
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: specialStyle().copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '0 \$',
                                        style: generalStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: specialStyle().copyWith(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${orderDetails['Delivery_Charge']} \$',
                                        style: generalStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                orderDetails['Applied_Coupons'] == null
                    ? const SizedBox()
                    : orderDetails['Applied_Coupons'].isEmpty
                        ? const SizedBox()
                        : orderDetails['Applied_Coupons'][0]
                                    ['Discount_Purpose'] ==
                                'Delivery'
                            ? Row(
                                children: [
                                  Text(
                                    'Coupon Applied (${orderDetails['Applied_Coupons'][0]['Coupon']})',
                                    style: specialStyle().copyWith(
                                        fontSize: 14, color: Colors.green),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '- ${orderDetails['Delivery_Charge']} \$',
                                        style: generalStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Grand Total',
                      style: specialStyle(),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${orderDetails['Price'].toString()} \$',
                          style: generalStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Paid Through',
                      style: specialStyle(),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          orderDetails['Payment_Type'] ?? '',
                          style: generalStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Payment process',
                      style: specialStyle(),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          orderDetails['Payment_Type'] == 'Paid on Delivery'
                              ? 'Pending'
                              : 'Success',
                          style: generalStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Delivery Type',
                      style: specialStyle(),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          orderDetails['Delivery_Type'] ?? '',
                          style: generalStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),

                orderDetails['Preparation_Time'] == '00:00:00'
                    ? const SizedBox()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Your food will be ready on ${orderDetails['Preparation_Date'] ?? ''} at ${orderDetails['Preparation_Time'] ?? ''}',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                // Text(
                //   'Preparation Date:',
                //   style: specialStyle(),
                // ),
                // Text(
                //   _orderDetails['Preparation_Date'] ?? '',
                //   style: generalStyle(),
                // ),

                // Expanded(
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(
                //       orderDetails['Delivery_Type'] ?? '',
                //       style: generalStyle(),
                //     ),
                //   ),
                // ),

                const SizedBox(
                  height: 30,
                ),
                section == 'New_Orders'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.dialog(Dialog(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      var size = MediaQuery.of(context).size;
                                      var containerWidth = size.width * 0.8;
                                      var containerHeight = size.height * 0.5;
                                      return Container(
                                        width: containerWidth,
                                        height: containerHeight,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: containerWidth * 0.05,
                                              vertical: containerHeight * 0.05),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Please provide a valid reason here which will be sent to customer',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: containerWidth * 0.7,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextFormField(
                                                        maxLines: 4,
                                                        controller:
                                                            cancelReasonController,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          // labelText:
                                                          //     'Enter reason here',
                                                          hintText:
                                                              'Enter reason here',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              Container(
                                                width: containerWidth * 0.3,
                                                height: containerHeight * 0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      if (cancelReasonController
                                                              .text !=
                                                          '') {
                                                        EasyLoading.show();
                                                        print(
                                                          orderDetails[
                                                              'Order_Id'],
                                                        );
                                                        Provider.of<Authenticate>(
                                                                context,
                                                                listen: false)
                                                            .tryAutoLogin()
                                                            .then((value) {
                                                          var token = Provider
                                                                  .of<Authenticate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .token;
                                                          Provider.of<ApiCalls>(
                                                                  context,
                                                                  listen: false)
                                                              .updateOrders(
                                                                  {
                                                                'Order_Id':
                                                                    orderDetails[
                                                                        'Order_Id'],
                                                                'Status':
                                                                    'Decline',
                                                                'Cancel_Description':
                                                                    cancelReasonController
                                                                        .text,
                                                              },
                                                                  orderDetails[
                                                                      'Order_Id'],
                                                                  token).then((value) async {
                                                            if (value == 202 ||
                                                                value == 201) {
                                                              EasyLoading
                                                                  .showSuccess(
                                                                      'Success Notification Sent to User Mobile');
                                                              Get.back(
                                                                  result:
                                                                      'Success');
                                                              // widget.data(200);
                                                            } else {
                                                              EasyLoading.showError(
                                                                  'Unable To Accept the order Please try Again');
                                                            }
                                                          });
                                                        });
                                                      } else {
                                                        Get.defaultDialog(
                                                          title: 'Alert',
                                                          middleText:
                                                              'Please provide a valid reason in-order to Deny/Cancel',
                                                          confirm: TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'Ok',
                                                              style: TextStyle(
                                                                  color: ProjectColors
                                                                      .themeColor),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Decline',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                              },
                              child: Container(
                                width: 70,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Decline',
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  // print(orderDetails['Email']);
                                  if (orderDetails['Email'] != null) {
                                    sendMessage(
                                        orderDetails['Email'],
                                        orderDetails['Order_Code'],
                                        orderDetails['Firebase_User_Id'] ?? '',
                                        orderDetails['First_Name'] ?? '',
                                        _profileDetailsList[0]
                                            ['Chat_Unique_Id']);
                                  }
                                },
                                icon: const Icon(
                                  Icons.message,
                                  size: 35,
                                )),
                            GestureDetector(
                              onTap: () {
                                acceptTimeController.text = DateFormat.jm()
                                    .format(DateTime.now())
                                    .toString();
                                acceptDateController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(DateTime.now());
                                Get.dialog(Dialog(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      var size = MediaQuery.of(context).size;
                                      var containerWidth = size.width * 0.8;
                                      var containerHeight = size.height * 0.5;
                                      return Container(
                                        width: containerWidth,
                                        height: containerHeight,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: containerWidth * 0.05,
                                              vertical: containerHeight * 0.05),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Please select the date and time when the food will be ready for Pick-up/Delivery',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              InkWell(
                                                onTap: startDatePicker,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:
                                                          containerWidth * 0.6,
                                                      child: TextFormField(
                                                        controller:
                                                            acceptDateController,
                                                        enabled: false,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Select date',
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          containerWidth * 0.2,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Icon(
                                                        Icons
                                                            .date_range_outlined,
                                                        color: ProjectColors
                                                            .themeColor,
                                                        size: 35,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              InkWell(
                                                onTap: selectTime,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:
                                                          containerWidth * 0.6,
                                                      child: TextFormField(
                                                        controller:
                                                            acceptTimeController,
                                                        enabled: false,
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Select time',
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      width:
                                                          containerWidth * 0.2,
                                                      child: Icon(
                                                        Icons.av_timer_rounded,
                                                        color: ProjectColors
                                                            .themeColor,
                                                        size: 35,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              Container(
                                                width: containerWidth * 0.3,
                                                height: containerHeight * 0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.green,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      if (acceptDateController
                                                                  .text !=
                                                              '' &&
                                                          acceptTimeController
                                                                  .text !=
                                                              '') {
                                                        EasyLoading.show();
                                                        // print(orderDetails['Order_Id']);
                                                        Provider.of<Authenticate>(
                                                                context,
                                                                listen: false)
                                                            .tryAutoLogin()
                                                            .then((value) {
                                                          var token = Provider
                                                                  .of<Authenticate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .token;
                                                          Provider.of<ApiCalls>(
                                                                  context,
                                                                  listen: false)
                                                              .updateOrders(
                                                                  {
                                                                'Order_Id':
                                                                    orderDetails[
                                                                        'Order_Id'],
                                                                'Status':
                                                                    'Accept',
                                                                'Preparation_Date':
                                                                    acceptDateController
                                                                        .text,
                                                                'Preparation_Time':
                                                                    acceptTimeController
                                                                        .text,
                                                              },
                                                                  orderDetails[
                                                                      'Order_Id'],
                                                                  token).then((value) async {
                                                            if (value == 202 ||
                                                                value == 201) {
                                                              EasyLoading
                                                                  .showSuccess(
                                                                      'Success Notification Sent to User Mobile');
                                                              Get.back(
                                                                  result:
                                                                      'Success');

                                                              // widget.data(200);
                                                            } else {
                                                              EasyLoading.showError(
                                                                  'Unable To Accept the order Please try Again');
                                                            }
                                                          });
                                                        });
                                                      } else {
                                                        Get.defaultDialog(
                                                          title: 'Alert',
                                                          middleText:
                                                              'Please select date and time in order to accept the order',
                                                          confirm: TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'Ok',
                                                              style: TextStyle(
                                                                  color: ProjectColors
                                                                      .themeColor),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                              },
                              child: Container(
                                width: 70,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Accept',
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                section == 'Preparing'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Container(
                            //   width: 70,
                            //   height: 30,
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.red),
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: Text('Deny'),
                            // ),
                            GestureDetector(
                              onTap: () {
                                EasyLoading.show();
                                // print(orderDetails['Order_Id']);
                                Provider.of<Authenticate>(context,
                                        listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  var token = Provider.of<Authenticate>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<ApiCalls>(context, listen: false)
                                      .updateOrders({
                                    'Order_Id': orderDetails['Order_Id'],
                                    'Status': 'Ready'
                                  }, orderDetails['Order_Id'],
                                          token).then((value) async {
                                    if (value == 202 || value == 201) {
                                      EasyLoading.showSuccess(
                                          'Success Notification Sent to User Mobile');
                                      Get.back(result: 'Success');
                                      // widget.data(200);
                                    } else {
                                      EasyLoading.showError(
                                          'Unable To Accept the order Please try Again');
                                    }
                                  });
                                });
                              },
                              child: Container(
                                width: 70,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Ready',
                                  style:
                                      GoogleFonts.roboto(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                section == 'Ready'
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Container(
                            //   width: 70,
                            //   height: 30,
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(color: Colors.red),
                            //       borderRadius: BorderRadius.circular(10)),
                            //   child: Text('Deny'),
                            // ),
                            GestureDetector(
                              onTap: () {
                                Get.dialog(Dialog(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context, setState) {
                                      var size = MediaQuery.of(context).size;
                                      var containerWidth = size.width * 0.8;
                                      var containerHeight = size.height * 0.5;
                                      return Container(
                                        width: containerWidth,
                                        height: containerHeight,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: containerWidth * 0.05,
                                              vertical: containerHeight * 0.05),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Please provide a valid reason here which will be sent to customer',
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: containerWidth * 0.7,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: TextFormField(
                                                        maxLines: 4,
                                                        controller:
                                                            cancelReasonController,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          // labelText:
                                                          //     'Enter reason here',
                                                          hintText:
                                                              'Enter reason here',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: containerHeight * 0.1,
                                              ),
                                              Container(
                                                width: containerWidth * 0.3,
                                                height: containerHeight * 0.13,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(
                                                        Colors.red,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                      if (cancelReasonController
                                                              .text !=
                                                          '') {
                                                        EasyLoading.show();
                                                        print(
                                                          orderDetails[
                                                              'Order_Id'],
                                                        );
                                                        Provider.of<Authenticate>(
                                                                context,
                                                                listen: false)
                                                            .tryAutoLogin()
                                                            .then((value) {
                                                          var token = Provider
                                                                  .of<Authenticate>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .token;
                                                          Provider.of<ApiCalls>(
                                                                  context,
                                                                  listen: false)
                                                              .updateOrders(
                                                                  {
                                                                'Order_Id':
                                                                    orderDetails[
                                                                        'Order_Id'],
                                                                'Status':
                                                                    'Failed',
                                                                'Cancel_Description':
                                                                    cancelReasonController
                                                                        .text,
                                                              },
                                                                  orderDetails[
                                                                      'Order_Id'],
                                                                  token).then((value) async {
                                                            if (value == 202 ||
                                                                value == 201) {
                                                              EasyLoading
                                                                  .showSuccess(
                                                                      'Success Notification Sent to User Mobile');
                                                              Get.back(
                                                                  result:
                                                                      'Success');
                                                              // widget.data(200);
                                                            } else {
                                                              EasyLoading.showError(
                                                                  'Unable To Accept the order Please try Again');
                                                            }
                                                          });
                                                        });
                                                      } else {
                                                        Get.defaultDialog(
                                                          title: 'Alert',
                                                          middleText:
                                                              'Please provide a valid reason in-order to Deny/Cancel',
                                                          confirm: TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'Ok',
                                                              style: TextStyle(
                                                                  color: ProjectColors
                                                                      .themeColor),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Decline',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ));
                                // EasyLoading.show();
                                // // print(orderDetails['Order_Id']);
                                // Provider.of<Authenticate>(context,
                                //         listen: false)
                                //     .tryAutoLogin()
                                //     .then((value) {
                                //   var token = Provider.of<Authenticate>(context,
                                //           listen: false)
                                //       .token;
                                //   Provider.of<ApiCalls>(context, listen: false)
                                //       .updateOrders({
                                //     'Order_Id': orderDetails['Order_Id'],
                                //     'Status': 'Failed'
                                //   }, orderDetails['Order_Id'],
                                //           token).then((value) async {
                                //     if (value == 202 || value == 201) {
                                //       EasyLoading.showSuccess(
                                //           'Success Notification Sent to User Mobile');
                                //       Get.back(result: 'Success');
                                //       // widget.data(200);
                                //     } else {
                                //       EasyLoading.showError(
                                //           'Unable To Accept the order Please try Again');
                                //     }
                                //   });
                                // });
                              },
                              child: Container(
                                width: 80,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Cancel'),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                EasyLoading.show();
                                // print(orderDetails['Order_Id']);
                                Provider.of<Authenticate>(context,
                                        listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  var token = Provider.of<Authenticate>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<ApiCalls>(context, listen: false)
                                      .updateOrders({
                                    'Order_Id': orderDetails['Order_Id'],
                                    'Status': 'PickedUp'
                                  }, orderDetails['Order_Id'],
                                          token).then((value) async {
                                    if (value == 202 || value == 201) {
                                      EasyLoading.showSuccess(
                                          'Success Notification Sent to User Mobile');
                                      Get.back(result: 'Success');
                                      // widget.data(200);
                                    } else {
                                      EasyLoading.showError(
                                          'Unable To Accept the order Please try Again');
                                    }
                                  });
                                });
                              },
                              child: Container(
                                width: 90,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Picked Up',
                                    style:
                                        GoogleFonts.roboto(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                EasyLoading.show();
                                // print(orderDetails['Order_Id']);
                                Provider.of<Authenticate>(context,
                                        listen: false)
                                    .tryAutoLogin()
                                    .then((value) {
                                  var token = Provider.of<Authenticate>(context,
                                          listen: false)
                                      .token;
                                  Provider.of<ApiCalls>(context, listen: false)
                                      .updateOrders({
                                    'Order_Id': orderDetails['Order_Id'],
                                    'Status': 'Delivered'
                                  }, orderDetails['Order_Id'],
                                          token).then((value) async {
                                    if (value == 202 || value == 201) {
                                      EasyLoading.showSuccess(
                                          'Success Notification Sent to User Mobile');
                                      Get.back(result: 'Success');
                                      // widget.data(200);
                                    } else {
                                      EasyLoading.showError(
                                          'Unable To Accept the order Please try Again');
                                    }
                                  });
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Delivered',
                                    style:
                                        GoogleFonts.roboto(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DatabaseMethods databaseMethods = DatabaseMethods();

  sendMessage(String userEmail, String chatId, String userId,
      String customerName, String partnerUniqueId) async {
    var myName = await HelperFunctions.getUserNameSharedPreference();
    List<String> users = [partnerUniqueId, userId];

    // Map<String,dynamic> firstPersonMessageCount={};

    // print(myName);
    // print(userName);

    String chatRoomId = profileCode + userId;

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
      'displayName': hotelName,
      'customerName': customerName,
    };

    print(chatRoom);

    // databaseMethods.getUserChatRoom(chatRoomId).then((value) {
    //   print('chatRoomId ${value.toString()}');

    //   print('value ${value.docs.toString()}');
    // });

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
          customerUniqueId: userId,
          customerName: customerName,
          partnerUniqueId: partnerUniqueId,
        ),
      ),
    );
  }
}
