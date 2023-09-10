import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'data_model.dart';
import 'request_order.dart';

class MyGoogle1 extends StatelessWidget {
  final String lat1a, lng1a;

  MyGoogle1({super.key, required this.lat1a, required this.lng1a});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Google Map")),
        ),
        body: MyGoogle2(lat1b: lat1a, lng1b: lng1a),
      ),
    );
  }
}

//GLOBAL PARAMETER
//CONVERT DATA STRING TO DOUBLE
// double _lat1 = double.parse('lat1b');
// double _lng1 = double.parse('lng1b');
// LatLng _showLocation = LatLng(_lat1, _lng1);

class MyGoogle2 extends StatefulWidget {
  final String lat1b, lng1b;

  MyGoogle2({super.key, required this.lat1b, required this.lng1b});

  @override
  State<MyGoogle2> createState() => _MyGoogle2State();
}

class _MyGoogle2State extends State<MyGoogle2> {
  String space1 = ", ";
  String phone1 = "Phone: ";
  String distance1 = ", Distance: ";
  String latLng1 = ", LatLng: ";
  String order1 = ", (ORDER)";
  String km1 = " Km";

  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  List<Marker> markerAll = List.from([]);

  void addCustomeIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/marker_bola80.png",
    ).then((icon) {
      setState(() {
        markerIcon1 = icon;
      });
    });
  }

  @override
  void initState() {
    addCustomeIcon();
    _loadString();
    // TODO: implement initState
    super.initState();
  }

  Future _loadString() async {
    var url = await Uri.parse(
        //"http://192.168.100.100:8087/googlemaps/querydata.php?auth=kjgdkhdfldfguttedfgr");
        "http://192.168.100.100:8087/googlemaps/querydata.php?auth=kjgdkhdfldfguttedfgr" +
            "&lat_c=" +
            widget.lat1b +
            "&lng_c=" +
            widget.lng1b);

    var response = await http.get(Uri.parse(url.toString()));
    final dynamic responsebody = jsonDecode(response.body);
    return responsebody;
  }

  @override
  Widget build(BuildContext context) {
    double _lat1 = double.parse('${widget.lat1b.toString()}');
    double _lng1 = double.parse('${widget.lng1b.toString()}');
    LatLng showLocation1 = LatLng(_lat1, _lng1);
    final datetime1 = DateTime.now();

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: _loadString(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  ListDataModel model1 = ListDataModel.fromJson(snapshot.data);
                  model1.data!.forEach((i) {
                    //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

                    markerAll.add(
                      Marker(
                          markerId: MarkerId("1"),
                          position: showLocation1,
                          icon: markerIcon1,
                          anchor: Offset(0.5, 0.5),
                          infoWindow: InfoWindow(
                              title: "User1", snippet: "Use the Apps")),
                    );

                    if (i.status.toString() == 'OPEN') {
                      markerAll.add(Marker(
                        markerId: MarkerId(i.locId.toString()),
                        position: LatLng(double.parse(i.locX.toString()),
                            double.parse(i.locY.toString())),
                        infoWindow: InfoWindow(
                          title: i.laundryName.toString() +
                              space1 +
                              i.address.toString() +
                              space1 +
                              i.status.toString(),
                          snippet: phone1 +
                              i.phone.toString() +
                              distance1 +
                              (i.distance!.toString()).substring(0, 5) +
                              km1,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyOrder(
                                      lat1c: i.locX.toString(),
                                      lng1c: i.locY.toString(),
                                      laundryname1: i.laundryName.toString(),
                                      datetime1: datetime1.toString(),
                                    )));
                          },
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                        onTap: () {},
                      ));
                    }

                    //...........................................................
                    if (i.status.toString() == 'CLOSE') {
                      markerAll.add(Marker(
                        markerId: MarkerId(i.locId.toString()),
                        position: LatLng(double.parse(i.locX.toString()),
                            double.parse(i.locY.toString())),
                        infoWindow: InfoWindow(
                          title: i.laundryName.toString() +
                              space1 +
                              i.status.toString(),
                          snippet:
                              i.locX.toString() + space1 + i.locY.toString(),
                          onTap: () {},
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueYellow),
                        anchor: Offset(0.5, 0.5),
                        onTap: () {},
                      ));
                    }
                    //...........................................................

                    //...........................................................

                    //.........................................................
                    // markerAll.add(Marker(
                    //     markerId: MarkerId(i.locId.toString()),
                    //     position: LatLng(double.parse(i.locX.toString()),
                    //         double.parse(i.locY.toString())),
                    //     icon: BitmapDescriptor.defaultMarkerWithHue(
                    //         BitmapDescriptor.hueViolet)));

                    //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                  });

                  Set<Circle> circles1 = Set.from([
                    Circle(
                      circleId: CircleId("1"),
                      center: showLocation1,
                      radius: 5000,
                      strokeColor: Colors.blue,
                      fillColor: Colors.black26,
                    )
                  ]);

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: showLocation1,
                      zoom: 12,
                    ),
                    markers: Set.from(markerAll),
                    circles: circles1,
                  );
                }
              }),
//..........................

          Positioned(
            height: 60,
            width: 240,
            bottom: 60,
            left: 70,
            child: Card(
              color: Colors.yellow,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lat_User: ${widget.lat1b}'),
                    Text('Long_User: ${widget.lng1b}'),
                  ],
                ),
              ),
            ),
          ),

          //================================================================

          const Positioned(
            height: 60,
            width: 240,
            bottom: 2,
            left: 70,
            child: Card(
              color: Colors.teal,
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BLUE Color Marker: OPEN',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'YELLOW Color Marker: CLOSE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // ),
          ),

          //================================================================
        ],
      ),
    );
  }
}
