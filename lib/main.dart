import 'dart:convert';
import 'dart:developer';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/authentication/screens/forget_password_screen.dart';
import 'package:oota_business/authentication/screens/sign_up_screen.dart';
import 'package:oota_business/chat.dart';
import 'package:oota_business/colors.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/add_menu_items_page.dart';
import 'package:oota_business/home_ui/screens/all_orders_history.dart';
import 'package:oota_business/home_ui/screens/bank_details_screen.dart';
import 'package:oota_business/home_ui/screens/chat_history.dart';
import 'package:oota_business/home_ui/screens/coupons_screen.dart';
import 'package:oota_business/home_ui/screens/edit_bank_details.dart';
import 'package:oota_business/home_ui/screens/edit_bpay_details.dart';
import 'package:oota_business/home_ui/screens/edit_business_profile.dart';
import 'package:oota_business/home_ui/screens/edit_coupons_page.dart';
import 'package:oota_business/home_ui/screens/edit_menu_items.dart';
import 'package:oota_business/home_ui/screens/edit_outlet_timings.dart';
import 'package:oota_business/home_ui/screens/home_page.dart';
import 'package:oota_business/home_ui/screens/log_in_splash_screen.dart';
import 'package:oota_business/home_ui/screens/map_screen.dart';
import 'package:oota_business/home_ui/screens/order_details_page.dart';
import 'package:oota_business/home_ui/screens/privacy_policy_internal.dart';
import 'package:oota_business/home_ui/screens/profile_setup_page.dart';
import 'package:oota_business/home_ui/screens/side_bar_screen.dart';
import 'package:oota_business/home_ui/screens/splash_screen.dart';
import 'package:oota_business/home_ui/screens/webview_display_content.dart';
import 'package:oota_business/home_ui/screens/add_coupons.dart';
import 'package:oota_business/privacy_policy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication/screens/log_in_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/database.dart';

var baseUrl = 'https://ootaonline.herokuapp.com/';
// var baseUrl = 'https://projectoota.herokuapp.com/';

RemoteMessage? newMessage;
Map<String, dynamic>? messageData;
// var initializationSettingsAndroid =
//     const AndroidInitializationSettings('@mipmap/ic_launcher');
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  newMessage = message;
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  messageData = message.data.isEmpty ? {} : message.data;

  print('Message Data ${newMessage!.data}');
  // var initializationSettings = InitializationSettings(
  //   android: initializationSettingsAndroid,
  // );

  // flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onSelectNotification: onSelectNotification,
  // );
  if (messageData!.isNotEmpty) {
    messageData!['type'] == 'Chat'
        ? flutterLocalNotificationsPlugin.show(
            int.parse('1'),
            '${message.data['Customer_Name'] ?? 'Customer'}',
            message.data['body'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: json.encode(message.data),
          )
        : flutterLocalNotificationsPlugin.show(
            int.parse('1'),
            message.data['title'],
            message.data['body'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                priority: Priority.max,
              ),
            ),
            payload: json.encode(message.data),
          );
  } else {
    flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: json.encode(message.data),
    );
  }
}

Future<dynamic> onSelectNotification(payload) async {
  print('Payload ${json.decode(payload)}');
  Map<String, dynamic> data = json.decode(payload);
  // RemoteMessage? initialMessage =
  //     await FirebaseMessaging.instance.getInitialMessage();
  // fetch();

  if (data['type'] == 'Chat') {
    sendMessage(data['Sender_Email'], data['title'], data['Customer_Name'],
        data['Partner_Business_Name']);
  } else {
    Get.toNamed(
      OrderDetailsPage.routeName,
      arguments: {
        'Order_Id': data['id'],
        'Section': 'New_Orders',
      },
    );
  }
  // if (initialMessage?.notification != null) {
  //   Get.toNamed(HomePageScreen.routeName);
  //   print('Clicked on notification');
  //   // checkForInitialMessage();
  // } else {
  //   // print(initialMessage?.data.toString());
  //   // print('New Message ${newMessage?.data.toString()}');
  //   // print('message data opened inside class $messageData');
  //   print('Clicked on message ');

  // }
}

DatabaseMethods databaseMethods = DatabaseMethods();
sendMessage(String customerUniqueId, String chatId, String customerName,
    String hotelName) async {
  var partnerUniqueId;
  var pref = await SharedPreferences.getInstance();
  if (pref.containsKey('PartnerUniqueKey')) {
    var extratedData = json.decode(pref.getString('PartnerUniqueKey')!);
    partnerUniqueId = extratedData['PartnerUniqueKey'];
  }
  List<String> users = [partnerUniqueId, customerUniqueId];

  // print(myName);
  // print(userName);

  String chatRoomId = chatId;

  Map<String, dynamic> chatRoom = {
    "users": users,
    "chatRoomId": chatRoomId,
    'displayName': hotelName,
    'customerName': customerName,
  };

  // print(chatRoomId);

  // print(users);

  databaseMethods.addChatRoom(chatRoom, chatRoomId);

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => Chat(
  //       chatRoomId: chatRoomId,
  //       userName: userName,
  //     ),
  //   ),
  // );

  Get.to(() => Chat(
        partnerUniqueId: partnerUniqueId,
        chatRoomId: chatRoomId,
        customerUniqueId: customerUniqueId,
        customerName: customerName,
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: true,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late PendingDynamicLinkData? initialLink;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51KMUpeSAYfEkrbYeriyIf7kB1KdCmhKVZEtH5JVZWgWugxx8G0mDp4qEMwFuaom1gCZQJdNU0cJLfx9Plj02Sbq000oY5USOxt';
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: onSelectNotification
      // (payload) {
      //   if (newMessage!.data['type'] == 'Chat') {
      //     sendMessage(
      //       newMessage?.data['Sender_Email'],
      //       newMessage?.data['title'],
      //     );
      //   } else {
      //     Get.toNamed(
      //       OrderDetailsPage.routeName,
      //       arguments: {
      //         'Order_Id': newMessage!.data['id'],
      //         'Section': 'New_Orders',
      //       },
      //     );
      //   }
      // },
      );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  final navigatorKey = GlobalKey<NavigatorState>();

  var _profileId;

  @override
  void initState() {
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // checkForInitialMessage();
    FirebaseMessaging.instance.getToken().then((value) async {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': value,
        },
      );
      prefs.setString('FCM', userData);
      log('Token $value');
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        print('Message ${message.data.toString()}');
        // print(message.notification!.title.toString());
        // fetch();

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: json.encode(message.data),
          );
        } else {
          newMessage = message;
          message.data['type'] == 'Notification'
              ? flutterLocalNotificationsPlugin.show(
                  int.parse('1'),
                  '${message.data['title']}',
                  message.data['body'],
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channelDescription: channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/ic_launcher',
                    ),
                  ),
                  payload: json.encode(message.data),
                )
              : flutterLocalNotificationsPlugin.show(
                  int.parse('1'),
                  '${message.data['Customer_Name'] ?? 'Customer'}',
                  message.data['body'],
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channelDescription: channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/ic_launcher',
                    ),
                  ),
                  payload: json.encode(message.data),
                );
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenApp Event Was Published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // fetch();
        Get.defaultDialog(
          title: notification.title.toString(),
          middleText: notification.body.toString(),
          confirm: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
              const Color.fromRGBO(255, 114, 76, 1),
            )),
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Ok',
              style: TextStyle(color: ProjectColors.themeColor),
            ),
          ),
        );
        // print(notification.title.toString());
      } else {
        if (message.data['type'] == 'Chat') {
          sendMessage(
            message.data['Sender_Email'],
            message.data['title'],
            message.data['Customer_Name'],
            message.data['Partner_Business_Name'],
          );
        } else {
          Get.toNamed(
            OrderDetailsPage.routeName,
            arguments: {
              'Order_Id': message.data['id'],
              'Section': 'New_Orders',
            },
          );
        }
        // print(message.data['Sender_Email']);
      }
    });

    super.initState();
  }

  void fetch() {
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
        } else {
          Provider.of<ApiCalls>(context, listen: false)
              .fetchOrders(_profileId, token)
              .then((value) async {
            if (value == 200 || value == 201) {}
          });
        }
      });
    });
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

  checkForInitialMessage() async {
    // await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // PushNotification notification = PushNotification(
      //   title: initialMessage.notification?.title,
      //   body: initialMessage.notification?.body,
      // );
      // setState(() {
      Get.defaultDialog(
          title: initialMessage.notification!.title.toString(),
          middleText: initialMessage.notification!.body.toString());
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authenticate(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ApiCalls(),
        ),
      ],
      child: Consumer<Authenticate>(
        builder: (ctx, auth, _) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => const MyApp(),
            ),
            GetPage(name: SignUpScreen.routeName, page: () => SignUpScreen()),
            GetPage(
                name: ForgetPasswordScreen.routeName,
                page: () => ForgetPasswordScreen()),
            GetPage(
                name: HomePageScreen.routeName, page: () => HomePageScreen()),
            GetPage(
                name: ProfileSetUpPage.routeName,
                page: () => ProfileSetUpPage()),
            GetPage(name: AddMenuItems.routeName, page: () => AddMenuItems()),
            GetPage(
                name: SideBarScreen.routeName,
                page: () => const SideBarScreen()),
            GetPage(name: EditMenuItems.routeName, page: () => EditMenuItems()),
            GetPage(
                name: EditBusinessProfileScreen.routeName,
                page: () => EditBusinessProfileScreen()),
            GetPage(
              name: EditOutLetTimings.routeName,
              page: () => EditOutLetTimings(),
            ),
            GetPage(
              name: BankDetailsScreen.routeName,
              page: () => BankDetailsScreen(),
            ),
            GetPage(
              name: EditbPayDetails.routeName,
              page: () => EditbPayDetails(),
            ),
            GetPage(
              name: EditBankDetails.routeName,
              page: () => EditBankDetails(),
            ),
            GetPage(
              name: AllOrdersHistory.routeName,
              page: () => AllOrdersHistory(),
            ),
            GetPage(
              name: MapScreen.routeName,
              page: () => MapScreen(),
            ),
            GetPage(
              name: LogInPage.routeName,
              page: () => const LogInPage(title: 'title'),
            ),
            GetPage(
              name: WebViewDisplayContent.routeName,
              page: () => WebViewDisplayContent(),
            ),
            GetPage(
              name: SplashScreen.routeName,
              page: () => SplashScreen(),
            ),
            GetPage(
              name: LogInSplashScreen.routeName,
              page: () => LogInSplashScreen(),
            ),
            GetPage(
              name: ChatHistoryPage.routeName,
              page: () => ChatHistoryPage(),
            ),
            GetPage(
              name: Chat.routeName,
              page: () => Chat(
                chatRoomId: '',
                customerUniqueId: '',
                customerName: '',
                partnerUniqueId: '',
              ),
            ),
            GetPage(
              name: OrderDetailsPage.routeName,
              page: () => OrderDetailsPage(),
            ),
            GetPage(
              name: PrivacyPolicy.routeName,
              page: () => PrivacyPolicy(),
            ),
            GetPage(
              name: InternalPrivacyPolicy.routeName,
              page: () => InternalPrivacyPolicy(),
            ),
            GetPage(
              name: CouponsScreen.routeName,
              page: () => CouponsScreen(),
            ),
            GetPage(
              name: AddCouponsPage.routeName,
              page: () => AddCouponsPage(),
            ),
            GetPage(
              name: EditCouponsPage.routeName,
              page: () => EditCouponsPage(),
            ),
          ],
          title: 'Oota',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: const Color.fromRGBO(6, 70, 99, 1),
            fontFamily: GoogleFonts.roboto().fontFamily,
            // canvasColor: Colors.transparent,
          ),
          home: auth.isAuth
              // ? auth.isProfile
              ? HomePageScreen()
              // : FutureBuilder(
              //     builder: (ctx, authResultSnapshot) =>
              //         authResultSnapshot.connectionState ==
              //                 ConnectionState.waiting
              //             ? SplashScreen()
              //             : GenerateProfile(),
              //     future: auth.fetchProfileDetails())
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : const LogInPage(title: 'Welcome'),
                  future: auth.tryAutoLogin(),
                ),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

class GenerateProfile extends StatelessWidget {
  const GenerateProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileSetUpPage();
  }
}
