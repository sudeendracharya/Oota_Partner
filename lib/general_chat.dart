import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:oota_business/services/database.dart';
import 'package:oota_business/widget/widget.dart';
import 'package:provider/provider.dart';

import 'authentication/providers/authenticate.dart';
import 'chat.dart';
import 'helper/constants.dart';
import 'helper/helperfunctions.dart';
import 'home_ui/providers/api_calls.dart';

class GeneralChat extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  final String receiverEmail;
  final String partnerUniqueId;

  GeneralChat(
      {required this.chatRoomId,
      required this.userName,
      required this.receiverEmail,
      required this.partnerUniqueId});

  @override
  State<GeneralChat> createState() => _GeneralChatState();
}

class _GeneralChatState extends State<GeneralChat> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController controller = ScrollController();

  List chatsData = [];

  var businessName;

  List _profileDetailsList = [];

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          chatsData.clear();
          // print('chat data ${snapshot.data.docs.toString()}');
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            chatsData.add({
              'message': snapshot.data.docs[i].data()["message"],
              'sendByMe': widget.partnerUniqueId ==
                  snapshot.data!.docs[i].data()["sendBy"],
              // ? true
              // : false,
              'dateTime': snapshot.data!.docs[i].data()["time"],
            });
          }
        }
        return snapshot.hasData
            ? Column(
                children: [
                  Expanded(
                    child: GroupedListView<dynamic, String>(
                      controller: controller,
                      elements: chatsData,
                      groupBy: (element) =>
                          // element['dateTime'].toString(),
                          DateFormat('dd-MM-yyyy')
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  element['dateTime']))
                              .toString(),
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              height: 25,
                              width: 80,
                              // decoration: BoxDecoration(color: Colors.green),
                              // color: Colors.grey,
                              alignment: Alignment.center,
                              // padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                groupByValue.toString(),
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  backgroundColor: Colors.grey,
                                ),
                              )),
                        ),
                      ),
                      itemBuilder: (context, dynamic element) => MessageTile(
                        message: element['message'],
                        sendByMe: element['sendByMe'],
                        dateTime: element['dateTime'],
                      ),
                      // Text(element['message']),
                      // itemComparator: (item1, item2) =>
                      //     item1['name'].compareTo(item2['name']), // optional
                      useStickyGroupSeparators: true, // optional
                      floatingHeader: true, // optional
                      order: GroupedListOrder.ASC,
                      // stickyHeaderBackgroundColor: Colors.green,
                      // groupHeaderBuilder: (value) {
                      //   return Padding(
                      //     padding: const EdgeInsets.only(top: 8.0),
                      //     child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(10),
                      //       child: Container(
                      //           height: 25,
                      //           width: 80,
                      //           color: Colors.grey,
                      //           alignment: Alignment.center,
                      //           child: Text(value.toString())),
                      //     ),
                      //   );
                      // },

                      // optional
                    ),
                    // ListView.builder(
                    //     controller: controller,
                    //     itemCount: snapshot.data.docs.length,
                    //     itemBuilder: (context, index) {
                    //       return MessageTile(
                    //         message:
                    //             snapshot.data.docs[index].data()["message"],
                    //         sendByMe: Constants.myName ==
                    //             snapshot.data!.docs[index].data()["sendBy"],
                    //         dateTime: snapshot.data!.docs[index].data()["time"],
                    //       );
                    //     }),
                  ),
                  messageTextField(context),
                ],
              )
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      String message = messageEditingController.text;
      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.partnerUniqueId,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      Provider.of<Authenticate>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        var token = Provider.of<Authenticate>(context, listen: false).token;
        Provider.of<ApiCalls>(context, listen: false).sendMessageNotification({
          'user': widget.receiverEmail,
          'body': message,
          'Sender_Email': widget.partnerUniqueId,
          'Title': widget.chatRoomId,
          'Partner_Business_Name': businessName ?? '',
          'Customer_Name': widget.userName,
        }, token);
      });

      // print(chatMessageMap);

      DatabaseMethods()
          .addMessage(widget.chatRoomId, chatMessageMap)
          .then((value) {
        // controller.animateTo(
        //   controller.position.maxScrollExtent +
        //       controller.position.maxScrollExtent,
        //   curve: Curves.easeOut,
        //   duration: const Duration(milliseconds: 300),
        // );
        var data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

        var height = data.size.height * 0.3;

        controller.jumpTo(
          controller.position.maxScrollExtent + height,
        );

        // DatabaseMethods().getChats(widget.chatRoomId).then((val) {
        //   setState(() {
        //     chats = val;
        //   });
        // });
      });

      setState(() {
        messageEditingController.text = "";
      });

      // print(controller.position.maxScrollExtent);

      // controller.jumpTo(
      //   controller.position.maxScrollExtent + 80,
      // );

      // setState(() {

      // });
    }
  }

  Future<void> getUserName() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
  }

  @override
  void initState() {
    getUserName();
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
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _profileDetailsList = Provider.of<ApiCalls>(
      context,
    ).profileDetails;

    if (_profileDetailsList.isNotEmpty) {
      businessName = _profileDetailsList[0]['Business_Name'];
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.userName,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: chatMessages(),
        // Container(
        //   child: Stack(
        //     children: [

        //       // Container(
        //       //   padding: const EdgeInsets.only(bottom: 80.0),
        //       //   alignment: Alignment.topCenter,
        //       //   child:
        //       // ),
        //       // Container(
        //       //   alignment: Alignment.bottomCenter,
        //       //   width: MediaQuery.of(context).size.width,
        //       //   child: Container(
        //       //     // height: 70,
        //       //     padding:
        //       //         const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        //       //     color: Colors.white,
        //       //     child: Row(
        //       //       children: [
        //       //         Expanded(
        //       //           child: Container(
        //       //             decoration: BoxDecoration(
        //       //                 border: Border.all(),
        //       //                 borderRadius: BorderRadius.circular(20)),
        //       //             padding: const EdgeInsets.symmetric(horizontal: 5),
        //       //             child: TextField(
        //       //               onTap: () {
        //       //                 controller.animateTo(
        //       //                   controller.position.maxScrollExtent,
        //       //                   curve: Curves.easeOut,
        //       //                   duration: const Duration(milliseconds: 300),
        //       //                 );
        //       //                 print('textfield');
        //       //                 // setState(() {

        //       //                 // });
        //       //               },
        //       //               controller: messageEditingController,
        //       //               style: simpleTextStyle(),
        //       //               keyboardType: TextInputType.multiline,
        //       //               minLines: 1,
        //       //               maxLines: 6,
        //       //               decoration: const InputDecoration(
        //       //                   hintText: "Message ...",
        //       //                   hintStyle: TextStyle(
        //       //                     color: Colors.black,
        //       //                     fontSize: 16,
        //       //                   ),
        //       //                   border: InputBorder.none),
        //       //             ),
        //       //           ),
        //       //         ),
        //       //         const SizedBox(
        //       //           width: 16,
        //       //         ),
        //       //         GestureDetector(
        //       //           onTap: addMessage,
        //       //           child: Container(
        //       //               height: 50,
        //       //               width: 50,
        //       //               decoration: BoxDecoration(
        //       //                   gradient: const LinearGradient(
        //       //                       colors: [
        //       //                         Color.fromARGB(230, 226, 169, 11),
        //       //                         Color.fromARGB(220, 228, 177, 11)
        //       //                       ],
        //       //                       begin: FractionalOffset.topLeft,
        //       //                       end: FractionalOffset.bottomRight),
        //       //                   borderRadius: BorderRadius.circular(40)),
        //       //               padding: const EdgeInsets.all(12),
        //       //               child: Image.asset(
        //       //                 "assets/images/send.png",
        //       //                 height: 25,
        //       //                 width: 25,
        //       //               )),
        //       //         ),
        //       //       ],
        //       //     ),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
      ),
      // floatingActionButton: messageTextField(context),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottomSheet: messageTextField(context),
    );
  }

  Container messageTextField(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      child: Container(
        // height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  onTap: () {
                    var data = MediaQueryData.fromWindow(
                        WidgetsBinding.instance.window);

                    var height = data.size.height * 0.3;
                    controller.jumpTo(
                      controller.position.maxScrollExtent +
                          controller.position.maxScrollExtent,
                      // curve: Curves.easeOut,
                      // duration: const Duration(milliseconds: 300),
                    );
                    // print('textfield');
                    // setState(() {

                    // });
                  },
                  controller: messageEditingController,
                  style: simpleTextStyle(),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      hintText: "Message ...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: addMessage,
              child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(230, 226, 169, 11),
                            Color.fromARGB(220, 228, 177, 11)
                          ],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight),
                      borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    "assets/images/send.png",
                    height: 25,
                    width: 25,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
