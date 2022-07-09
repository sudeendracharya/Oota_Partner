import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/general_chat.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:provider/provider.dart';

import '../../chat.dart';
import '../../helper/constants.dart';
import '../../helper/helperfunctions.dart';
import '../../helper/theme.dart';
import '../../services/database.dart';

class ChatHistoryPage extends StatefulWidget {
  ChatHistoryPage({Key? key}) : super(key: key);

  static const routeName = '/ChatHistory';

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  Stream? chatRooms;

  var senderEmail;

  List profileDetails = [];

  var partnerUniqueId;

  @override
  void initState() {
    var data = Get.arguments;
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        if (profileDetails.isNotEmpty) {
          partnerUniqueId = profileDetails[0]['Chat_Unique_Id'];
          getUserInfogetChats();
        }
      });
    });

    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    senderEmail = Constants.myName;
    print(Constants.myName);
    DatabaseMethods().getUserChats(partnerUniqueId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  Widget chatRoomsList() {
    // print('Sender Email $senderEmail');
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    partnerUniqueId: partnerUniqueId,
                    userName:
                        snapshot.data.docs[index].data()['customerName'] ?? '',
                    chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                    receiverEmail: senderEmail !=
                            snapshot.data.docs[index]
                                .data()["users"][0]
                                .toString()
                        ? snapshot.data.docs[index]
                            .data()["users"][0]
                            .toString()
                        : snapshot.data.docs[index]
                            .data()["users"][1]
                            .toString(),
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    profileDetails = Provider.of<ApiCalls>(context).profileDetails;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Chats',
          style: GoogleFonts.roboto(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: chatRooms == null ? const SizedBox() : chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String receiverEmail;
  final String partnerUniqueId;

  ChatRoomsTile(
      {required this.userName,
      required this.chatRoomId,
      required this.receiverEmail,
      required this.partnerUniqueId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print(receiverEmail);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeneralChat(
              chatRoomId: chatRoomId,
              userName: userName,
              receiverEmail: receiverEmail,
              partnerUniqueId: partnerUniqueId,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: CustomTheme.colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                userName == '' ? '' : userName.substring(0, 1),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
