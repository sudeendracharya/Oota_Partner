import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/helper/helperfunctions.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/order_details_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../chat.dart';
import '../../services/database.dart';

class NewOrdersPage extends StatefulWidget {
  NewOrdersPage({Key? key}) : super(key: key);

  @override
  _NewOrdersPageState createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  List _ordersList = [];

  var _profileId;

  bool _activeOrders = true;

  @override
  void initState() {
    getProfile().then((value) {
      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        if (_profileId == null) {
          Provider.of<ApiCalls>(context, listen: false)
              .fetchProfileDetails(token)
              .then((value) async {
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
              if (value['Response_Body'].isEmpty) {
              } else {
                Provider.of<ApiCalls>(context, listen: false)
                    .fetchOrders(value['Response_Body'][0]['Profile_Id'], token)
                    .then((value) async {
                  if (value == 200 || value == 201) {
                    condition();
                  }
                });
                final profilePrefs = await SharedPreferences.getInstance();
                final userData = json.encode(
                  {
                    'profileId': value['Response_Body'][0]['Profile_Id'],
                  },
                );
                profilePrefs.setString('profile', userData);
              }
            }
          });
        } else {
          Provider.of<ApiCalls>(context, listen: false)
              .fetchOrders(_profileId, token)
              .then((value) async {
            if (value == 200 || value == 201) {
              condition();
            }
          });
        }
      });
    });

    super.initState();
  }

  void condition() {
    if (_ordersList.isEmpty) {
      setState(() {
        _activeOrders = false;
      });
    }
  }

  Future<void> getProfile() async {
    // print('Entering Profile Section');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('profile')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('profile')!) as Map<String, dynamic>;

    _profileId = extratedUserData['profileId'];
  }

  void fetchOrders(int data) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchOrders(_profileId, token)
          .then((value) async {
        if (value == 200 || value == 201) {
          condition();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _ordersList = Provider.of<ApiCalls>(context).newOrdersList;
    var height = MediaQuery.of(context).size.height;
    return _ordersList.isEmpty && _activeOrders == false
        ? Padding(
            padding: EdgeInsets.only(top: height * 0.35),
            child: const Align(
                alignment: Alignment.topCenter,
                child: Text('No new orders to display')),
          )
        :
        // _ordersList.isEmpty
        // ? Container(
        //     height: height,
        //     child: Center(
        //       child: Text('You dont have any orders to display Yet'),
        //     ),
        //   )
        // :
        Padding(
            padding: const EdgeInsets.only(bottom: 150.0),
            child: ListView.builder(
              itemCount: _ordersList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    String result = await Get.toNamed(
                      OrderDetailsPage.routeName,
                      arguments: {
                        'Order_Id': _ordersList[index]['Order_Id'],
                        'Section': 'New_Orders'
                      },
                    );

                    if (result == 'Success') {
                      fetchOrders(100);
                    }
                  },
                  child: OrderItem(
                    data: fetchOrders,
                    key: UniqueKey(),
                    orderId: _ordersList[index]['Order_Id'],
                    orderCode: _ordersList[index]['Order_Code'] ?? '',
                    createdOn: _ordersList[index]['Created_On'],
                    totalPrice: _ordersList[index]['Price'].toString(),
                    items: _ordersList[index]['Items'],
                    address:
                        '${_ordersList[index]['Street']}, ${_ordersList[index]['City']}, ${_ordersList[index]['State']}, ${_ordersList[index]['Zip_Code'].toString()}',
                    latitude: _ordersList[index]['Latitude'].toString(),
                    longitude: _ordersList[index]['Longitude'].toString(),
                    email: _ordersList[index]['Email'].toString(),
                  ),
                );
              },
            ),
          );
  }
}

class OrderItem extends StatefulWidget {
  OrderItem(
      {Key? key,
      required this.orderId,
      required this.orderCode,
      required this.createdOn,
      required this.totalPrice,
      required this.items,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.data,
      required this.email})
      : super(key: key);

  final int orderId;
  final String orderCode;
  final String createdOn;
  final String totalPrice;
  final List items;
  final String address;
  final String latitude;
  final String longitude;
  final String email;
  final ValueChanged<int> data;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var date;
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    date = DateFormat.yMMMEd().format(DateTime.parse(widget.createdOn));
    super.initState();
  }

  // sendMessage(String userName, String chatId) async {
  //   var myName = await HelperFunctions.getUserNameSharedPreference();
  //   List<String> users = [myName!, userName];

  //   // Map<String,dynamic> firstPersonMessageCount={};

  //   // print(myName);
  //   // print(userName);

  //   String chatRoomId = chatId;

  //   Map<String, dynamic> chatRoom = {
  //     "users": users,
  //     "chatRoomId": chatRoomId,
  //   };

  //   // print(chatRoomId);
  //   // print(users);

  //   // databaseMethods.getUserChatRoom(chatRoomId).then((value) {
  //   //   print('chatRoomId ${value.toString()}');

  //   //   print('value ${value.docs.toString()}');
  //   // });

  //   databaseMethods.addChatRoom(chatRoom, chatRoomId);

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Chat(
  //         chatRoomId: chatRoomId,
  //         userName: userName,
  //         customerName: '',
  //       ),
  //     ),
  //   );
  // }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderCode,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Text(date),
                  ],
                ),
              ),
              for (var data in widget.items)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 25,
                              child: Text(data['Food_Quantity'].toString())),
                          const SizedBox(width: 20, child: Text('X')),
                          // SizedBox(
                          //     width: 30,
                          //     child:
                          //         Text('\$${data['Food_Price'].toString()}')),
                          SizedBox(
                              width: 120,
                              child: Text(
                                data['Food_Name'],
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('\$${data['Total_Food_Price'].toString()}'),
                        ],
                      )
                    ],
                  ),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Text(
                      '\$${widget.totalPrice}',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           EasyLoading.show();
              //           print(widget.orderId);
              //           Provider.of<Authenticate>(context, listen: false)
              //               .tryAutoLogin()
              //               .then((value) {
              //             var token =
              //                 Provider.of<Authenticate>(context, listen: false)
              //                     .token;
              //             Provider.of<ApiCalls>(context, listen: false)
              //                 .updateOrders({
              //               'Order_Id': widget.orderId,
              //               'Status': 'Deny'
              //             }, widget.orderId, token).then((value) async {
              //               if (value == 202 || value == 201) {
              //                 EasyLoading.showSuccess(
              //                     'Success Notification Sent to User Mobile');
              //                 widget.data(200);
              //               } else {
              //                 EasyLoading.showError(
              //                     'Unable To Accept the order Please try Again');
              //               }
              //             });
              //           });
              //         },
              //         child: Container(
              //           width: 70,
              //           height: 30,
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //               border: Border.all(color: Colors.red),
              //               borderRadius: BorderRadius.circular(10)),
              //           child: Text(
              //             'Deny',
              //             style: GoogleFonts.roboto(
              //                 textStyle:
              //                     const TextStyle(fontWeight: FontWeight.w500)),
              //           ),
              //         ),
              //       ),
              //       IconButton(
              //           onPressed: () {
              //             print(widget.email);
              //             sendMessage(widget.email, widget.orderCode);
              //           },
              //           icon: const Icon(
              //             Icons.message,
              //             size: 30,
              //           )),
              //       GestureDetector(
              //         onTap: () {
              //           EasyLoading.show();
              //           print(widget.orderId);
              //           Provider.of<Authenticate>(context, listen: false)
              //               .tryAutoLogin()
              //               .then((value) {
              //             var token =
              //                 Provider.of<Authenticate>(context, listen: false)
              //                     .token;
              //             Provider.of<ApiCalls>(context, listen: false)
              //                 .updateOrders({
              //               'Order_Id': widget.orderId,
              //               'Status': 'Accept'
              //             }, widget.orderId, token).then((value) async {
              //               if (value == 202 || value == 201) {
              //                 EasyLoading.showSuccess(
              //                     'Success Notification Sent to User Mobile');
              //                 widget.data(200);
              //               } else {
              //                 EasyLoading.showError(
              //                     'Unable To Accept the order Please try Again');
              //               }
              //             });
              //           });
              //         },
              //         child: Container(
              //           width: 70,
              //           height: 30,
              //           alignment: Alignment.center,
              //           decoration: BoxDecoration(
              //               color: Colors.green,
              //               border: Border.all(color: Colors.green),
              //               borderRadius: BorderRadius.circular(10)),
              //           child: Text(
              //             'Accept',
              //             style: GoogleFonts.roboto(
              //                 textStyle: const TextStyle(
              //                     fontWeight: FontWeight.w500,
              //                     color: Colors.white)),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
