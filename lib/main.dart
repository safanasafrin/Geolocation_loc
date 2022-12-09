import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(MaterialApp(home:MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() =>_MyAppState();
}



 class _MyAppState extends State<MyApp>{
  String _location ="location";
  String? currentAddress;
  Timer? timer;
  @override
   void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => getAddress());
  }
  void getAddress(){
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      setState(() {
        _location=location.coords.latitude.toString()+ "|" +location.coords.longitude.toString();
      });
      Fluttertoast.showToast(
          msg: '[location] -$location',
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0
      );
      placemarkFromCoordinates(
          location.coords.latitude, location.coords.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];

        currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        print(currentAddress);
      });
         // print('[location] - $location');
    });


    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      setState(() {
        _location=location.coords.latitude.toString()+ "|" +location.coords.longitude.toString();
      });
      Fluttertoast.showToast(
          msg: '[motionchange] -$location',
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0
      );
      placemarkFromCoordinates(
          location.coords.latitude, location.coords.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];

        currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
         //print(currentAddress);
      });
        //print('[motionchange] - $location');
    });


    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: true,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) {
      if (!state.enabled) {

        bg.BackgroundGeolocation.start();
      }
    });
        //print("Address:"+currentAddress!);
  }

  @override
   Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center
            ,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_location,style: TextStyle(fontSize: 20.0,),),
                  Text('ADDRESS: ${currentAddress ?? ""}'),

                ],
          ),
        ),
      ),
    );
  }
 }



