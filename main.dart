import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'pages/query_latlng.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:
              const Center(child: Text("Laundry Full Service\nOn Google Map")),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //DECLARATION
  Location? _location;
  //CameraPosition? _cameraPosition;
  final Completer<GoogleMapController> _googleMapController = Completer();
  LocationData? _currentLocation;
  int n = 1;
  //ORIGINATING LOCATION / BEFORE MOVE
  double lat1 = 0.0;
  double lng1 = 0.0;

//no.1
  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: latLng,
      zoom: 18,
    )));
  }

//no.2
  _initLocation() {
    _location?.getLocation().then((location) => _currentLocation = location);
    setState(() {
      _location?.onLocationChanged.listen((newLocation) {
        _currentLocation = newLocation;

        moveToPosition(LatLng(
            _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
      });
    });
  }

//no.3
  @override
  void initState() {
    _location = Location();
    //CameraPosition //Already
    _initLocation();

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _initLocation();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getMap(),
    );
  }

  Widget _getMap() {
    return Stack(children: [
      //Layer-1
      GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(0.0, 0.0), zoom: 3),
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          }),
      // ),

      //Layer-2
      Positioned.fill(
          child: Align(
        alignment: Alignment.center,
        child: _getMarker(),
      )),

      //Layer-3
      //================================================================

      Positioned(
        height: 60,
        width: 260,
        bottom: 60,
        left: 70,
        child: Card(
          color: Colors.lightGreen,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Current Lat: ${(_currentLocation?.latitude).toString()}'),
                Text(
                    'Current Lng: ${(_currentLocation?.longitude).toString()}'),
              ],
            ),
          ),
        ),
      ),

      //================================================================

      //Layer-4
      //================================================================

      Positioned(
          bottom: 2,
          left: 70.0,
          height: 60,
          width: 260,
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyGoogle1(
                          lat1a: (_currentLocation?.latitude).toString(),
                          lng1a: (_currentLocation?.longitude).toString(),
                        )));
              },
              child: Text('CHECK LAUNDRY SERVICE\n(NEAR ME)'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white),
            ),
          )),

      //================================================================
    ]);
  }

//.......................................
  Widget _getMarker() {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.deepOrange,
                offset: Offset(1, 1),
                spreadRadius: 6,
                blurRadius: 1)
          ]),
      child: ClipOval(
        child: Image.asset("assets/profile.jpg"),
      ),
    );
  }

//.......................................
}
