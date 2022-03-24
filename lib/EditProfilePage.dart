import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'generated/l10n.dart';
import 'model/AddressModel.dart';
import 'util/ConstantData.dart';
import 'util/ConstantWidget.dart';
import 'util/DataFile.dart';
import 'util/SizeConfig.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePage createState() {
    return _EditProfilePage();
  }
}

class _EditProfilePage extends State<EditProfilePage> {
  List<AddressModel> addressList = DataFile.getAddressList();

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController mailController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    addressList = DataFile.getAddressList();

    firstNameController.text = "harry";
    lastNameController.text = "harry";
    mailController.text = "fd@gamil.com";
    genderController.text = "Male";
    phoneController.text = "326598659";

    setState(() {});
  }

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(true);
  }

  PickedFile _image;
  final picker = ImagePicker();

  _imgFromGallery() async {
    PickedFile image =
        await ImagePicker().getImage(source: ImageSource.gallery);
    print(image.path);
    setState(() {
      _image = image;
    });
  }

  getProfileImage() {
    if (_image != null && _image.path.isNotEmpty) {
      return Image.file(
        File(_image.path),
        fit: BoxFit.cover,
      );
    } else {
      //
      return Image.asset(
        ConstantData.assetsPath + "hugh.png",
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double editTextHeight = MediaQuery.of(context).size.height * 0.06;

    double profileHeight = ConstantWidget.getScreenPercentSize(context, 15);
    double defaultMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double editSize = ConstantWidget.getPercentSize(profileHeight, 24);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: ConstantData.bgColor,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: ConstantData.primaryColor,
            title: ConstantWidget.getAppBarText(S.of(context).editProfiles),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: ConstantWidget.getAppBarIcon(),
                  onPressed: _requestPop,
                );
              },
            ),
          ),
          bottomNavigationBar:
              ConstantWidget.getBottomText(context, S.of(context).save, () {
            Navigator.of(context).pop(true);
          }),
          body: Container(
            margin: EdgeInsets.only(
                top: ConstantWidget.getScreenPercentSize(context, 2)),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                          height: profileHeight + (profileHeight / 5),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: profileHeight,
                                    width: profileHeight,
                                    decoration: BoxDecoration(
                                        color: ConstantData.primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: ConstantData.primaryColor,
                                            width: ConstantWidget
                                                .getScreenPercentSize(
                                                    context, 0.2))),
                                    child: ClipOval(
                                      child: Material(
                                        color: ConstantData.primaryColor,
                                        child: getProfileImage(),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: ConstantWidget
                                              .getScreenPercentSize(
                                                  context, 10),
                                          bottom: ConstantWidget
                                              .getScreenPercentSize(
                                                  context, 2.7)),
                                      height: editSize,
                                      width: editSize,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ConstantData.primaryColor,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.photo_camera_back,
                                            color: Colors.white,
                                            size: ConstantWidget.getPercentSize(
                                                editSize, 48),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      _imgFromGallery();
                                    },
                                    // onTap: _imgFromGallery,
                                  ),
                                )
                              ],
                            ),
                          )),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: defaultMargin),
                        color: ConstantData.cellColor,
                        padding: EdgeInsets.all(defaultMargin),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: ConstantWidget.getCustomTextWithoutAlign(
                                  S.of(context).userInformation,
                                  ConstantData.mainTextColor,
                                  FontWeight.bold,
                                  ConstantData.font22Px),
                            ),
                            SizedBox(
                              height: (defaultMargin / 2),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: (defaultMargin / 2)),
                                        padding: EdgeInsets.only(
                                            right: (defaultMargin / 1.5)),
                                        height: editTextHeight,
                                        child: TextField(
                                          maxLines: 1,
                                          controller: firstNameController,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantData.fontFamily,
                                              color: ConstantData.mainTextColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: ConstantData.font18Px),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            labelStyle: TextStyle(
                                                fontFamily:
                                                    ConstantData.fontFamily,
                                                color: ConstantData.textColor),
                                            labelText: S.of(context).firstName,
                                            // hintText: 'Full Name',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: (defaultMargin / 2)),
                                        padding: EdgeInsets.only(
                                            left: (defaultMargin / 1.5)),
                                        height: editTextHeight,
                                        child: TextField(
                                          controller: lastNameController,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantData.fontFamily,
                                              color: ConstantData.mainTextColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: ConstantData.font18Px),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            labelStyle: TextStyle(
                                                fontFamily:
                                                    ConstantData.fontFamily,
                                                color: ConstantData.textColor),
                                            labelText: S.of(context).lastName,
                                            // hintText: 'Full Name',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: (defaultMargin / 2)),
                              height: editTextHeight,
                              child: TextField(
                                maxLines: 1,
                                controller: mailController,
                                style: TextStyle(
                                    fontFamily: ConstantData.fontFamily,
                                    color: ConstantData.mainTextColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ConstantData.font18Px),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: BorderSide(
                                        color: ConstantData.textColor,
                                        width: 0.0),
                                  ),

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ConstantData.textColor,
                                        width: 0.0),
                                  ),

                                  labelStyle: TextStyle(
                                      fontFamily: ConstantData.fontFamily,
                                      color: ConstantData.textColor),
                                  labelText: S.of(context).emailAddressHint,
                                  // hintText: 'Full Name',
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: (defaultMargin / 2)),
                                        padding: EdgeInsets.only(
                                            right: (defaultMargin / 1.5)),
                                        height: editTextHeight,
                                        child: TextField(
                                          maxLines: 1,
                                          controller: genderController,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantData.fontFamily,
                                              color: ConstantData.mainTextColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: ConstantData.font18Px),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            labelStyle: TextStyle(
                                                fontFamily:
                                                    ConstantData.fontFamily,
                                                color: ConstantData.textColor),
                                            labelText: S.of(context).gender,
                                            // hintText: 'Full Name',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: (defaultMargin / 2)),
                                        padding: EdgeInsets.only(
                                            left: (defaultMargin / 1.5)),
                                        height: editTextHeight,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          maxLines: 1,
                                          controller: phoneController,
                                          style: TextStyle(
                                              fontFamily:
                                                  ConstantData.fontFamily,
                                              color: ConstantData.mainTextColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: ConstantData.font18Px),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              // width: 0.0 produces a thin "hairline" border
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: ConstantData.textColor,
                                                  width: 0.0),
                                            ),

                                            labelStyle: TextStyle(
                                                fontFamily:
                                                    ConstantData.fontFamily,
                                                color: ConstantData.textColor),
                                            labelText: S.of(context).phone,
                                            // hintText: 'Full Name',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  flex: 1,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: (defaultMargin)),
                      //   padding: EdgeInsets.only(left: leftMargin,right: leftMargin,top: leftMargin),
                      //
                      //   color: ConstantData.cellColor,
                      //
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         child: Row(
                      //           children: [
                      //
                      //
                      //             ConstantWidget.getTextWidget(
                      //                 S.of(context).addressTitle,
                      //                 ConstantData.mainTextColor,
                      //                 TextAlign.start,
                      //                 FontWeight.w800,
                      //                 ConstantWidget.getScreenPercentSize(
                      //                     context, 2.5)),
                      //
                      //
                      //
                      //
                      //             new Spacer(),
                      //             InkWell(
                      //
                      //               child:       ConstantWidget.getUnderlineText(S.of(context).newAddress,
                      //                   Colors.orange,
                      //                   1,
                      //                   TextAlign.start, FontWeight.bold, ConstantWidget.getScreenPercentSize(
                      //                       context, 2)),
                      //
                      //
                      //
                      //               onTap: () {
                      //                 Navigator.push(
                      //                     context,
                      //                     MaterialPageRoute(
                      //                         builder: (context) =>
                      //                             AddNewAddressPage()));
                      //               },
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //
                      //
                      //       SizedBox(
                      //         height:
                      //         ConstantWidget.getScreenPercentSize(context, 3),
                      //       ),
                      //       Container(
                      //         color: ConstantData.mainTextColor,
                      //         height: ConstantWidget.getScreenPercentSize(
                      //             context, 0.02),
                      //       ),
                      //
                      //
                      //       Container(
                      //
                      //         child: ListView.builder(
                      //             shrinkWrap: true,
                      //             physics: NeverScrollableScrollPhysics(),
                      //             itemCount: addressList.length,
                      //             itemBuilder: (context, index) {
                      //               return InkWell(
                      //                 child: Column(
                      //                   children: [
                      //                     Container(
                      //                       height:
                      //                       cellHeight,
                      //
                      //                       child: Column(
                      //                         mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                         crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               Expanded(
                      //                                 child: Row(
                      //                                   mainAxisAlignment:
                      //                                   MainAxisAlignment.start,
                      //                                   crossAxisAlignment:
                      //                                   CrossAxisAlignment.center,
                      //                                   children: [
                      //                                     Column(
                      //                                       mainAxisAlignment:
                      //                                       MainAxisAlignment
                      //                                           .start,
                      //                                       crossAxisAlignment:
                      //                                       CrossAxisAlignment
                      //                                           .start,
                      //                                       children: [
                      //
                      //                                         ConstantWidget.getCustomTextWithoutAlign(addressList[index].name,
                      //                                             ConstantData.textColor, FontWeight.w700, ConstantWidget.getPercentSize(cellHeight,
                      //                                                 20)),
                      //
                      //                                         Padding(
                      //                                           padding:
                      //                                           EdgeInsets.only(
                      //                                               top: (topMargin/2)),
                      //
                      //                                           child:ConstantWidget.getCustomTextWithoutAlign(addressList[index].location,
                      //                                               ConstantData.mainTextColor, FontWeight.w500, ConstantWidget.getPercentSize(cellHeight,
                      //                                                   15)),
                      //
                      //                                         )
                      //                                       ],
                      //                                     ),
                      //                                     new Spacer(),
                      //                                     Align(
                      //                                       alignment:
                      //                                       Alignment.centerRight,
                      //                                       child: Padding(
                      //                                         padding:
                      //                                         EdgeInsets.only(
                      //                                             right: 3),
                      //                                         child: Icon(
                      //                                           (index ==
                      //                                               _selectedPosition)
                      //                                               ? Icons
                      //                                               .radio_button_checked
                      //                                               : Icons
                      //                                               .radio_button_unchecked,
                      //                                           color: (index ==
                      //                                               _selectedPosition)
                      //                                               ? ConstantData
                      //                                               .textColor
                      //                                               : Colors.grey,
                      //                                           size: ConstantWidget.getPercentSize(cellHeight,
                      //                                               25),
                      //                                         ),
                      //                                       ),
                      //                                     )
                      //                                   ],
                      //                                 ),
                      //                                 flex: 1,
                      //                               )
                      //                             ],
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     Visibility(child: Container(
                      //                       height: ConstantWidget.getScreenPercentSize(context,0.02),
                      //                       color: ConstantData.textColor,
                      //                       margin: EdgeInsets.only(bottom: topMargin),
                      //                     ),visible: (index != (addressList.length-1)),)
                      //
                      //                   ],
                      //                 ),
                      //                 onTap: () {
                      //                   _selectedPosition = index;
                      //                   setState(() {});
                      //                 },
                      //               );
                      //             }),
                      //       ),],
                      //   ),
                      // ),
                      SizedBox(
                        height: defaultMargin,
                      )
                    ],
                  ),
                  flex: 1,
                ),
                // InkWell(
                //   child: Container(
                //       margin: EdgeInsets.only(top: 10, bottom: leftMargin),
                //       height: 50,
                //       decoration: BoxDecoration(
                //           color: ConstantData.primaryColor,
                //           borderRadius: BorderRadius.all(Radius.circular(8))),
                //       child: InkWell(
                //         child: Center(
                //           child: ConstantWidget.getCustomTextWithoutAlign(
                //               S.of(context).save,
                //               Colors.white,
                //               FontWeight.w900,
                //               ConstantData.font15Px),
                //
                //           // child: Text(
                //           //   S.of(context).save,
                //           //   style: TextStyle(
                //           //       fontFamily: ConstantData.fontFamily,
                //           //       fontWeight: FontWeight.w900,
                //           //       fontSize: ConstantData.font15Px,
                //           //       color: Colors.white,
                //           //       decoration: TextDecoration.none),
                //           // ),
                //         ),
                //       )),
                //   onTap: () {
                //     Navigator.of(context).pop(true);
                //   },
                // ),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }
}
