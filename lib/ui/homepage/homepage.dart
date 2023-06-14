import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constant/app_colors.dart';
import '../../core/constant/constants.dart';

@RoutePage()
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _getNearbyRestaurants();
  }

  void _getNearbyRestaurants() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied, handle appropriately
        print("deniiiiiiiiiiiiiiiiiiiiid");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission denied forever, handle appropriately
      print("deniiiiiiiiiiiiiiiiiiiiid forever");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final String lat = position.latitude.toString();
    final String lon = position.longitude.toString();
    //const double lat = 37.7749;
    //const double lon = -122.4194;
    final String url =
        'https://api.tomtom.com/search/2/search/restaurant.json?key=XhXommPeKRt9VsvJFGkbiijtaeqoycNW&lat=$lat&lon=$lon&radius=-50000';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _restaurants = json.decode(response.body)['results'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: Scaffold(
        backgroundColor: HexColor.fromHex(Constants.app_color_primary),
        appBar: AppBar(
          backgroundColor: HexColor.fromHex(Constants.app_color_primary),
          title: Text("أهلا بك!"),
          titleTextStyle: GoogleFonts.cairo(
              fontStyle: FontStyle.normal,
              fontSize: 20,
              color: HexColor.fromHex(Constants.app_color_on_primary),
              fontWeight: FontWeight.bold),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: _restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = _restaurants[index];
              final address = restaurant['address']['freeformAddress'];
              final distanceInMeters = restaurant['dist'];
              final distanceInKilometers =
                  (distanceInMeters / 1000).toStringAsFixed(2);
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/50'),
                    ),
                    title: Text(
                      restaurant['poi']['name'],
                      style: GoogleFonts.cairo(
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: HexColor.fromHex(Constants.app_color_primary),
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '$address\t\t\t,$distanceInKilometers كم',
                      style: GoogleFonts.cairo(
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          color:
                              HexColor.fromHex(Constants.app_color_secondary),
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: InkWell(
                      child: Text(
                        "اذهب للخريطة",
                        style: GoogleFonts.cairo(
                            fontStyle: FontStyle.normal,
                            fontSize: 10,
                            color:
                                HexColor.fromHex(Constants.app_color_primary),
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        final lat = restaurant['position']['lat'];
                        final lon = restaurant['position']['lon'];
                        final url =
                            'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
