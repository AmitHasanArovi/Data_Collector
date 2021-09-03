import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'video_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class CameraExample extends StatefulWidget {
  @override
  _CameraExampleState createState() {
    return _CameraExampleState();
  }
}

class _CameraExampleState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  final GlobalKey _scaffoldKey = GlobalKey();
  String depth;
  String width;
  String height;
  String comment = "";
  Geolocator _geolocator;
  @override
  void initState() {
    super.initState();
    //getLocation();
    // Get the list of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Take Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: Colors.grey,
                  width: 5.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _cameraTogglesRowWidget(),
                _captureControlRowWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _thumbnailWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _commentWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _commentWidget() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Row(children: <Widget>[
              Text("Comment: ",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0)),
              SizedBox(width: 20),
              Container(
                width: 5000,
                height: 60,
                child: TextField(
                  onChanged: (text) {
                    comment = text;
                  },
                  decoration: InputDecoration(),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailWidget() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: <Widget>[
          Row(children: <Widget>[
            Text("Depth(cm): ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
            Container(
              width: 140,
              height: 35,
              child: TextField(
                onChanged: (text) {
                  depth = text;
                },
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            )
          ]),
          SizedBox(width: 10),
          Row(children: <Widget>[
            Text("Length(cm): ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
            Container(
              width: 140,
              height: 35,
              child: TextField(
                onChanged: (text) {
                  height = text;
                },
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            )
          ]),
          SizedBox(width: 10),
          Row(children: <Widget>[
            Text("Width(cm): ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0)),
            Container(
              width: 140,
              height: 35,
              child: TextField(
                onChanged: (text) {
                  width = text;
                },
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.amber,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ]),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt, size: 40.0),
              color: Colors.blue,
              onPressed: controller != null && controller.value.isInitialized
                  ? _onCapturePressed
                  : null,
            )
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(_getCameraLensIcon(lensDirection), size: 28.0),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  Future _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    if (resolutionValue == 4) {
      controller = CameraController(cameraDescription, ResolutionPreset.max);
    } else if (resolutionValue == 3) {
      controller =
          CameraController(cameraDescription, ResolutionPreset.ultraHigh);
    } else if (resolutionValue == 2) {
      controller = CameraController(cameraDescription, ResolutionPreset.high);
    } else if (resolutionValue == 1) {
      controller = CameraController(cameraDescription, ResolutionPreset.medium);
    } else {
      controller = CameraController(cameraDescription, ResolutionPreset.low);
    }

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  Future<String> _takePicture() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      return null;
    }

    // Do nothing if a capture is on progress
    if (controller.value.isTakingPicture) {
      return null;
    }

    final Directory appDirectory = await getExternalStorageDirectory();
    final String pictureDirectory = '${appDirectory.path}/ImageData';
    await Directory(pictureDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$pictureDirectory/${currentTime}.jpg';

    /*List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);*/

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    if (isSwitchedSensorData) {
      try {
        File file = new File('$pictureDirectory/${currentTime}_image_info.txt');
        String location = depth +
            ";" +
            height +
            ";" +
            width +
            ";" +
            currentLocation.latitude.toString() +
            ";" +
            currentLocation.longitude.toString();
            //"${placemark[0].thoroughfare} ${placemark[0].subThoroughfare},${placemark[0].subLocality},${placemark[0].locality},${placemark[0].subAdministrativeArea},${placemark[0].administrativeArea} ${placemark[0].postalCode},${placemark[0].country}";
        if(comment.isNotEmpty){
          location += ";" + comment;
        }
        await file.writeAsString(location + "\n", mode: FileMode.append);
        String converted = md5.convert(utf8.encode(location)).toString();
        await file.writeAsString(converted + "\n", mode: FileMode.append);
        String infoFinal = location + "\$" + converted;
        String encoded = base64.encode(utf8.encode(infoFinal));
        await file.writeAsString(encoded + "\n", mode: FileMode.append);
      } catch (e) {
        Fluttertoast.showToast(
            msg:
                'Please make sure that you have provided depth, length and width value for the image.And your location data are not null',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      }
    }

    return filePath;
  }

  void _onCapturePressed() async {
    if (depth == null || depth == "") {
      Fluttertoast.showToast(
          msg: 'Depth is empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else if (height == null || height == "") {
      Fluttertoast.showToast(
          msg: 'Length is empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else if (width == null || width == "") {
      Fluttertoast.showToast(
          msg: 'Width is empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      _takePicture().then((String filePath) {
        if (mounted) {
          setState(() {
            //imagePath = filePath;
            imagePath = null;
          });
          if (filePath != null) {
            Fluttertoast.showToast(
                msg: 'Image saved to $filePath',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white);
          }
        }
      });
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }
}

class CameraAppImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraExample(),
    );
  }
}
