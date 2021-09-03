import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vgga_data_collection/sensor_data.dart';
import 'package:vgga_data_collection/gps_data.dart';
import 'package:vgga_data_collection/video_settings.dart';
import 'video_settings.dart';
import 'package:vgga_data_collection/image_taker.dart';
import 'package:vgga_data_collection/upload_file_1.dart';
import 'package:sensors/sensors.dart';

import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() => runApp(MyApp());

Map<String, double> _currentLocationProvider;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MyAppHome(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/settingsTakeVideo': (BuildContext context) => new VideoRecorderApp(),
        '/settingsSensorData': (BuildContext context) => new MySensorApp(),
        '/settingsGPS': (BuildContext context) => new MyAppGPS(),
        '/settingsVideo': (BuildContext context) => new MyAppVideoSettings(),
        '/settingsImage': (BuildContext context) => new CameraAppImage(),
        '/settingsUploadFiles': (BuildContext context) =>
            new UploadMultipleImageDemo(),
      },
    );
  }
}

class MyAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Collector'),
        ),
        body: Center(
          /*child: RaisedButton.icon(
            color: Colors.amber,
            icon: Icon(Icons.videocam), //`Icon` to display
            label: Text('Take Video', style: TextStyle(fontSize: 30)), //`Text` to display
            onPressed: () => Navigator.of(context).pushNamed('/settings')
          ),*/
          child: new SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/settingsTakeVideo'),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.videocam),
                        Text('  Take Video', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/settingsImage'),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.photo_camera),
                        Text('  Take Image', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/settingsVideo'),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.settings),
                        Text('  Settings', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/settingsSensorData'),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.grain),
                        Text('  Sensor Data', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/settingsGPS'),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.gps_fixed),
                        Text('   GPS   Data', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () => {
                    Navigator.of(context).pushNamed('/settingsUploadFiles'),
                    myFiles.clear()
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: 200.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.cloud_upload),
                        Text(' Upload Data', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoRecorderExample extends StatefulWidget {
  @override
  _VideoRecorderExampleState createState() {
    return _VideoRecorderExampleState();
  }
}

class _VideoRecorderExampleState extends State<VideoRecorderExample>
    with TickerProviderStateMixin {
  //TaskModel currentTask;
  //final TodoHelper _todoHelper = TodoHelper();
  var startTime;
  var endTime;
  CameraController controller;
  String videoPath;
  List<CameraDescription> cameras;
  int selectedCameraIdx;
  AnimationController animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  static const duration1 = const Duration(seconds: 1);
  int secondsPassed = 0;
  bool isActive = false;

  Timer timer1;
  int seconds = 0, minutes = 0;
  String comment = "";

  Timer _timer;
  int totalValue = 0;
  UserAccelerometerEvent useracc;
  AccelerometerEvent acc;
  GyroscopeEvent gyro;
  List<String> accelerometerValues = List<String>();
  List<String> userAccelerometerValues = List<String>();
  List<String> gyroscopeValues = List<String>();
  List<String> latitudeValues = List<String>();
  List<String> longitudeValues = List<String>();
  bool storingData = false;
  File file;
  Geolocator _geolocator;
  void handleTick() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //Accelerometer events
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acc = event;
      });
    }));

    //UserAccelerometer events
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        useracc = event;
      });
    }));

    //UserAccelerometer events
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        gyro = event;
      });
    }));
    if (isSwitched) {
      animationController = AnimationController(
          vsync: this,
          duration: Duration(minutes: minuteValue, seconds: secondValue));
    } else {}

    // Get the listonNewCameraSelected of available cameras.
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

    accelerometerValues.clear();
    userAccelerometerValues.clear();
    gyroscopeValues.clear();
    latitudeValues.clear();
    longitudeValues.clear();
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> sub in _streamSubscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Capture Video'),
      ),
      body: Column(
        children: <Widget>[
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
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _captureControlRowWidget(),
                isSwitched
                    ? _timerControlRowWidget()
                    : _timerControlRowWidgetIncreasing(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
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

  // Display 'Loading' text when the camera is still loading.
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
    } else if (storingData) {
      return const Text(
        'Storing data......',
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
            icon: Icon(
              _getCameraLensIcon(lensDirection),
              size: 35,
            ),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.videocam, size: 40.0),
              color: Colors.blue,
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      !controller.value.isRecordingVideo
                  ? _onRecordButtonPressed
                  : null,
            ),
            SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.stop, size: 40.0),
              color: Colors.red,
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      controller.value.isRecordingVideo
                  ? _onStopButtonPressed
                  : null,
            )
          ],
        ),
      ),
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

  Widget _timerControlRowWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          children: <Widget>[
            AnimatedBuilder(
                animation: animationController,
                builder: (_, Widget child) {
                  return Text(
                    timerString,
                    style: Theme.of(context).textTheme.display2,
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _timerControlRowWidgetIncreasing() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTextContainer(
                label: 'MIN', value: minutes.toString().padLeft(2, '0')),
            CustomTextContainer(
                label: 'SEC', value: seconds.toString().padLeft(2, '0')),
          ],
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
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
    if (controller.value.isRecordingVideo) {
      Fluttertoast.showToast(
          msg: 'Video recording ongoing',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      selectedCameraIdx =
          selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
      CameraDescription selectedCamera = cameras[selectedCameraIdx];

      _onCameraSwitched(selectedCamera);

      setState(() {
        selectedCameraIdx = selectedCameraIdx;
      });
    }
  }

  void _onRecordButtonPressed() {
    accelerometerValues.clear();
    userAccelerometerValues.clear();
    gyroscopeValues.clear();
    latitudeValues.clear();
    longitudeValues.clear();
    totalValue = 0;
    bool noError = true;
    startTime = new DateTime.now().toString();
    try {
      double a = currentLocation.latitude;
      double b = currentLocation.longitude;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Please make sure that your GPS data are not null',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
      noError = false;
    }
    if (noError) {
      _startVideoRecording().then((String filePath) {
        if (filePath != null) {
          Fluttertoast.showToast(
              msg: 'Recording video started',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white);
        }
        if (isSwitched) {
          int _start = (minuteValue * 60) + secondValue;
          const oneSec = const Duration(seconds: 1);
          _timer = new Timer.periodic(
            oneSec,
            (t) => setState(
              () {
                if (_start < 1) {
                  try {
                    _timer.cancel();
                  } on Exception catch (_) {}
                  if (controller.value.isRecordingVideo) {
                    _onStopButtonPressed();
                  }
                } else {
                  _start = _start - 1;
                  totalValue++;
                  setVideoInfoData();
                }
              },
            ),
          );
          if (animationController.isAnimating) {
            animationController.stop();
          } else {
            animationController.reverse(
                from: animationController.value == 0.0
                    ? 1.0
                    : animationController.value);
          }
        } else {
          isActive = true;

          timer1 = Timer.periodic(duration1, (t) {
            totalValue++;
            setVideoInfoData();
            setState(() {
              secondsPassed = secondsPassed + 1;
              seconds = secondsPassed % 60;
              minutes = secondsPassed ~/ 60;
            });
          });
        }
      });
    }
  }

  void setVideoInfoData() async {
    for (int i = 0; i < 10; i++) {
      accelerometerValues.add(acc.x.toString() +
          "," +
          acc.y.toString() +
          "," +
          acc.z.toString());
      userAccelerometerValues.add(useracc.x.toString() +
          "," +
          useracc.y.toString() +
          "," +
          useracc.z.toString());
      gyroscopeValues.add(gyro.x.toString() +
          "," +
          gyro.y.toString() +
          "," +
          gyro.z.toString());
      latitudeValues.add(currentLocation.latitude.toString());
      longitudeValues.add(currentLocation.longitude.toString());
    }
  }

  void _onStopButtonPressed() async {
    if (controller.value.isRecordingVideo && isSwitched && _timer.isActive) {
      Fluttertoast.showToast(
          msg: 'Video recording ongoing',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
    } else {
      _stopVideoRecording().then((_) {
        if (mounted) setState(() {});
        Fluttertoast.showToast(
            msg: 'Video recorded to $videoPath',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
      });
      setState(() {
        storingData = true;
      });
      secondsPassed = 0;
      seconds = 0;
      minutes = 0;
      if (isActive && timer1.isActive) {
        timer1.cancel();
      }
      isActive = false;
      /* List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      print('hasan' + placemark[0].thoroughfare);*/
      /*await file.writeAsString(
          "${placemark[0].thoroughfare} ${placemark[0].subThoroughfare},${placemark[0].subLocality},${placemark[0].locality},${placemark[0].subAdministrativeArea},${placemark[0].administrativeArea} ${placemark[0].postalCode},${placemark[0].country}" +
              "\n",
          mode: FileMode.append);*/
      //List<TaskModel> list = await _todoHelper.getAllTask();
      String info = "";
      for (int i = 0; i < (totalValue * 10); i++) {
        info = accelerometerValues.elementAt(i) +
            ";" +
            userAccelerometerValues.elementAt(i) +
            ";" +
            gyroscopeValues.elementAt(i) +
            ";" +
            latitudeValues.elementAt(i) +
            ";" +
            longitudeValues.elementAt(i);
        String infoFinal =
            info + "\$" + md5.convert(utf8.encode(info)).toString();
        String encoded = base64.encode(utf8.encode(infoFinal));
        await file.writeAsString(infoFinal + "\n", mode: FileMode.append);
        await file.writeAsString(encoded + "\n", mode: FileMode.append);
      }
      if(comment.isNotEmpty){
        await file.writeAsString(comment + "\n", mode: FileMode.append);
      }
      // await _todoHelper.delete();
      //  await _todoHelper.close();
      setState(() {
        storingData = false;
      });
    }
  }

  Future<String> _startVideoRecording() async {
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

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo) {
      return null;
    }
    endTime = new DateTime.now().toString();
    final Directory appDirectory = await getExternalStorageDirectory();
    final String videoDirectory = '${appDirectory.path}/VideoData';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String videoFileName = startTime + "->" + endTime;
    final String filePath = '$videoDirectory/${currentTime}.mp4';
    file = new File('$videoDirectory/${currentTime}_video_info.txt');

    try {
      await controller.startVideoRecording(filePath);
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      secondsPassed = 0;
      seconds = 0;
      minutes = 0;
      if (isActive && timer1.isActive) {
        timer1.cancel();
      }
      isActive = false;
      _showCameraException(e);
      Fluttertoast.showToast(
          msg: 'Please adjust camera resolution in the settings page',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';

    secondsPassed = 0;
    seconds = 0;
    minutes = 0;
    if (isActive && timer1.isActive) {
      timer1.cancel();
    }
    isActive = false;
    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }
}

class VideoRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: VideoRecorderExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CustomTextContainer extends StatelessWidget {
  CustomTextContainer({this.label, this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      padding: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10),
        color: Colors.black87,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '$value',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '$label',
            style: TextStyle(
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}

/*Future<void> video() async {
  runApp(VideoRecorderApp());
}*/
