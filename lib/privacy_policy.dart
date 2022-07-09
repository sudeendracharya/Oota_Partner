import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key? key}) : super(key: key);

  static const routeName = '/PrivacyPolicy';

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  TextStyle headingStyle() {
    return GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700);
  }

  TextStyle paraStyle() {
    return GoogleFonts.roboto(fontSize: 17, fontWeight: FontWeight.w400);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.roboto(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chef / Vendor Terms of Use',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: width,
                child: Text(
                  'Please read the terms and conditions (“Terms and Conditions”) set out below carefully before ordering any Goods or Services from Oota Online Platform. By ordering any Goods or Services from this Website, by phone, or by our mobile applications you agree to be bound by these Terms and Conditions.',
                  style: paraStyle(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'INTRODUCTION:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              paraContainer(
                width,
                '“Oota online” is a mobile application that connects a large network of food and beverage suppliers to the general public. Oota online mobile app is designed, developed & conceptualized by Oota online at 2/11 Hanover Road Vermont South 3133. All the rights, benefits, liabilities & obligations under the following terms & conditions shall accrue to the benefit of Oota Online. (together with its subsidiaries and other affiliates hereinafter referred to as “us”, “We” or “Oota Online Pty Ltd”).',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                '“Users” means a person who has signed up and is registered with Oota Online for the use or potential use/purchase of the Goods / Services.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  '“Vendor” means a food and beverage supplier or business or establishment having sole responsibility for providing food and beverage services registered with Oota Online Pty Ltd.'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'References to a Vendor shall include such party’s successors, employees, permitted assignees and any persons deriving title under it;'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'The Terms and Conditions, hereinafter referred to as “The Agreement” may be amended from time to time and is a legal contract between Vendor and Oota Online Pty Ltd.'),
              const SizedBox(
                height: 20,
              ),
              Text(
                'USER INFORMATION:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd understands the importance of keeping the information about you that you entrust to us confidential and secure (“User Information”). The information we collect may include your personal information, in other words, information capable of identifying you as a particular individual, such as your name, phone number, email address, purchase preferences, credit/debit card information. We, therefore, make it our highest priority to ensure that we look after your information and use it responsibly. By using the service or by providing your information to us or our Partners, you accept and consent to the collection, storage, and processing of your information.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd may collect your personal information (i) when you register an account (ii) when you purchase services on the Application (iii) when you participate in contests, competitions, questionnaires, and surveys (iv) when you contact us (v) when you provide certain content to Oota Online Pty Ltd, for example, testimonials and customer reviews (vi) from third party sources, for example, credit checking agencies.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd may use your personal information for (i) registering your account with Oota Online Pty Ltd (ii) for fulfilling orders (iii) for responding to your queries (iv) for improving your Oota Online Pty Ltd experience and providing you with information about our services, special offers, and promotions. Oota Online Pty Ltd will only share your information with its carefully selected third-party Partners for necessary business administration, customer delivery, marketing, operational and analytical purposes. Oota Online Pty Ltd will only share your information with its carefully selected third-party Partners for necessary business administration, customer delivery, marketing, operational and analytical purposes. Oota Online Pty Ltd may also share your information with third parties for the purpose of data analysis, quality assurance including fraud prevention. Oota Online Pty Ltd uses leading technology and security measures (electronic, physical and procedural) to ensure the safety and confidentiality of your information through collection, storage, and disclosure. Such measures include maintaining a secure encryption-based transmission system, intrusion detection, and prevention software and virus software in respect of your information. When you use the App/service through your mobile device, and only if you have consented thereto, we will use your geo-location information, on a real-time basis only. We use this information to allow users to view service options around them. We may also use this real-time geo-location information to address user support, technical, or business issues that may arise in the course of your use of the App.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'INTERPRETATION:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'i) “The Agreement” means this contract together with all schedules and annexures (if any); ii) References to a Vendor shall include such party’s successors, employees, permitted assignees, and any persons deriving title under it;',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'iii) The descriptive headings of clauses are inserted solely for convenience of reference and are not intended as complete or accurate descriptions of the content of such clauses, and can be further defined in separate annexures.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'GENERAL TERMS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'This Agreement along with the registration form set forth the terms of services under which the Vendor may be identified as a vendor to the users or company. The Agreement shall come into effect upon the Vendor or any authorized agent of the Vendor upon realization of consideration (“Effective Date”). By agreeing to the terms of services, the Vendor shall be deemed to have consented unconditionally to all such addendums and amendments to the Agreement.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'INFORMATION DISSEMINATION:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd currently disseminates information to the users through various platforms viz, email, SMS, push notifications, telephone & internet. Oota Online Services Pty Ltd may, at its discretion cease providing information over any of the above platforms or provide information over other platforms or modify the manner in which information is provided over any of the existing platforms, as it may deem fit, from time to time.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'PLAN LISTINGS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'This refers to the various price plan(s) listing options that can be selected by the Vendor. Oota Online Pty Ltd provides the following kinds of plan listings; i) \$10/month',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'CATEGORY LISTINGS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'This refers to the various category listings that can be selected by the Vendor. Oota Online Services Pty Ltd reserves the right to change the aforesaid category listing options by adding, deleting, modifying, or merging any categories. In the event the category applied for in the partnership Form is no longer available, Oota Online Services Pty Ltd shall endeavor to allot a similar category to the Vendor. The final decision-making power with regard to category listing shall, however, vest in Oota Online Services Pty Ltd and such decision shall be final and binding on the Vendor.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'VENDOR RESPONSIBILITIES & REQUIREMENTS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Vendor responsibilities and/or requirements in support of this Agreement include:',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'The Vendor ensures smooth communication with users. Manufacturing and maintaining the quality of Goods/ Products / Ingredients and Services. Overseeing all aspects of the Item listing, Provide and maintain menu descriptions for all menu items, Order fulfilling, delivery & operations including order costs & order delivery. Keeping order costs at an affordable range. Ensuring quality of Goods & Services listed by them on Oota Online Services Pty Ltd. Ensuring to serve & deliver on schedule. Developing and standardize recipes to ensure consistency. Ensuring safety and sanitation; that entire kitchen, kitchen equipment, packaging material, fridges, storage, etc. are up to health code standards. Recognizing and meeting all deadlines. Giving advance notification to Oota Online Pty Ltd users towards availability or non-availability of service. Following all local and national regulations/laws related to food preparation and delivery.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'SERVICE ASSUMPTIONS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'Assumptions related to in-scope services and/or components include:'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'Changes to services will be communicated and documented to all parties.'),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'CANCELLATION POLICY & EXIT CLAUSE:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'A) This agreement may be cancelled if the service is not satisfactory.'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'B) Oota Online Pty Ltd or The Vendor may cancel this agreement with prior notice of a minimum of one week.'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'C) Should either party fail to provide or breach this agreement in any way, the offending party will be liable for damages.'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'D) This Agreement shall be governed by and construed in accordance with the laws of Commonwealth of Australia Government.'),
              const SizedBox(
                height: 10,
              ),
              Text(
                'CONTENT GUIDELINES & RESTRICTIONS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Products and other content (such as product titles, product images, cover art, and product descriptions) must adhere to these content guidelines. We reserve the right to make judgments about whether the content is appropriate and to choose not to publish it. We may also terminate your participation on Oota Online Pty Ltd if you don’t adhere to these content guidelines. If you are unsure if you own the rights to the content you wish to submit, please consult an attorney.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Pornography We don’t accept pornography or offensive depictions of graphic sexual acts.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'Offensive content What we deem offensive is probably about what you would expect.'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width, 'Illegal and infringing content'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'We take violations of laws and proprietary rights very seriously. It is your responsibility to ensure that your content doesn’t violate laws of copyright, trademark, privacy, publicity, or other rights. Just because the content is freely available does not mean you are free to copy and use it.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Public domain and other non-exclusive content Some types of content, such as public domain content, may be free to use by anyone or may be licensed for use by more than one party. We will accept content that is available on the web as long as you are the copyright owner of that content.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Poor customer experience We don’t accept content that provides a poor customer experience. We reserve the right to determine whether content provides a poor customer experience.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Content Requirements Product titles should be clear and can’t contain any other information. The product description should be clear and descriptive about the product/service being availed by the customer and any other additional information such as allergen information. Product images submitted to Oota Online Pty Ltd must meet the following technical specifications.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Image Requirements TIFF (.tif/.tiff), JPEG (.jpeg/.jpg), GIF (.gif) and PNG (.png) format Image pixel dimensions of at least 500 or larger in either height or width preferred RGB or CMYK color mode',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'File names must consist of the product identifier (Oota Online Services Pty Ltd Product title) followed by a period and the appropriate file extension (Example: 63906.jpg)',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Note: Spaces, dashes, or additional characters in the file name will prevent your image from going online.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'After filling in all the details except the image, please save your product as a draft, then upload the image to get the unique product identifier that can be used in the image file name.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd Site Standards for Product Images At least one image is required for every product. Not uploading an image can lead to the product not being approved and will lead to rejection of the product. For images named by product identifier without a variant code or named with the MAIN variant, and display as the main image on the product detail page, Oota Online Services Pty Ltd maintains the following site product image standards: The image must be the cover art or a professional photograph of the product being sold. Drawings or illustrations of the product are not allowed. The image must not contain gratuitous or confusing additional objects. The image must be in focus, professionally lit and photographed or scanned, with realistic colour, and smooth edges. The image must be from a top angle and not anything else. The full product must be in the frame. The containers with food must be visible completely and can’t be cropped. Backgrounds must preferably be pure white (RGB 255,255,255). The image must not contain additional text, graphics, or inset images.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'For additional other view images, the image must be of, or pertain to, the product being sold. Other products or objects are allowed to help demonstrate the use or scale of the product. The product and props should fill 85% or more of the image frame. Cropped or close-up images are allowed. Backgrounds and environments are allowed. Text and demonstrative graphics are allowed.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'PROMOTIONS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'From time to time Oota Online Pty Ltd will run promotional offers on its platforms in the form of vouchers and discounts that can be applied to vendor accounts. Promotions that are offered as valid for new vendors only may not be applied to existing accounts or individuals who already have an Oota Online Pty Ltd account, whether active or dormant. In all cases, promotional vouchers cannot be transferred to other vendors and users. Vouchers may only be redeemed against the purchase of services on the Oota Online Pty Ltd platforms.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'NO MARKETING:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd is not obliged and does not market the offerings of the Vendor and shall not be obliged to recommend the Vendor to the users. Oota Online Pty Ltd’s obligation under the contract is limited explicitly set out herein and in no event does Oota Online Pty Ltd undertake to generate or guarantee inquiries or business to the Vendor.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'INDEMNIFICATION:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Vendor shall indemnify and hold harmless Oota Online Pty Ltd, its affiliates, directors, officers, agents, and employees from loss, or damage arising from any claim asserted by any third party including any user, due to or arising out of any action or inaction of Vendor, its employees or agents, including but not limited to, property claims, any claims pertaining to incorrect or false information about the Vendor that was provided to Oota Online Pty Ltd and any claims including but not limited to the quality or usefulness of the products or services of the Vendor.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'CONFIDENTIALITY & RELATED OBLIGATIONS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'The Vendor shall keep any information regarding the users of the service (“User Information”) confidential both, during the subsistence of this contract and after its termination. The Vendor shall not, without the prior written consent of Oota Online Pty Ltd, transfer (whether for considerations or otherwise) User information to any third party for any reason whatsoever. The Vendor is specifically prohibited from using the User information for purposes of seeking any commercial gain out of said User information. In the event Oota Online Pty Ltd is made aware of any such practice of the Vendor in violation of the terms of the contract, Oota Online Pty Ltd shall be entitled to terminate the contract as well as initiate such legal proceedings against the Vendor, as it may deem fit, at its sole discretion and without prejudice to rights available to it under applicable law. Oota Online Pty Ltd reserves the right to retain, reuse or remove information or knowledge including but not limited to chef ratings, session ratings, user experience, feedback/comments obtained by Users or its Vendors on Oota Online platform unless mentioned otherwise in writing.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'VENDOR OBLIGATIONS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Vendor represents and warrants that (i) it is a bonafide business organization in relation to the items disclosed to Oota Online Pty Ltd; or an individual with required documents (ii) it has the rights to use the trademarks; (iii) the business carried on by the Vendor does not violate or infringe upon any law or regulation and all registrations, authorizations and /permission necessary approvals required for carrying on business have been procured by it. (iv) all information provided about itself to Oota Online Pty Ltd, is and shall at all times be accurate, valid, and complete. (v) it would be solely responsible and liable for the information provided (including but not limited to the content or details pertaining to any information provided by the Vendor to Oota Online Pty Ltd. (vi) The vendor accepts that it is responsible to cross verify and ensure filling up of all the Vendor details including but not limited to the contact information, information pertaining to its products/services provided by the Vendor and keep Oota Online Pty Ltd updated in this regard. (vii) The Vendor undertakes to provide a copy of the licenses/registrations or any other documents including but not limited to valid identity proofs required to run the business as is when such request is made by Oota Online Pty Ltd. The Vendor acknowledges that any breach of the covenants set forth may be a cause for termination of the Contract by Oota Online Pty Ltd, at its sole discretion.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'DISCLAIMER AND LIMITATION OF LIABILITY:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd is not liable for any claim owing to any misinterpretation of the information pertaining to the Vendor so long as the information exhibited/communicated by Oota Online Pty Ltd conforms to the information made available by the Vendor or its authorized representative.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'TAXES:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'Oota Online Pty Ltd is entitled to charge the Vendor for all the taxes and charges (now in force or enacted in the future) that are or may be imposed on the said Services and listing fees and the Vendor hereby agrees to pay the said taxes and charges promptly without raising any objections.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'MISCELLANEOUS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(width,
                  'A) Oota Online Pty Ltd.’s interpretation of the Contract shall be final and binding on the Vendor.'),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'B) Vendor agrees that no joint venture, employment, or agency exists between Vendor and Oota Online Pty Ltd and the Vendor is not entitled to bind Oota Online Services Pty Ltd by its actions.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'C) Vendor may not assign any rights or obligations against Oota Online Services Pty Ltd without Oota Online Pty Ltd.’s prior written consent.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'D) Oota Online Pty Ltd shall not be responsible for any delay or deficiency due to any force majeure events such as natural disasters, acts of terrorism, civil labor strikes, labor, and other strikes.',
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'E) Nothing in the Contract obliges or will be deemed to oblige Oota Online Pty Ltd to provide any credit to the Vendor.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'ENTIRE CONTRACT:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'These Terms, including any Annexures, along with the form hereto forms a single Contract between the Parties hereto and constitute the entire understanding between the Parties with regard to the subject matter hereof and supersede any other Contract between the Parties relating to the subject matter hereof.',
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'AMENDMENTS & WAIVERS:',
                style: headingStyle(),
              ),
              const SizedBox(
                height: 10,
              ),
              paraContainer(
                width,
                'No waiver by any party or any term or condition of the Contract, in any one or more instances, shall be deemed to be or construed as a waiver of the same or any other term or condition of the Contract on any future occasion.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container paraContainer(double width, String data) {
    return Container(
      width: width,
      child: Text(
        data,
        style: paraStyle(),
      ),
    );
  }
}
