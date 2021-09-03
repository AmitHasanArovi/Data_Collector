import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:wakelock/wakelock.dart';

class MyAppVideoSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Code Snippets',
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new VideoSettingsExample(),
    );
  }
}

bool isSwitched = false;
bool isSwitchedSensorData = true;
int minuteValue = 0;
int secondValue = 5;
String studentId = "";
int resolutionValue = 2;
Position currentLocation;
StreamSubscription _getPositionSubscription;
void setLocation() async {
  if (_getPositionSubscription == null) {
    try {
      currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } on Exception catch (e) {}
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high, distanceFilter: 0, timeInterval: 0);
    _getPositionSubscription = geolocator
        .getPositionStream(locationOptions)
        .listen((Position locationData) async {
      currentLocation = locationData;
    });
  }
  Wakelock.enable();
}

void cancelLocationStream() async {
  try {
    _getPositionSubscription?.cancel();
    _getPositionSubscription = null;
  } on Exception catch (e) {}
  Wakelock.disable();
}

class VideoSettingsExample extends StatefulWidget {
  @override
  _VideoSettingsExampleState createState() => _VideoSettingsExampleState();
}

class _VideoSettingsExampleState extends State<VideoSettingsExample> {
  @override
  void initState() {
    super.initState();
    if (isSwitchedSensorData) {
      setLocation();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Center(
          child: new SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Student ID: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0)),
                      Container(
                        width: 200,
                        child: TextField(
                          onChanged: (text) {
                            studentId = text;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "student id",
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
                SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Camera Resolution: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0)),
                      SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 60,
                        child: DropdownButton(
                          value: resolutionValue,
                          items: <DropdownMenuItem>[
                            new DropdownMenuItem(
                              child: new Text('low'),
                              value: 0,
                            ),
                            new DropdownMenuItem(
                              child: new Text('medium'),
                              value: 1,
                            ),
                            new DropdownMenuItem(
                              child: new Text('high'),
                              value: 2,
                            ),
                            new DropdownMenuItem(
                              child: new Text('ultraHigh'),
                              value: 3,
                            ),
                            new DropdownMenuItem(
                              child: new Text('max'),
                              value: 4,
                            ),
                          ],
                          onChanged: (value) => setState(() {
                            resolutionValue = value;
                          }),
                        ),
                      ),
                    ]),
                SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Sensor Data: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0)),
                      Transform.scale(
                        scale: 1.5,
                        child: new Switch(
                          value: isSwitchedSensorData,
                          onChanged: (value) {
                            setState(() {
                              isSwitchedSensorData = value;
                              if (isSwitchedSensorData)
                                setLocation();
                              else
                                cancelLocationStream();
                            });
                          },
                          activeTrackColor: Colors.green,
                          activeColor: Colors.blue,
                        ),
                      ),
                    ]),
                SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Set Time: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0)),
                      Transform.scale(
                        scale: 1.5,
                        child: new Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                          activeTrackColor: Colors.green,
                          activeColor: Colors.blue,
                        ),
                      ),
                    ]),
                SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (isSwitched)
                        Text("Minutes: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 19.0)),
                      if (isSwitched)
                        NumberPicker.integer(
                            initialValue: minuteValue,
                            minValue: 0,
                            maxValue: 59,
                            onChanged: (newValue) =>
                                setState(() => minuteValue = newValue)),
                    ]),
                SizedBox(height: 40),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (isSwitched)
                        Text("Seconds: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 19.0)),
                      if (isSwitched)
                        NumberPicker.integer(
                            initialValue: secondValue,
                            minValue: 0,
                            maxValue: 59,
                            onChanged: (newValue) =>
                                setState(() => secondValue = newValue)),
                    ]),
              ])),
        ));
  }
}
