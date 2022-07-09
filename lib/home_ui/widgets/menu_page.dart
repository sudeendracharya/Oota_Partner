import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/add_menu_items_page.dart';
import 'package:oota_business/home_ui/screens/edit_menu_items.dart';
import 'package:oota_business/home_ui/screens/profile_setup_page.dart';
import 'package:oota_business/home_ui/screens/side_bar_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var _profileId;

  List menuList = [];

  bool _menuList = true;

  var _businessName;

  var _userName;

  var _profilCode;

  var _deliveryCharge;

  var _businessAddress;

  var _businessCategory;

  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          if (value['Response_Body'].isNotEmpty) {
            _profileId = value['Response_Body'][0]['Profile_Id'];
            _businessName = value['Response_Body'][0]['Business_Name'];
            _userName = value['Response_Body'][0]['First_Name'] +
                value['Response_Body'][0]['Last_Name'];
            _profilCode = value['Response_Body'][0]['Profile_Code'];
            _deliveryCharge = value['Response_Body'][0]['Delivery_Charges'];
            _businessAddress = value['Response_Body'][0]['Business_Address'];
            _businessCategory = value['Response_Body'][0]
                ['Business_Category__Business_Category'];

            Provider.of<ApiCalls>(context, listen: false)
                .fetchMenuItems(
              token,
              _profileId,
            )
                .then((value) {
              if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
                print('Printing Body ${value['Body']}');
                if (value['Body'].isEmpty) {
                  setState(() {
                    _menuList = false;
                  });
                }
              }
            });
          } else {
            Get.showSnackbar(GetSnackBar(
              title: 'Alert',
              message:
                  'Looks like you have not created your profile click on create button to create your profile',
              duration: const Duration(seconds: 8),
              mainButton: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(ProfileSetUpPage.routeName);
                  },
                  child: const Text('Create')),
            ));
          }
        }
      });
    });

    super.initState();
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String link = '';

  Future<void> share() async {
    link =
        'https://www.ootaonline.com.au/page?profileid=${_profileId}&username=${_userName}&profilecode=${_profilCode}&businessname=${_businessName}&deliverycharge=${_deliveryCharge}&businessaddress=${_businessAddress}';

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://ootaconsumer.page.link',

      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse(link),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: _businessName,
        description:
            'Order food online from ${_businessName}, Get great offers and super fast food delivery when you order food online from',
        // imageUrl: Uri.parse(
        //   'https://firebasestorage.googleapis.com/v0/b/oota-dcecb.appspot.com/o/Oota-logo-final.png?alt=media&token=d4664ede-b4ef-4b12-895e-180674a7ff0a',
        // ),
      ),

      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: 'com.oota_consumer.oota',
        minimumVersion: 0,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: 'com.oota.oota-consumer',
        minimumVersion: '0',
        appStoreId: '1612945684',
      ),
    );
    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    final Uri uri = shortDynamicLink.shortUrl;

    await FlutterShare.share(
        title: 'Order from this restaurant on Oota',
        text:
            'Order from this ${_businessCategory} on Oota| ${_businessName}| ${_businessAddress}',
        linkUrl: uri.toString(),
        chooserTitle: 'Example Chooser Title');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    menuList = Provider.of<ApiCalls>(context).menuList;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'Menu',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(color: Colors.black),
              ),
            ),
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Get.toNamed(WebViewDisplayContent.routeName);
              //     // flutterLocalNotificationsPlugin.show(
              //     //   0,
              //     //   'Testing',
              //     //   'How You Doing',
              //     //   NotificationDetails(
              //     //     android: AndroidNotificationDetails(
              //     //       channel.id,
              //     //       channel.name,
              //     //       channelDescription: channel.description,
              //     //       importance: Importance.high,
              //     //       color: Colors.blue,
              //     //       playSound: true,
              //     //       icon: '@mipmap/ic_launcher',
              //     //     ),
              //     //   ),
              //     // );
              //   },
              //   icon: const Icon(Icons.search, color: Colors.black),
              // ),

              IconButton(
                onPressed: share,
                icon: const Icon(Icons.share, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const SideBarScreen(),
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
          body: menuList.isEmpty && _menuList == true
              ? const Center(
                  child: Text('Loading'),
                )
              : _menuList == false
                  ? Center(
                      child: SizedBox(
                        width: width * 0.6,
                        child: Text(
                          'Looks like you dont have any item in the menu click on add button to add items',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: ListView.builder(
                        addAutomaticKeepAlives: true,
                        itemCount: menuList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MenuItem(
                            recommended: menuList[index]['Recommended'],
                            foodName: menuList[index]['Food_Name'],
                            description: menuList[index]['Description'],
                            price: menuList[index]['Price'],
                            image: menuList[index]['Food_Image'],
                            allergen: menuList[index]['Allergen'],
                            foodId: menuList[index]['Food_Id'],
                            ingrediants: menuList[index]['Ingredients'],
                            preparationTime:
                                menuList[index]['Preparation_Time'].toString(),
                            profile: menuList[index]['Profile'],
                            inStock: menuList[index]['In_Stock'],
                            cusine: menuList[index]['Cuisine'],
                            key: UniqueKey(),
                            update: fetchMenuItems,
                          );
                        },
                      ),
                    ),
          floatingActionButton: Container(
            height: 38,
            child: FloatingActionButton.extended(
              backgroundColor: const Color.fromRGBO(255, 114, 76, 1),
              onPressed: () async {
                var result = await Get.toNamed(AddMenuItems.routeName);
                if (result == 'success') {
                  print('success');
                  print(_profileId);

                  Provider.of<Authenticate>(context, listen: false)
                      .tryAutoLogin()
                      .then((value) {
                    var token =
                        Provider.of<Authenticate>(context, listen: false).token;
                    Provider.of<ApiCalls>(context, listen: false)
                        .fetchMenuItems(
                      token,
                      _profileId,
                    )
                        .then((value) {
                      setState(() {
                        _menuList = true;
                      });

                      print(value['StatusCode']);
                    });
                  });
                }
              },
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add,
                  ),
                  Text('ADD')
                ],
              ),
            ),
          )
          //
          ),
    );
  }

  void fetchMenuItems(int data) {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      // EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          if (value['Response_Body'].isNotEmpty) {
            _profileId = value['Response_Body'][0]['Profile_Id'];

            Provider.of<ApiCalls>(context, listen: false)
                .fetchMenuItems(
              token,
              _profileId,
            )
                .then((value) {
              EasyLoading.dismiss();
              if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
                // print('Printing Body ${value['Body']}');
                // if (value['Body'].isEmpty) {
                //   setState(() {
                //     _menuList = false;
                //   });
                // }
              }
            });
          } else {
            Get.showSnackbar(GetSnackBar(
              title: 'Alert',
              message:
                  'Looks like you have not created your profile click on create button to create your profile',
              duration: const Duration(seconds: 8),
              mainButton: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(ProfileSetUpPage.routeName);
                  },
                  child: const Text('Create')),
            ));
          }
        }
      });
    });
  }
}

class MenuItem extends StatefulWidget {
  MenuItem({
    Key? key,
    required this.foodName,
    required this.description,
    required this.price,
    required this.image,
    required this.foodId,
    required this.profile,
    required this.ingrediants,
    required this.allergen,
    required this.preparationTime,
    required this.inStock,
    required this.recommended,
    required this.update,
    required this.cusine,
  }) : super(key: key);

  final String foodName;
  final String description;
  final String price;
  final String image;
  final int foodId;
  final int profile;
  final String ingrediants;
  final String allergen;
  final String preparationTime;

  bool inStock;
  bool recommended;

  final ValueChanged<int> update;
  final int cusine;

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool _isExpanded = false;

  var _profileId;

  TextStyle headingStyle() {
    return GoogleFonts.roboto(
        textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ));
  }

  // void _modalBottomSheetMenu() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (builder) {
  //         return new Container(
  //           height: 500.0,
  //           color: Colors.transparent, //could change this to Color(0xFF737373),
  //           //so you don't have to change MaterialApp canvasColor
  //           child: new Container(
  //               decoration: new BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: new BorderRadius.only(
  //                       topLeft: const Radius.circular(10.0),
  //                       topRight: const Radius.circular(10.0))),
  //               child: new Center(
  //                 child: new Text("This is a modal sheet"),
  //               )),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return _isExpanded == true
        ? Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isExpanded == true) {
                      _isExpanded = false;
                    } else {
                      _isExpanded = true;
                    }
                  });
                },
                child: Container(
                  width: width,
                  height: 410,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 180,
                            width: width - 20,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                              imageUrl: widget.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                  widget.foodName,
                                  style: headingStyle(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                    '${String.fromCharCodes(Runes('\u0024'))}${widget.price}'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(widget.description),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text('${widget.allergen}(Allergen)'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text(
                                    '${widget.preparationTime}(Preparation Time)'),
                              ),
                              // RatingBar.builder(
                              //   itemSize: 20,
                              //   initialRating: 3,
                              //   minRating: 1,
                              //   direction: Axis.horizontal,
                              //   allowHalfRating: true,
                              //   itemCount: 5,
                              //   itemPadding:
                              //       const EdgeInsets.symmetric(horizontal: 4.0),
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
                        const Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: widget.recommended,
                                    onChanged: (value) {
                                      widget.recommended == false
                                          ? recommendedAlertDialogs(
                                              context,
                                              'Are you sure want to update recommended value',
                                              true)
                                          : recommendedAlertDialogs(
                                              context,
                                              'Are you sure want to update recommended value',
                                              false);
                                    },
                                  ),
                                  const Text('Recommended'),
                                ],
                              ),
                              Row(
                                children: [
                                  Switch(
                                      activeColor:
                                          const Color.fromRGBO(255, 114, 76, 1),
                                      value: widget.inStock,
                                      onChanged: (value) {
                                        if (value == true) {
                                          alertDialogs(
                                              context,
                                              'Are you sure want to enable this item',
                                              value);
                                        } else {
                                          alertDialogs(
                                              context,
                                              'Are you sure want to disable this item',
                                              value);
                                        }
                                      }),
                                  widget.inStock == true
                                      ? const Text('In Stock')
                                      : const Text('Out Of Stock'),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var result = await Get.toNamed(
                                      EditMenuItems.routeName,
                                      arguments: {
                                        'Profile': widget.profile,
                                        'Food_Name': widget.foodName,
                                        'Ingredients': widget.ingrediants,
                                        'Allergen': widget.allergen,
                                        'Price': widget.price,
                                        'Description': widget.description,
                                        'Preparation_Time':
                                            widget.preparationTime,
                                        'Food_Id': widget.foodId,
                                        'Image': widget.image,
                                      });

                                  if (result == 'success') {
                                    Provider.of<Authenticate>(context,
                                            listen: false)
                                        .tryAutoLogin()
                                        .then((value) {
                                      var token = Provider.of<Authenticate>(
                                              context,
                                              listen: false)
                                          .token;
                                      Provider.of<ApiCalls>(context,
                                              listen: false)
                                          .fetchMenuItems(
                                              token, widget.profile);
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.edit),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Card(
            elevation: 5,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_isExpanded == true) {
                    _isExpanded = false;
                  } else {
                    _isExpanded = true;
                  }
                });
                // _modalBottomSheetMenu();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: width,
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Text(
                                      widget.foodName,
                                      style: headingStyle(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Text(
                                        '${String.fromCharCodes(Runes('\u0024'))}${widget.price}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: Text(widget.description),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                    ),
                                    imageUrl: widget.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.orange,
                                    value: widget.recommended,
                                    onChanged: (value) {
                                      widget.recommended == false
                                          ? recommendedAlertDialogs(
                                              context,
                                              'Are you sure want to update recommended value',
                                              true)
                                          : recommendedAlertDialogs(
                                              context,
                                              'Are you sure want to update recommended value',
                                              false);
                                    },
                                  ),
                                  const Text('Recommended'),
                                ],
                              ),
                              Row(
                                children: [
                                  Switch(
                                      activeColor:
                                          const Color.fromRGBO(255, 114, 76, 1),
                                      value: widget.inStock,
                                      onChanged: (value) {
                                        if (value == true) {
                                          alertDialogs(
                                              context,
                                              'Are you sure want to enable this item',
                                              value);
                                        } else {
                                          alertDialogs(
                                              context,
                                              'Are you sure want to disable this item',
                                              value);
                                        }
                                      }),
                                  widget.inStock == false
                                      ? Text(
                                          'Out Of Stock',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        )
                                      : Text(
                                          'In Stock',
                                          style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(EditMenuItems.routeName,
                                      arguments: {
                                        'Profile': widget.profile,
                                        'Food_Name': widget.foodName,
                                        'Ingredients': widget.ingrediants,
                                        'Allergen': widget.allergen,
                                        'Price': widget.price,
                                        'Description': widget.description,
                                        'Preparation_Time':
                                            widget.preparationTime,
                                        'Food_Id': widget.foodId,
                                        'Image': widget.image,
                                        'Cuisine': widget.cusine,
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(Icons.edit),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Divider(
                        //   color: Colors.black,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> updateStock(var data) async {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateStockValue(data, widget.foodId, token)
          .then((value) {
        if (value != 202) {
          EasyLoading.dismiss();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Something went wrong Please try again',
            title: 'Failed',
          ));

          setState(() {
            widget.inStock = false;
          });
        } else {
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully updated your menu list',
            title: 'Success',
          ));
          widget.update(100);
        }
      });
    });
  }

  Future<void> updateRecommended(var data) async {
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();
      Provider.of<ApiCalls>(context, listen: false)
          .updateRecommendedValue(data, widget.foodId, token)
          .then((value) {
        if (value != 202) {
          EasyLoading.dismiss();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Something went wrong Please try again',
            title: 'Failed',
          ));

          setState(() {
            widget.inStock = false;
          });
        } else {
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully updated your menu list',
            title: 'Success',
          ));
          widget.update(100);
        }
      });
    });
  }

  Future<dynamic> alertDialogs(
      BuildContext context, var alertMessage, var booleanValue) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alert'),
        content: Text(alertMessage),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              updateStock(booleanValue);
              // setState(() {
              //   widget.inStock = booleanValue;

              // });

              Navigator.of(ctx).pop();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }

  Future<dynamic> recommendedAlertDialogs(
      BuildContext context, var alertMessage, var booleanValue) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alert'),
        content: Text(alertMessage),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              updateRecommended(booleanValue);
              // setState(() {
              //   widget.recommended = booleanValue;

              // });

              Navigator.of(ctx).pop();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }
}
