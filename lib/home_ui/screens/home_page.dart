import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/profile_setup_page.dart';
import 'package:oota_business/home_ui/widgets/menu_page.dart';
import 'package:oota_business/home_ui/widgets/orders_page.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);
  static const routeName = '/HomePageScreen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    OrdersPage(),
    MenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    var data = Get.arguments;

    if (data != null) {
      _selectedIndex = data;
    }

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        if (value['Response_Body'].isEmpty) {
          // EasyLoading.dismiss();
          Get.toNamed(ProfileSetUpPage.routeName);
        }
      });
    });
    checkUpdate();
    super.initState();
  }

  UpgradeAlert checkUpdate() {
    return UpgradeAlert(
      upgrader: Upgrader(),
      child: const Center(
        child: Text('Checking'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 30,
              height: 30,
              child: Image.asset(
                'assets/images/restaurant-menu.png',
                fit: BoxFit.fill,
              ),
            ),
            label: 'Menu',
          ),
        ],

        type: BottomNavigationBarType.shifting,

        showUnselectedLabels: true,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        elevation: 0,
        // selectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
