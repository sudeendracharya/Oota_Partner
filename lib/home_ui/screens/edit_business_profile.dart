import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiselect/multiselect.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:oota_business/home_ui/screens/map_screen.dart';
import 'package:provider/provider.dart';

class EditBusinessProfileScreen extends StatefulWidget {
  EditBusinessProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/EditBusinessProfileScreen';

  @override
  _EditBusinessProfileScreenState createState() =>
      _EditBusinessProfileScreenState();
}

class _EditBusinessProfileScreenState extends State<EditBusinessProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  double horizontalPadding = 20;
  double verticalPadding = 10;
  TextEditingController businessAddressController = TextEditingController();

  Map<String, dynamic> editedBusinessProfile = {
    'Profile_Id': '',
    'Business_Name': '',
    'Business_Address': '',
    'Business_Category': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile': '',
    'ABN': '',
    'is_Profile': '',
    'FCM_Token': '',
    'User': '',
    'Profile_Code': '',
  };

  Map<String, dynamic> initialValues = {
    'Profile_Id': '',
    'Business_Name': '',
    'Business_Address': '',
    'Business_Category': '',
    'First_Name': '',
    'Last_Name': '',
    'Mobile': '',
    'ABN': '',
  };
  List<String> _selectedFrequency = [];
  final List<String> _frequencyFoodSupply = ['Daily', 'Weekly', 'On-Demand'];

  var businessCategoryName;

  List businessCategory = [];

  var _businessCategoryName;

  var result;

  var latitude;

  var longitude;

  var selectedDeliveryType;

  @override
  void initState() {
    super.initState();
    Provider.of<ApiCalls>(context, listen: false).generalException.clear();
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;

      Provider.of<ApiCalls>(context, listen: false)
          .fetchBusinessCategory(token)
          .then((value) => null);
    });
    var data = Get.arguments;
    print(data);
    if (data != null) {
      initialValues = {
        'Profile_Id': data[0]['Profile_Id'],
        'Business_Name': data[0]['Business_Name'],
        'Business_Address': data[0]['Business_Address'],
        'Business_Category': data[0]['Business_Category'],
        'First_Name': data[0]['First_Name'],
        'Last_Name': data[0]['Last_Name'],
        'Mobile': data[0]['Mobile'],
        'ABN': data[0]['ABN'],
        'LGA_Licence_No': data[0]['LGA_Licence_No'],
        'Delivery_Charge': data[0]['Delivery_Charges'].toString()
      };

      businessAddressController.text = data[0]['Business_Address'];
      editedBusinessProfile['LGA_Licence_No'] = data[0]['LGA_Licence_No'];
      editedBusinessProfile['Profile_Id'] = data[0]['Profile_Id'];
      editedBusinessProfile['is_Profile'] = data[0]['is_Profile'];
      editedBusinessProfile['User'] = data[0]['User'];
      editedBusinessProfile['FCM_Token'] = data[0]['FCM_Token'] == '' ||
              data[0]['FCM_Token'] == null ||
              data[0]['FCM_Token'] == ' '
          ? 'No Data'
          : data[0]['FCM_Token'];
      // editedBusinessProfile['Business_Category'] = data[0]['Business_Category'];
      editedBusinessProfile['Profile_Code'] = data[0]['Profile_Code'];
      businessCategoryName = data[0]['Business_Category__Business_Category'];
      _businessCategoryName = data[0]['Business_Category__Business_Category'];
      editedBusinessProfile['Latitude'] = data[0]['Latitude'];
      editedBusinessProfile['Longitude'] = data[0]['Longitude'];
      selectedDeliveryType = data[0]['Delivery_Mode'];
      editedBusinessProfile['Delivery_Mode'] = data[0]['Delivery_Mode'];
      if (data[0]['Food_Supply_Frequency'].isNotEmpty) {
        for (var data in data[0]['Food_Supply_Frequency']) {
          _selectedFrequency.add(data);
        }
      }

      editedBusinessProfile['Food_Supply_Frequency'] =
          data[0]['Food_Supply_Frequency'];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var validate = true;
  double errorHeight = 80;

  void save() {
    validate = _formKey.currentState!.validate();
    if (validate != true) {
      return;
    }
    _formKey.currentState!.save();
    // print(editedBusinessProfile);

    EasyLoading.show();
    print(
      'Latitude and Longitude $latitude,$longitude',
    );
    if (latitude != null && longitude != null) {
      editedBusinessProfile['Latitude'] = latitude;
      editedBusinessProfile['Longitude'] = longitude;
    }

    if (selectedDeliveryType == null) {
      Get.showSnackbar(const GetSnackBar(
        title: 'Alert',
        message: 'Please select delivery type',
        duration: Duration(seconds: 4),
      ));
    }

    editedBusinessProfile['Food_Supply_Frequency'] = _selectedFrequency;

    print(editedBusinessProfile);
    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false)
          .editProfileDetails(editedBusinessProfile, token)
          .then((value) async {
        EasyLoading.dismiss();
        if (value['Status_Code'] == 202 || value['Status_Code'] == 201) {
          Get.back();
          Get.showSnackbar(GetSnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).backgroundColor,
            message: 'Successfully Updated the Data',
            title: 'Success',
          ));
          Provider.of<ApiCalls>(context, listen: false)
              .fetchProfileDetails(token)
              .then((value) async {
            if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {}
          });
        } else {
          // Get.defaultDialog(
          //   title: value['Response_Body'][0]['heading'],
          //   middleText: value['Response_Body'][0]['body'][0],
          //   confirm: TextButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     child: const Text('ok'),
          //   ),
          // );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    businessCategory = Provider.of<ApiCalls>(context).businessCategoryList;
    if (businessCategory.isNotEmpty) {
      for (var data in businessCategory) {
        if (data['Business_Category'] == businessCategoryName.toString()) {
          editedBusinessProfile['Business_Category'] =
              data['Business_Category_Id'];
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Busines Profile',
          style: GoogleFonts.roboto(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('Business Name'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['Business_Name'],
                          decoration: const InputDecoration(
                              hintText: 'Business Name',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              // showError('FirmCode');
                              return 'Business name cannot be empty';
                            }
                          },
                          onSaved: (value) {
                            editedBusinessProfile['Business_Name'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('Business Address'),
                    ),
                    Row(
                      children: [
                        Container(
                          width: width * 0.75,
                          height: validate == true ? 60 : errorHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: Colors.black26),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: TextFormField(
                              enabled: false,
                              maxLines: 4,
                              controller: businessAddressController,
                              decoration: const InputDecoration(
                                  hintText: 'Business Address',
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // showError('FirmCode');
                                  return 'Business address cannot be empty';
                                }
                              },
                              onSaved: (value) {
                                editedBusinessProfile['Business_Address'] =
                                    value;
                              },
                            ),
                          ),
                        ),
                        IconButton(
                            tooltip: 'Choose From Map',
                            onPressed: () async {
                              result = await Get.toNamed(MapScreen.routeName);
                              if (result != null) {
                                setState(() {
                                  businessAddressController.text =
                                      result['Address'];
                                  latitude = result['Latitude'];
                                  longitude = result['Longitude'];
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.map_outlined,
                              size: 35,
                              color: Color.fromRGBO(255, 114, 76, 1),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('Busines Category'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: businessCategoryName,
                            items: businessCategory
                                .map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem(
                                child: Text(e['Business_Category']),
                                value: e['Business_Category'],
                                onTap: () {
                                  _businessCategoryName =
                                      e['Business_Category_Id'];
                                  editedBusinessProfile['Business_Category'] = e[
                                      'Business_Category_Id']; // _plantId = e['Plant_Id'];
                                  // _plantName =
                                  //     e['Plant_Name'];
                                  // wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                                },
                              );
                            }).toList(),
                            hint: const Text('Choose business name'),
                            onChanged: (value) {
                              setState(() {
                                businessCategoryName = value as String;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('First Name'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['First_Name'],
                          decoration: const InputDecoration(
                              hintText: 'First Name', border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              // showError('FirmCode');
                              return 'First name cannot be empty';
                            }
                          },
                          onSaved: (value) {
                            editedBusinessProfile['First_Name'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('Last name'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['Last_Name'],
                          decoration: const InputDecoration(
                              hintText: 'Last Name', border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              // showError('FirmCode');
                              return 'Last name cannot be empty';
                            }
                          },
                          onSaved: (value) {
                            editedBusinessProfile['Last_Name'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('Mobile'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['Mobile'],
                          decoration: const InputDecoration(
                              hintText: 'Mobile', border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              // showError('FirmCode');
                              return 'Mobile number cannot be empty';
                            }
                          },
                          onSaved: (value) {
                            editedBusinessProfile['Mobile'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text.rich(TextSpan(children: [
                        TextSpan(text: 'Delivery Charge (\$/km)'),
                        TextSpan(text: '*', style: TextStyle(color: Colors.red))
                      ])),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['Delivery_Charge'],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Enter \$ amount',
                            border: InputBorder.none,
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     // showError('FirmCode');
                          //     return 'Delivery Charge cannot be empty';
                          //   }
                          // },
                          onSaved: (value) {
                            if (value == null || value.isEmpty) {
                              editedBusinessProfile['Delivery_Charges'] = 0;
                            } else {
                              editedBusinessProfile['Delivery_Charges'] = value;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Align(
                  // alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: width - horizontalPadding,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: const Text.rich(TextSpan(children: [
                          TextSpan(text: 'Delivery Type'),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red))
                        ])),
                      ),
                      Container(
                        width: width - horizontalPadding,
                        height: 47,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: selectedDeliveryType,
                              items: [
                                'PickUp',
                                'PickUp/Delivery',
                                'Catering Only'
                              ].map<DropdownMenuItem<String>>((e) {
                                return DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                  onTap: () {
                                    editedBusinessProfile['Delivery_Mode'] = e;
                                    // _plantId = e['Plant_Id'];
                                    // _plantName =
                                    //     e['Plant_Name'];
                                    // wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                                  },
                                );
                              }).toList(),
                              hint: const Text('Choose Delivery Type'),
                              onChanged: (value) {
                                setState(() {
                                  selectedDeliveryType = value as String;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Align(
                  // alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: width - horizontalPadding,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: const Text.rich(TextSpan(children: [
                          TextSpan(text: 'Frequency Of Food Supply'),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red))
                        ])),
                      ),
                      Container(
                        width: width - horizontalPadding,
                        height: 47,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.black26),
                        ),
                        child: DropDownMultiSelect(
                            options: _frequencyFoodSupply,
                            selectedValues: _selectedFrequency,
                            onChanged: (List<String> value) {
                              setState(() {
                                _selectedFrequency = value;
                              });
                            },
                            whenEmpty: 'Select'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('ABN'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['ABN'],
                          decoration: const InputDecoration(
                              hintText: 'Australian Business Number',
                              border: InputBorder.none),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     // showError('FirmCode');
                          //     return 'ABN cannot be empty';
                          //   }
                          // },
                          onSaved: (value) {
                            editedBusinessProfile['ABN'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: horizontalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: width - horizontalPadding,
                      padding: const EdgeInsets.only(bottom: 12),
                      child: const Text('LGA Licence Number'),
                    ),
                    Container(
                      width: width - horizontalPadding,
                      height: validate == true ? 40 : errorHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: TextFormField(
                          initialValue: initialValues['LGA_Licence_No'],
                          decoration: const InputDecoration(
                              hintText: 'LGA Licence Number',
                              border: InputBorder.none),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     // showError('FirmCode');
                          //     return 'ABN cannot be empty';
                          //   }
                          // },
                          onSaved: (value) {
                            editedBusinessProfile['LGA_Licence_No'] = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Align(
                  // alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: width / 1.2,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Consumer<ApiCalls>(
                            builder: (context, value, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.generalException.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Column(
                                  children: [
                                    Text(
                                      value.generalException[index]
                                              ['heading'] ??
                                          '',
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      value.generalException[index]['value']
                                              [0] ??
                                          '',
                                      style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: width - horizontalPadding,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: save,
                  child: const Text('save')),
            ),
          ],
        ),
      ),
    );
  }
}
