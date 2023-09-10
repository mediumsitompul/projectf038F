import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyOrder extends StatelessWidget {
  String lat1c, lng1c, laundryname1, datetime1;

  MyOrder(
      {super.key,
      required this.lat1c,
      required this.lng1c,
      required this.laundryname1,
      required this.datetime1});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text("My Request Order")),
          ),
          body: MyRequestOrder(
              lat1d: lat1c,
              lng1d: lng1c,
              laundryname2: laundryname1,
              datetime2: datetime1)),
    );
  }
}

class MyRequestOrder extends StatefulWidget {
  String lat1d, lng1d, laundryname2, datetime2;

  MyRequestOrder(
      {super.key,
      required this.lat1d,
      required this.lng1d,
      required this.laundryname2,
      required this.datetime2});

  @override
  State<MyRequestOrder> createState() => _MyRequestOrderState();
}

class _MyRequestOrderState extends State<MyRequestOrder> {
  Future _insertData() async {
    final url = Uri.parse(
        "http://192.168.100.100:8087/googlemaps/insert_data_laundry.php");
    var response = await http.post(url, body: {
      "lat": "${widget.lat1d.toString()}",
      "lng": "${widget.lng1d.toString()}",
    });
    var result1 = jsonDecode(response.body);
    print(result1);
  }

  @override
  void initState() {
    _insertData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Latitude Customer: ${widget.lat1d}')),
          Center(child: Text('Longitude Customer: ${widget.lng1d}')),
          Center(child: Text('Request Order to: ${widget.laundryname2}')),
          Center(child: Text('')),
          Center(child: Text('Request Time: ${widget.datetime2}')),
        ],
      ),
    );
  }
}
