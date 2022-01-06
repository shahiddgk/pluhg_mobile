import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plug/app/values/colors.dart';
import 'package:plug/utils/permissions.dart';
import 'package:plug/widgets/widgets_show.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'open_setting.dart';

class MultiImagePicker extends StatefulWidget {
  MultiImagePicker(
      {Key? key,
      required this.title,
      required this.callback,
      this.writeMessage,
      this.profile = false})
      : super(key: key);

  final String title;
  final Function callback;
  final bool profile;
  final Future<void> Function(String url, int timestamp)? writeMessage;

  @override
  _MultiImagePickerState createState() => new _MultiImagePickerState();
}

class _MultiImagePickerState extends State<MultiImagePicker> {
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  String? error;
  String mode = 'single';
  List<XFile> selectedImages = [];
  int currentUploadingIndex = 0;
  late int maxNoOfFilesInMultiSharing = 8;
  late int maxFileSizeAllowedInMB = 215;

  @override
  void initState() {
    super.initState();
  }

  bool checkTotalNoOfFilesIfExceeded() {
    if (selectedImages.length > maxNoOfFilesInMultiSharing) {
      return true;
    } else {
      return false;
    }
  }

  bool checkIfAnyFileSizeExceeded() {
    int index = selectedImages.indexWhere((file) =>
        File(file.path).lengthSync() / 1000000 > maxFileSizeAllowedInMB);
    if (index >= 0) {
      return true;
    } else {
      return false;
    }
  }

  void captureSingleImage(ImageSource captureMode) async {
    error = null;
    try {
      XFile? pickedImage = await (picker.pickImage(source: captureMode));
      if (pickedImage != null) {
        if (File(pickedImage.path).lengthSync() / 1000000 >
            maxFileSizeAllowedInMB) {
          error =
              'File should be less than - ${maxFileSizeAllowedInMB}MB\n\n File size is - ${(File(pickedImage.path).lengthSync() / 1000000).round()}MB';
          print('errrror');
          setState(() {
            mode = "single";
            selectedImages = [];
          });
        } else {
          setState(() {
            mode = "single";
            selectedImages.add(pickedImage);
          });
        }
      }
    } catch (e) {}
  }

  void captureMultiPageImage(bool isAddOnly) async {
    error = null;
    try {
      if (isAddOnly) {
        //--- Is adding to already selected images list.
        List<XFile>? images = await picker.pickMultiImage();
        if (images!.length > 0) {
          images.forEach((image) {
            if (!selectedImages.contains(image)) {
              selectedImages.add(image);
            }
          });

          mode = 'multi';
          error = null;
          setState(() {});
        }
      } else {
        //--- Is adding to empty selected image list.
        List<XFile>? images = await picker.pickMultiImage();
        if (images!.length > 1) {
          selectedImages = images;
          mode = 'multi';
          error = null;
          setState(() {});
        } else if (images.length == 1) {
          if (File(images[0].path).lengthSync() / 1000000 >
              maxFileSizeAllowedInMB) {
            error =
                'File should be less than - ${maxFileSizeAllowedInMB}MB\n\nSelected File size is - ${(File(images[0].path).lengthSync() / 1000000).round()}MB';
            setState(() {
              mode = "single";
            });
          } else {
            setState(() {
              mode = "single";
              selectedImages = images;
            });
          }
        }
      }
    } catch (e) {}
  }

  Widget _buildSingleImage({File? file}) {
    if (file != null) {
      return new Image.file(file);
    } else {
      return new Text("Take picture",
          style: new TextStyle(
            fontSize: 18.0.sp,
            color: AppColors.pluhgMenuBlackColour,
          ));
    }
  }

  Widget _buildMultiImageLoading() {
    return Container(
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${currentUploadingIndex + 1}/${selectedImages.length}',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                color: AppColors.activeIconColour),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Sending ..",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17.sp,
              color: AppColors.pluhgMenuBlackColour,
            ),
          )
        ],
      )),
      color: AppColors.pluhgWhite.withOpacity(0.8),
    );
  }

  Widget _buildMultiImage() {
    if (selectedImages.length > 0) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7),
          itemCount: selectedImages.length,
          itemBuilder: (BuildContext context, i) {
            return Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.width / 2) - 20,
                    width: (MediaQuery.of(context).size.width / 2) - 20,
                    color: AppColors.pluhgGreyColour.withOpacity(0.4),
                  ),
                  new Image.file(
                    File(selectedImages[i].path),
                    fit: BoxFit.cover,
                    height: (MediaQuery.of(context).size.width / 2) - 20,
                    width: (MediaQuery.of(context).size.width / 2) - 20,
                  ),
                  File(selectedImages[i].path).lengthSync() / 1000000 >
                          maxFileSizeAllowedInMB
                      ? Container(
                          height: (MediaQuery.of(context).size.width / 2) - 20,
                          width: (MediaQuery.of(context).size.width / 2) - 20,
                          color: Colors.white70,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsetsDirectional.all(10),
                              child: Text(
                                'File should be less than - ${maxFileSizeAllowedInMB}MB\nSelected File size is - ${(File(selectedImages[i].path).lengthSync() / 1000000).round()}MB',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.pluhgRedColour,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 6,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Positioned(
                    right: 7,
                    top: 7,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedImages.removeAt(i);
                          if (selectedImages.length <= 1) {
                            mode = "single";
                          }
                        });
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: new Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // decoration: BoxDecoration(
              //     color: Colors.amber, borderRadius: BorderRadius.circular(15)),
            );
          });
    } else {
      return new Text("Take picture",
          style: new TextStyle(
            fontSize: 18.0.sp,
            color: AppColors.pluhgMenuBlackColour,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                if (!isLoading) {
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
                color: AppColors.pluhgMenuBlackColour,
              ),
            ),
            title: new Text(
              selectedImages.length > 0
                  ? '${selectedImages.length} Selected'
                  : widget.title,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.pluhgMenuBlackColour,
              ),
            ),
            actions: selectedImages.length != 0 && !isLoading
                ? <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.check,
                          color: AppColors.pluhgMenuBlackColour,
                        ),
                        onPressed: checkTotalNoOfFilesIfExceeded() == false
                            ? (checkIfAnyFileSizeExceeded() == false
                                ? () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    uploadEach(0);
                                  }
                                : () {
                                    ShowWidgets.toast(
                                        "One or more file size exceeded the allowed maximum Size" +
                                            ': ${maxFileSizeAllowedInMB}MB');
                                  })
                            : () {
                                ShowWidgets.toast(
                                    'Maximum number of files can be selected: ${maxNoOfFilesInMultiSharing}');
                              }),
                    SizedBox(
                      width: 8.0,
                    )
                  ]
                : []),
        body: Stack(children: [
          new Column(children: [
            mode == 'single'
                ? new Expanded(
                    child: new Center(
                        child: error != null
                            ? ShowWidgets.fileSizeErrorWidget(error!)
                            : _buildSingleImage(
                                file: selectedImages.length > 0
                                    ? File(selectedImages[0].path)
                                    : null)))
                : new Expanded(child: new Center(child: _buildMultiImage())),
            _buildButtons()
          ]),
          Positioned(
            child: isLoading
                ? mode == "multi" && selectedImages.length > 1
                    ? _buildMultiImageLoading()
                    : Container(
                        child: Center(
                          child: CupertinoActivityIndicator(
                              /*valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.activeIconColour)*/
                              ),
                        ),
                        color: AppColors.pluhgWhite.withOpacity(0.8),
                      )
                : Container(),
          )
        ]),
      ),
      onWillPop: () => Future.value(!isLoading),
    );
  }

  uploadEach(int index) async {
    if (index > selectedImages.length) {
      Navigator.of(context).pop();
    } else {
      int messagetime = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        currentUploadingIndex = index;
      });

      List<String> files = [];
      for (XFile i in selectedImages) {
        files.add(i.path);
      }
      widget.callback("image", 'png', files).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(
                  new Key('multi'),
                  Icons.photo_library,
                  checkTotalNoOfFilesIfExceeded() == false
                      ? () {
                          if (Platform.isAndroid) {
                            PermissionsUtil.checkAndRequestPermission(
                                    Permission.photos)
                                .then((res) {
                              if (res == true) {
                                captureMultiPageImage(false);
                              } else if (res == false) {
                                ShowWidgets.toast(
                                    "Permission to access Gallery need to select Photos");
                                Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => OpenSettings()));
                              } else {}
                            });
                          } else {
                            captureMultiPageImage(false);
                          }
                        }
                      : () {
                          ShowWidgets.toast(
                              'Maximum number of files can be selected: ${maxNoOfFilesInMultiSharing}');
                        }),
              selectedImages.length < 1
                  ? SizedBox()
                  : _buildActionButton(
                      new Key('multi'),
                      Icons.add,
                      checkTotalNoOfFilesIfExceeded() == false
                          ? () {
                              if (Platform.isAndroid) {
                                PermissionsUtil.checkAndRequestPermission(
                                        Permission.photos)
                                    .then((res) {
                                  if (res == true) {
                                    captureMultiPageImage(true);
                                  } else if (res == false) {
                                    ShowWidgets.toast(
                                        "Permission to access Gallery need to select Photos");

                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                OpenSettings()));
                                  } else {}
                                });
                              } else {
                                captureMultiPageImage(true);
                              }
                            }
                          : () {
                              ShowWidgets.toast(
                                  "Maximum number of files can be selected");
                            }),
              _buildActionButton(
                  new Key('upload'),
                  Icons.photo_camera,
                  checkTotalNoOfFilesIfExceeded() == false
                      ? () {
                          PermissionsUtil.checkAndRequestPermission(
                                  Permission.camera)
                              .then((res) {
                            if (res == true) {
                              captureSingleImage(ImageSource.camera);
                            } else if (res == false) {
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => OpenSettings()));
                            } else {}
                          });
                        }
                      : () {
                          ShowWidgets.toast(
                              'Maximum number of files can be selected: ${maxNoOfFilesInMultiSharing}');
                        }),
            ]));
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new RaisedButton(
          key: key,
          child: Icon(icon, size: 30.0),
          shape: new RoundedRectangleBorder(),
          color: AppColors.activeIconColour,
          textColor: AppColors.pluhgWhite,
          onPressed: onPressed as void Function()?),
    );
  }
}
