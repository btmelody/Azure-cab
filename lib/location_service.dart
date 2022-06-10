import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:oiitaxi/direction_model.dart';
class LocationService{
  final String key = 'AIzaSyBCV9gVTs1JMbAJZJh5vDdGjpHpZwu2ORc';

  Future<String> getPlaceId (String input) async {
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&input=$input&inputtype=textquery&locationbias=circle%3A2000%4047.6918452%2C-122.2226413&key=AIzaSyBCV9gVTs1JMbAJZJh5vDdGjpHpZwu2ORc";
    print(url);
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['formatted_address'] as String;
    print(placeId);

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&input=$input&inputtype=textquery&locationbias=circle%3A2000%4047.6918452%2C-122.2226413&key=AIzaSyBCV9gVTs1JMbAJZJh5vDdGjpHpZwu2ORc";
    print(url);
    print("Working Up to here");
    var response = await http.get(Uri.parse(url));
    print("1");
    var json = convert.jsonDecode(response.body);
    print("2");
    var god = json['candidates'][0] as Map<String,dynamic>;
    print(god);
    return god;
  }

  Future<List<PointLatLng>> getPolylines(LatLng pickUp,LatLng drop) async{
    final String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${pickUp.latitude},${pickUp.longitude}&destination=${drop.latitude},${drop.longitude}&key=AIzaSyBCV9gVTs1JMbAJZJh5vDdGjpHpZwu2ORc";
    print(url);
    print("POLY Working Up to here");
    var response = await http.get(Uri.parse(url));
    print("POLY 1");
    var json = convert.jsonDecode(response.body);
    print("POLY 2");
    var godsgrace = json['routes'][0];
    print(godsgrace);

    final points = godsgrace['overview_polyline']['points'];
    final legs = godsgrace['legs'];
    print(legs);
    final polylines = PolylinePoints().decodePolyline(points);
    print("plylines");
    print(polylines);

    if (legs != null) {
      final DateTime time = DateTime.fromMillisecondsSinceEpoch(godsgrace['legs'][0]['duration']['value']);
      var duration = DateTime.now().difference(time);
    }
    return polylines;
  }

}