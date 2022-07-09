import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:provider/provider.dart';

class BankDetailsScreen extends StatefulWidget {
  BankDetailsScreen({Key? key}) : super(key: key);

  static const routeName = '/BankDetailsScreen';

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  var id;

  Map<String, dynamic> _bankPaymentDetails = {};

  Map<String, dynamic> _bPayDetails = {};
  @override
  void initState() {
    id = Get.arguments;
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchBankPaymentOptions(id, token)
          .then((value) async {
        if (value == 200 || value == 201) {}
      });
      Provider.of<ApiCalls>(context, listen: false)
          .fetchBpayDetails(id, token)
          .then((value) async {
        if (value == 200 || value == 201) {}
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bankPaymentDetails = Provider.of<ApiCalls>(context).bankPaymentDetails;
    _bPayDetails = Provider.of<ApiCalls>(context).bPayDetails;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bank Details',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(color: Colors.black)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        child: Column(
          children: [
            _bankPaymentDetails.isEmpty
                ? const SizedBox()
                : Text(_bankPaymentDetails['Name']),
            _bPayDetails.isEmpty
                ? const SizedBox()
                : Text(' BPay Number: ${_bPayDetails['BPay']}'),
          ],
        ),
      ),
    );
  }
}
