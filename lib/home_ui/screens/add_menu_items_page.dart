import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oota_business/authentication/providers/authenticate.dart';
import 'package:oota_business/home_ui/providers/api_calls.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class AddMenuItems extends StatefulWidget {
  AddMenuItems({Key? key}) : super(key: key);

  static const routeName = '/AddMenuItem';

  @override
  _AddMenuItemsState createState() => _AddMenuItemsState();
}

class _AddMenuItemsState extends State<AddMenuItems> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  double horizontalPadding = 20;
  double verticalPadding = 10;

  Map<String, dynamic> itemDetails = {
    'Profile': '',
    'Food_Name': '',
    'Ingredients': '',
    'Allergen': '',
    'Price': '',
    'Description': '',
    'Preparation_Time': '',
    'Cuisine': '',
  };

  var _profileId;
  var imageFile;
  List _fileBytes = [];
  Image? _imageWidgetFile = null;
  var fileName;
  var fileBase64;
  List<dynamic> imageList = [];

  bool isloading = false;
  final ImagePicker _picker = ImagePicker();

  double _heightValue = 60;

  List filenameList = [];

  var cuisinesCategoryName;

  List cuisinesCategory = [];
  ImageCropper cropper = ImageCropper();

  Future<void> getMultipleImageInfos() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    // List<XFile>? images = await _picker.pickMultiImage();

    // var mediaData = await ImagePickerWeb.getImageInfo;
    // String? mimeType = mime(Path.basename(mediaData.fileName!));
    // html.File mediaFile =
    //     html.File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    // if (images != null) {
    //   // imageList.clear();

    //   // for (var data in images) {
    //   //   filenameList.add(data.name);
    //   //   File? croppedFile = await ImageCropper.cropImage(
    //   //       sourcePath: data.path,
    //   //       aspectRatioPresets: [
    //   //         CropAspectRatioPreset.square,
    //   //         CropAspectRatioPreset.ratio3x2,
    //   //         CropAspectRatioPreset.original,
    //   //         CropAspectRatioPreset.ratio4x3,
    //   //         CropAspectRatioPreset.ratio16x9
    //   //       ],
    //   //       androidUiSettings: const AndroidUiSettings(
    //   //           toolbarTitle: 'Cropper',
    //   //           toolbarColor: Colors.black,
    //   //           toolbarWidgetColor: Colors.white,
    //   //           initAspectRatio: CropAspectRatioPreset.original,
    //   //           lockAspectRatio: false),
    //   //       iosUiSettings: const IOSUiSettings(
    //   //         minimumAspectRatio: 1.0,
    //   //       )).then((value) async {
    //   //     if (value == null) {
    //   //       return;
    //   //     }
    //   //     await value.readAsBytes().then((value) {
    //   //       imageList.add(value);
    //   //       setState(() {});
    //   //       // _fileBytes = value;
    //   //       // imageFile = data;
    //   //       // fileName = data.name;

    //   //       // if (_fileBytes.isNotEmpty) {
    //   //       //   setState(() {
    //   //       //     isloading = true;
    //   //       //   });
    //   //       // }
    //   //       // setState(() {

    //   //       //   // print(_fileBytes);
    //   //       //   // _cloudFile = mediaFile;
    //   //       //   // _fileBytes = mediaData.data!;
    //   //       //   // _imageWidget = Image.memory(mediaData.data!);
    //   //       //   // fileName = mediaData.fileName!;
    //   //       //   // fileBase64 = mediaData.base64;
    //   //       // });
    //   //     });
    //   //   });
    //   // }

    //   //   if (imageList.isNotEmpty) {
    //   //     print(imageList.length);
    //   //     setState(() {});
    //   //   }
    //   // }

    // }
    if (image != null) {
      File? croppedFile = await cropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
        ],
      ).then((value) {
        if (value == null) {
          return;
        }
        value.readAsBytes().then((value) {
          _fileBytes = value;
          imageFile = image;
          fileName = image.name;

          if (_fileBytes.isNotEmpty) {
            setState(() {
              isloading = true;
            });
          }
          // setState(() {

          //   // print(_fileBytes);
          //   // _cloudFile = mediaFile;
          //   // _fileBytes = mediaData.data!;
          //   // _imageWidget = Image.memory(mediaData.data!);
          //   // fileName = mediaData.fileName!;
          //   // fileBase64 = mediaData.base64;
          // });
        });
      });
    }
  }

  var validate = true;

  Future<void> save() async {
    validate = _formKey.currentState!.validate();

    if (validate != true) {
      setState(() {
        validate = false;
      });
      return;
    }

    EasyLoading.show();
    _formKey.currentState!.save();
    if (_fileBytes.isEmpty && imageList.isEmpty) {
      EasyLoading.dismiss();
      ByteData bytes = await rootBundle.load('assets/images/default image.png');
      _fileBytes = bytes.buffer.asUint8List();
      fileName = 'defaultImage.png';
      // Get.showSnackbar(GetSnackBar(
      //   duration: const Duration(seconds: 2),
      //   backgroundColor: Theme.of(context).backgroundColor,
      //   message: 'Please Select the image',
      //   title: 'Alert',
      // ));

    }

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      EasyLoading.show();

      Provider.of<ApiCalls>(context, listen: false)
          .fetchProfileDetails(token)
          .then((value) {
        if (value['Status_Code'] == 200 || value['Status_Code'] == 201) {
          _profileId = value['Response_Body'][0]['Profile_Id'];
          itemDetails['Profile'] = _profileId;
          // print(value);
          // print(itemDetails);

          Provider.of<ApiCalls>(context, listen: false)
              .addMenuItems(
                  itemDetails, _profileId, token, _fileBytes, fileName)
              .then((value) {
            EasyLoading.dismiss();
            if (value == 200 || value == 201) {
              EasyLoading.showSuccess('Success');
              Get.back(result: 'success');
              Get.showSnackbar(GetSnackBar(
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).backgroundColor,
                message: 'Successfully Added Item In Menu',
                title: 'Success',
              ));
            } else {
              EasyLoading.showError('Failed Something Went Wrong');
              // Get.showSnackbar(GetSnackBar(
              //   duration: const Duration(seconds: 2),
              //   backgroundColor: Theme.of(context).backgroundColor,
              //   message: 'Something Went Wrong please check your credentials',
              //   title: 'Failed',
              // ));
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    Provider.of<Authenticate>(context, listen: false)
        .tryAutoLogin()
        .then((value) {
      var token = Provider.of<Authenticate>(context, listen: false).token;
      Provider.of<ApiCalls>(context, listen: false).getCuisinesCategory(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    cuisinesCategory = Provider.of<ApiCalls>(context).cuisinesCategoryList;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(
            'Item Details',
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(color: Colors.black)),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding),
                    child: DottedBorder(
                      color: Colors.black,
                      borderType: BorderType.RRect,
                      strokeWidth: 1,
                      radius: const Radius.circular(5),
                      child: _fileBytes.isEmpty
                          ? Container(
                              width: width - horizontalPadding,
                              height: 200,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      getMultipleImageInfos();
                                    },
                                    icon:
                                        const Icon(Icons.add_a_photo_outlined),
                                  ),
                                  const Text('Add Image')
                                ],
                              ),
                              // decoration: BoxDecoration(border: Border.all()),
                            )
                          : Container(
                              width: width - horizontalPadding,
                              height: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(
                                    Uint8List.fromList(
                                        _fileBytes.cast<int>().toList()),
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      getMultipleImageInfos();
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Text(
                                    'change Image',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              // decoration: BoxDecoration(border: Border.all()),
                            ),
                      // : Container(
                      //     width: width - horizontalPadding,
                      //     height: 200,
                      //     child: ListView.builder(
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: imageList.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return Container(
                      //           width: width - horizontalPadding,
                      //           height: 200,
                      //           alignment: Alignment.center,
                      //           decoration: BoxDecoration(
                      //             shape: BoxShape.rectangle,
                      //             image: DecorationImage(
                      //               fit: BoxFit.fill,
                      //               image: MemoryImage(
                      //                 Uint8List.fromList(imageList[index]
                      //                     .cast<int>()
                      //                     .toList()),
                      //               ),
                      //             ),
                      //           ),
                      //           child: Column(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               IconButton(
                      //                 onPressed: () {
                      //                   getMultipleImageInfos();
                      //                 },
                      //                 icon: const Icon(
                      //                   Icons.add_a_photo_outlined,
                      //                   color: Colors.grey,
                      //                 ),
                      //               ),
                      //               const Text(
                      //                 'change Image',
                      //                 style: TextStyle(color: Colors.grey),
                      //               )
                      //             ],
                      //           ),
                      //           // decoration: BoxDecoration(border: Border.all()),
                      //         );
                      //       },
                      //     ),
                      //   ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    child: const Divider(
                      thickness: 3,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Align(
                      // alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: width - horizontalPadding,
                            padding: const EdgeInsets.only(bottom: 6),
                            child: const Text.rich(TextSpan(children: [
                              TextSpan(text: 'Cuisines Category'),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red))
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
                                  value: cuisinesCategoryName,
                                  items: cuisinesCategory
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      value: e['Cuisine'],
                                      onTap: () {
                                        cuisinesCategoryName = e['Cuisine'];
                                        itemDetails['Cuisine'] =
                                            e['Cuisine_Id'].toString();

                                        // _plantId = e['Plant_Id'];
                                        // _plantName =
                                        //     e['Plant_Name'];
                                        // wareHouseDetails['Plant_Id'] = e['Plant_Id'];
                                      },
                                      child: Text(e['Cuisine']),
                                    );
                                  }).toList(),
                                  hint: const Text('Choose cuisines category'),
                                  onChanged: (value) {
                                    setState(() {
                                      cuisinesCategoryName = value as String;
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
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: width - horizontalPadding,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Food/Groceries Name'),
                                TextSpan(
                                    text: '*',
                                    style: TextStyle(color: Colors.red))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: width - horizontalPadding,
                          height: validate == false ? _heightValue : 40,
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
                              decoration: const InputDecoration(
                                  hintText: 'Enter Food/Groceries Name',
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // showError('FirmCode');
                                  return 'Name cannot be empty';
                                }
                              },
                              onSaved: (value) {
                                itemDetails['Food_Name'] = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: width - horizontalPadding,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text.rich(TextSpan(children: [
                            TextSpan(text: 'Price'),
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red))
                          ])),
                        ),
                        Container(
                          width: width - horizontalPadding,
                          height: validate == false ? _heightValue : 40,
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
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Price',
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  // showError('FirmCode');
                                  return 'Price cannot be empty';
                                }
                              },
                              onSaved: (value) {
                                itemDetails['Price'] = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: width - horizontalPadding,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text.rich(TextSpan(children: [
                            TextSpan(text: 'Preparation Time'),
                            // TextSpan(
                            //     text: '*', style: TextStyle(color: Colors.red))
                          ])),
                        ),
                        Container(
                          width: width - horizontalPadding,
                          height: validate == false ? _heightValue : 40,
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
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Time(In Minutes)',
                                  border: InputBorder.none),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     // showError('FirmCode');
                              //     return 'Preparation time cannot be empty';
                              //   }
                              // },
                              onSaved: (value) {
                                itemDetails['Preparation_Time'] = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: width - horizontalPadding,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text.rich(TextSpan(children: [
                            TextSpan(text: 'Ingredients'),
                            // TextSpan(
                            //     text: '*', style: TextStyle(color: Colors.red))
                          ])),
                        ),
                        Container(
                          width: width - horizontalPadding,
                          height: validate == false ? _heightValue : 40,
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
                              decoration: const InputDecoration(
                                  hintText: 'Enter ingredients(optional)',
                                  border: InputBorder.none),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     // showError('FirmCode');
                              //     return 'Ingredients cannot be empty';
                              //   }
                              // },
                              onSaved: (value) {
                                itemDetails['Ingredients'] = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical: verticalPadding,
                  //       horizontal: horizontalPadding),
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Container(
                  //         width: width - horizontalPadding,
                  //         padding: const EdgeInsets.only(bottom: 12),
                  //         child: const Text.rich(TextSpan(children: [
                  //           TextSpan(text: 'Allergen'),
                  //           // TextSpan(
                  //           //     text: '*', style: TextStyle(color: Colors.red))
                  //         ])),
                  //       ),
                  //       Container(
                  //         width: width - horizontalPadding,
                  //         height: validate == false ? _heightValue : 40,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(8),
                  //           color: Colors.white,
                  //           border: Border.all(color: Colors.black26),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //             horizontal: 12,
                  //           ),
                  //           child: TextFormField(
                  //             decoration: const InputDecoration(
                  //                 hintText: 'Enter Allergen(optional)',
                  //                 border: InputBorder.none),
                  //             // validator: (value) {
                  //             //   if (value!.isEmpty) {
                  //             //     // showError('FirmCode');
                  //             //     return 'Allergen cannot be empty';
                  //             //   }
                  //             // },
                  //             onSaved: (value) {
                  //               itemDetails['Allergen'] = value;
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: width - horizontalPadding,
                          padding: const EdgeInsets.only(bottom: 12),
                          child: const Text('Description'),
                        ),
                        Container(
                          width: width - horizontalPadding,
                          height: 80,
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
                              decoration: const InputDecoration(
                                  hintText: 'Enter Description(Optional)',
                                  border: InputBorder.none),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     // showError('FirmCode');
                              //     return 'Description cannot be empty';
                              //   }
                              // },
                              onSaved: (value) {
                                itemDetails['Description'] = value;
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
                    height: 90,
                  ),
                ],
              ),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: save,
                    child: const Text('save')),
              ),
            ],
          ),
        ),
        // floatingActionButton:
      ),
    );
  }
}
