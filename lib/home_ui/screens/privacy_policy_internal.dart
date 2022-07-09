import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InternalPrivacyPolicy extends StatefulWidget {
  InternalPrivacyPolicy({Key? key}) : super(key: key);

  static const routeName = '/InternalPrivacyPolicy';

  @override
  State<InternalPrivacyPolicy> createState() => _InternalPrivacyPolicyState();
}

class _InternalPrivacyPolicyState extends State<InternalPrivacyPolicy> {
  TextStyle mainHeadingStyle() {
    return GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w700);
  }

  TextStyle subHeadingStyle() {
    return GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500);
  }

  TextStyle paragraphStyle() {
    return GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400);
  }

  Widget size() {
    return SizedBox(
      height: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.roboto(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy Oota Online Pty Ltd',
              style: mainHeadingStyle(),
            ),
            size(),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Oota Online Pty Ltd',
                    style: subHeadingStyle(),
                  ),
                  TextSpan(
                      text:
                          ' is committed to providing quality services to you and this policy outlines our ongoing obligations to you in respect of how we manage your Personal Information.',
                      style: paragraphStyle()),
                ],
              ),
            ),
            size(),
            Text(
              'We have adopted the Australian Privacy Principles (APPs) contained in the Privacy Act 1988 (Cth) (the Privacy Act). The NPPs govern the way in which we collect, use, disclose, store, secure and dispose of your Personal Information.',
              style: paragraphStyle(),
            ),
            size(),
            textSpanData(
                'A copy of the Australian Privacy Principles may be obtained from the website of The Office of the Australian Information Commissioner at ',
                'www.aoic.gov.au'),
            size(),
            subHeadingData(
                'What is Personal Information and why do we collect it?'),
            size(),
            paragraphData(
              'Personal Information is information or an opinion that identifies an individual. Examples of Personal Information we collect include: names, addresses, email addresses, phone and facsimile numbers.',
            ),
            size(),
            tripleTextSpanData(
                'This Personal Information is obtained in many ways including sign up data captured on app, by email, via our website ',
                'www.Ootaonline.com.au ',
                ' and from third parties. We don’t guarantee website links or policy of authorised third parties.'),
            size(),
            paragraphData(
              'We collect your Personal Information for the primary purpose of providing our services to you, providing information to our clients and marketing. We may also use your Personal Information for secondary purposes closely related to the primary purpose, in circumstances where you would reasonably expect such use or disclosure. You may unsubscribe from our mailing/marketing lists at any time by contacting us in writing.',
            ),
            size(),
            paragraphData(
              'When we collect Personal Information we will, where appropriate and where possible, explain to you why we are collecting the information and how we plan to use it.',
            ),
            size(),
            subHeadingData(
              'Sensitive Information',
            ),
            size(),
            paragraphData(
                'Sensitive information is defined in the Privacy Act to include information or opinion about such things as an individuals racial or ethnic origin, political opinions, membership of a political association, religious or philosophical beliefs, membership of a trade union or other professional body, criminal record or health information.'),
            size(),
            paragraphData('Sensitive information will be used by us only:'),
            size(),
            paragraphData(
              '•	For the primary purpose for which it was obtained',
            ),
            SizedBox(
              height: 8,
            ),
            paragraphData(
                '•	For a secondary purpose that is directly related to the primary purpose'),
            SizedBox(
              height: 8,
            ),
            paragraphData(
                '•	With your consent; or where required or authorised by law.'),
            size(),
            subHeadingData('Third Parties'),
            size(),
            paragraphData(
              'Where reasonable and practicable to do so, we will collect your Personal Information only from you. However, in some circumstances we may be provided with information by third parties. In such a case we will take reasonable steps to ensure that you are made aware of the information provided to us by the third party.',
            ),
            size(),
            subHeadingData(
              'Disclosure of Personal Information',
            ),
            size(),
            paragraphData(
              'Your Personal Information may be disclosed in a number of circumstances including the following:',
            ),
            SizedBox(
              height: 8,
            ),
            paragraphData(
              '•	Third parties where you consent to the use or disclosure; and',
            ),
            SizedBox(
              height: 8,
            ),
            paragraphData(
              '•	Where required or authorised by law.',
            ),
            size(),
            subHeadingData(
              'Security of Personal Information',
            ),
            size(),
            paragraphData(
              'Your Personal Information is stored in a manner that reasonably protects it from misuse and loss and from unauthorized access, modification or disclosure.',
            ),
            size(),
            paragraphData(
              'When your Personal Information is no longer needed for the purpose for which it was obtained, we will take reasonable steps to destroy or permanently de-identify your Personal Information. However, most of the Personal Information is or will be stored in client files which will be kept by us for a minimum of 7 years.',
            ),
            size(),
            subHeadingData(
              'Access to your Personal Information',
            ),
            size(),
            paragraphData(
              'You may access the Personal Information we hold about you and to update and/or correct it, subject to certain exceptions. If you wish to access your Personal Information, please contact us in writing.',
            ),
            size(),
            doubleTextSpanData(
              '[Your business name] ',
              'will not charge any fee for your access request, but may charge an administrative fee for providing a copy of your Personal Information.',
            ),
            size(),
            paragraphData(
              'In order to protect your Personal Information we may require identification from you before releasing the requested information.',
            ),
            size(),
            subHeadingData(
              'Maintaining the Quality of your Personal Information',
            ),
            size(),
            paragraphData(
              'It is an important to us that your Personal Information is up to date. We  will  take reasonable steps to make sure that your Personal Information is accurate, complete and up-to-date. If you find that the information we have is not up to date or is inaccurate, please advise us as soon as practicable so we can update our records and ensure we can continue to provide quality services to you.',
            ),
            size(),
            subHeadingData(
              'Policy Updates',
            ),
            size(),
            paragraphData(
              'This Policy may change from time to time and is available on our website.',
            ),
            size(),
            subHeadingData(
              'Privacy Policy Complaints and Enquiries',
            ),
            size(),
            paragraphData(
              'If you have any queries or complaints about our Privacy Policy please contact us at:',
            ),
            SizedBox(
              height: 25,
            ),
            textSpanData('Write to us @', 'admin@ootaonline.com.au'),
            size(),
            subHeadingData(
              'Text or call on +61 469 863 898',
            ),
          ],
        ),
      )),
    );
  }

  Widget paragraphData(var data) {
    return Text(
      data,
      style: paragraphStyle(),
    );
  }

  Widget subHeadingData(var data) {
    return Text(
      data,
      style: subHeadingStyle(),
    );
  }

  Widget textSpanData(var first, var second) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: first,
            style: paragraphStyle(),
          ),
          TextSpan(
              text: second,
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline)),
        ],
      ),
    );
  }

  Widget doubleTextSpanData(var first, var second) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: first,
            style: subHeadingStyle(),
          ),
          TextSpan(
            text: second,
            style: paragraphStyle(),
          )
        ],
      ),
    );
  }

  Widget tripleTextSpanData(var first, var second, var third) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: first,
            style: paragraphStyle(),
          ),
          TextSpan(
              text: second,
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline)),
          TextSpan(
            text: third,
            style: paragraphStyle(),
          ),
        ],
      ),
    );
  }
}
