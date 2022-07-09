import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/order_details_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllOrdersHistory extends StatefulWidget {
  AllOrdersHistory({Key? key}) : super(key: key);

  static const routeName = '/AllOrdersHistory';

  @override
  _AllOrdersHistoryState createState() => _AllOrdersHistoryState();
}

class _AllOrdersHistoryState extends State<AllOrdersHistory> {
  var _profileId;

  List _allOrdersList = [];
  var token;

  @override
  void initState() {
    getProfile().then((value) async {
      // print('Init Section');
      await Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        token = Provider.of<Authenticate>(context, listen: false).token;
      });

      if (_profileId != null) {
        // print('Profile id present');
        Provider.of<ApiCalls>(context, listen: false)
            .fetchAllOrders(_profileId, token)
            .then((value) async {
          if (value == 200 || value == 201) {}
        });
      } else {
        Provider.of<ApiCalls>(context, listen: false)
            .fetchProfileDetails(token)
            .then((value) async {
          if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
            if (value['Response_Body'].isEmpty) {
            } else {
              Provider.of<ApiCalls>(context, listen: false)
                  .fetchAllOrders(
                      value['Response_Body'][0]['Profile_Id'], token)
                  .then((value) async {
                if (value == 200 || value == 201) {}
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
      }
    });

    super.initState();
  }

  Future<void> getProfile() async {
    print('Entering Profile Section');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('profile')) {
      return;
    }
    final extratedUserData =
        //we should use dynamic as a another value not a Object
        json.decode(prefs.getString('profile')!) as Map<String, dynamic>;

    _profileId = extratedUserData['profileId'];
  }

  @override
  Widget build(BuildContext context) {
    _allOrdersList = Provider.of<ApiCalls>(
      context,
    ).allOrderHistory;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Orders History',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black)),
        ),
      ),
      body: ListView.builder(
        itemCount: _allOrdersList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                OrderDetailsPage.routeName,
                arguments: {
                  'Order_Id': _allOrdersList[index]['Order_Id'],
                  'Section': 'History'
                },
              );
            },
            child: OrderItem(
              rating: _allOrdersList[index]['Rating'] == '' ||
                      _allOrdersList[index]['Rating'] == null
                  ? 'N/A'
                  : _allOrdersList[index]['Rating'],
              orderCode: _allOrdersList[index]['Order_Code'],
              date: _allOrdersList[index]['Created_On'],
              totalPrice: _allOrdersList[index]['Price'].toString(),
              items: _allOrdersList[index]['Items'],
              status: _allOrdersList[index]['Status'],
              // businessName: _allOrdersList[index]['Order_Code']
            ),
          );
        },
      ),
    );
  }
}

class OrderItem extends StatefulWidget {
  OrderItem({
    Key? key,
    required this.orderCode,
    required this.date,
    required this.totalPrice,
    required this.items,
    required this.status,
    required this.rating,
  }) : super(key: key);

  final String orderCode;
  final String date;
  final String totalPrice;
  final List items;
  final String status;
  final String rating;
  // final String businessName;

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var date;

  @override
  void initState() {
    date = DateFormat.yMMMEd().format(DateTime.parse(widget.date));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Container(
          width: width - 30,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderCode,
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                    widget.status == 'Accept'
                        ? Text(
                            widget.status,
                            style: GoogleFonts.roboto(
                                textStyle:
                                    const TextStyle(color: Colors.green)),
                          )
                        : widget.status == 'Pending'
                            ? Text(
                                widget.status,
                                style: GoogleFonts.roboto(
                                    textStyle:
                                        const TextStyle(color: Colors.orange)),
                              )
                            : widget.status == 'Ready'
                                ? Text(
                                    widget.status,
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            color: Colors.orange)),
                                  )
                                : widget.status == 'PickedUp'
                                    ? Text(
                                        widget.status,
                                        style: GoogleFonts.roboto(
                                            textStyle: const TextStyle(
                                                color: Colors.green)),
                                      )
                                    : widget.status == 'Delivered'
                                        ? Text(
                                            widget.status,
                                            style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    color: Colors.green)),
                                          )
                                        : Text(
                                            widget.status,
                                            style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    color: Colors.orange)),
                                          )
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 15,
                            child: Text(widget.items[index]['Food_Quantity']
                                .toString())),
                        const SizedBox(width: 15, child: Text('X')),
                        SizedBox(
                            width: 120,
                            child: Text(widget.items[index]['Food_Name']))
                      ],
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(date.toString()),
                  Text(
                    '\$${widget.totalPrice}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Rating',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w500)),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 5),
                      child: Text(widget.rating),
                    ),

                    widget.rating != 'N/A'
                        ? const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          )
                        : SizedBox(),
                    // RatingBar.builder(
                    //   tapOnlyMode: false,
                    //   itemSize: 15,
                    //   initialRating: double.parse(widget.rating),
                    //   minRating: 0,
                    //   direction: Axis.horizontal,
                    //   allowHalfRating: true,
                    //   itemCount: 5,
                    //   itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //   itemBuilder: (context, _) => const Icon(
                    //     Icons.star,
                    //     color: Colors.amber,
                    //   ),
                    //   onRatingUpdate: (rating) {
                    //     print(rating);
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
