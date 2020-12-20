import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GpsRunner extends StatefulWidget {
  @override
  _GpsRunnerState createState() => _GpsRunnerState();
}

class _GpsRunnerState extends State<GpsRunner> {
  double lat, lng, distance = 0;
  bool runStatus = true;
  int runTime = 0;
  List<LatLng> latlngs = List();
  LatLng latlng1, latLng2;
  bool first = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData data = await findLocationData();
    if (data != null) {
      setState(() {
        lat = data.latitude;
        lng = data.longitude;
        print('lat =$lat,lng =$lng');
        if (first) {
          latlng1 = LatLng(lat, lng);
          first = false;
        }
        latLng2 = LatLng(lat, lng);
        latlngs.add(LatLng(lat, lng));
      });
    }
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            buildMap(context),
            buildRunButton(),
            buildDistance(),
            buildShowTime(),
          ],
        ),
      ),
    );
  }

  Padding buildDistance() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Distance =$distance km',
          style: TextStyle(
            color: Colors.red[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Padding buildShowTime() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'เวลา = $runTime วินาที',
          style: TextStyle(
            color: Colors.green[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  OutlinedButton buildRunButton() {
    return OutlinedButton.icon(
      onPressed: () {
        setState(() {
          runStatus = !runStatus;
          processRun();
        });
      },
      icon: Icon(
        runStatus ? Icons.run_circle : Icons.stop,
        color: runStatus ? Colors.green : Colors.red,
      ),
      label: Text(runStatus ? 'เริ่มวิ่ง' : 'หยุดวิ่ง'),
    );
  }

  void processRun() {
    print('runStatus ==>> $runStatus');
    if (runStatus) {
      //process stop
    } else {
      //process start
      autoTime();
    }
  }

  Future<Null> autoTime() async {
    Duration duration = Duration(seconds: 5);
    await Timer(duration, () {
      if (!runStatus) {
        setState(() {
          runTime += 5;
          distance = distance + calculateDistance(latlng1.latitude, latlng1.longitude,
              latLng2.latitude, latLng2.longitude);
          latlng1 = latLng2;
              
        });
        print('runTime = $runTime');
        findLatLng();
        autoTime();
      }
    });
  }

  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  Set<Marker> setMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('YourHere'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: 'คุณอยู่ที่นี่')),
    ].toSet();
  }

  Container buildMap(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.7,
      child: lat == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 16,
              ),
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: setMarker(),
            ),
    );
  }
}
