import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/side_bar_screen.dart';
import 'package:oota_business/home_ui/widgets/neworderspage.dart';
import 'package:oota_business/home_ui/widgets/preparingpage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'food_ready_page.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  bool _isSelected = false;

  bool _ready = false;

  bool _preparing = true;

  List _ordersList = [];
  int index = 0;

  @override
  void initState() {
    _tabController =
        TabController(vsync: this, length: myTabs.length, initialIndex: index);

    super.initState();
  }

  late TabController _tabController;

  static List<Tab> myTabs = <Tab>[
    Tab(
      child: Container(
        width: 100,
        height: 23,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Text(
          'New Orders',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 100,
        height: 23,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Text(
          'Preparing',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
    Tab(
      child: Container(
        width: 100,
        height: 23,
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Text(
          'Ready',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black)),
        ),
      ),
      // text: 'Administration',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    _ordersList = Provider.of<ApiCalls>(context).newOrdersList;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.search,
          //     color: Colors.black,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: SideBarScreen(),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 250),
                  inheritTheme: true,
                  ctx: context,
                ),
              );
            },
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Column(
            children: [
              Container(
                width: width,
                height: 40,
                child: TabBar(
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  isScrollable: false,
                  dragStartBehavior: DragStartBehavior.start,
                  automaticIndicatorColorAdjustment: true,
                  enableFeedback: true,
                  indicatorColor: Colors.orange,
                  indicatorWeight: 3,
                  controller: _tabController,
                  tabs: <Tab>[
                    Tab(
                      child: Container(
                        width: 100,
                        height: 23,
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //         color: index == 0 ? Colors.red : Colors.black),
                        //     borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          'New Orders',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black)),
                        ),
                      ),
                      // text: 'Administration',
                    ),
                    Tab(
                      child: Container(
                        width: 100,
                        height: 23,
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //         color: index == 1 ? Colors.red : Colors.black),
                        //     borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          'Preparing',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black)),
                        ),
                      ),
                      // text: 'Administration',
                    ),
                    Tab(
                      child: Container(
                        width: 100,
                        height: 23,
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //         color: index == 2 ? Colors.red : Colors.black),
                        //     borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          'Ready',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black)),
                        ),
                      ),
                      // text: 'Administration',
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height - 70,
                child: TabBarView(
                    dragStartBehavior: DragStartBehavior.start,
                    controller: _tabController,
                    children: [
                      NewOrdersPage(),
                      FoodPreparingPage(),
                      FoodReadyPage(),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
