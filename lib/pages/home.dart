import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-33.876115, 18.5008116),
    zoom: 12,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  List? vehicleCoordinates;
  List? coverageCoordinates;
  List<Marker> taxis = [];
  List<Circle> coverage = [];
  List<double> ranges = [];
  double? approxDistance;

  Future<String> loadCoordinates() async {
    //load data from json files
    var coordinates =
        await rootBundle.loadString('lib/assets/vehicleCoordinates.json');
    var coverageData = await rootBundle.loadString('lib/assets/coverage.json');

    setState(() {
      vehicleCoordinates = json.decode(coordinates);
      coverageCoordinates = json.decode(coverageData);
    });
    getTaxis();
    getCoverage();

    return 'loaded';
  }

  Future<Uint8List?> _marker(String path, int width) async {
    //convert png to a marker
    ByteData _imgMarker = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
        _imgMarker.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  void getTaxis() async {
    int id = 0;
    Uint8List? _taxiMarker = await _marker(
        'lib/assets/ic_new_white_taxi.png', 60); //create taxi marker

    vehicleCoordinates?.forEach((taxi) {
      //add marker to a list of markers
      id = id + 1;
      taxis.add(Marker(
        markerId: MarkerId(id.toString()),
        rotation: double.parse(taxi['heading'].toString()),
        infoWindow: InfoWindow(title: taxi['heading'].toString()),
        position: LatLng(double.parse(taxi['latitude'].toString()),
            double.parse(taxi['longitude'].toString())),
        icon: BitmapDescriptor.fromBytes(_taxiMarker!),
      ));
    });
  }

  void getCoverage() {
    int id = 0;
    coverageCoordinates?.forEach((tower) {
      id = id + 1;
      ranges.add(double.parse(tower['range'].toString()));

      coverage.add(Circle(
        //add circles 0n the map to show coverage of the three towers
        circleId: CircleId(id.toString()),
        radius: double.parse(tower['range'].toString()),
        center: LatLng(double.parse(tower['latitude'].toString()),
            double.parse(tower['longitude'].toString())),
        fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        strokeWidth: 2,
        strokeColor: Theme.of(context).colorScheme.primary,
      ));

      taxis.add(Marker(
        //add markers no the map to show location of the three towers
        markerId: MarkerId(tower['latitude'].toString()),
        position: LatLng(double.parse(tower['latitude'].toString()),
            double.parse(tower['longitude'].toString())),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
      ));
    });
    calculatedistance();
  }

  void calculatedistance() {
    setState(() {
      //calculate approximate distance
      approxDistance =
          ranges.reduce((curr, next) => curr < next ? curr : next) / 1000;
    });
  }

  @override
  void initState() {
    loadCoordinates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
        ),
        body: Stack(children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _cameraPosition,
            onMapCreated: _onMapCreated,
            markers: taxis.map((e) => e).toSet(),
            circles: coverage.map((e) => e).toSet(),
          ),
          Container(
            height: 50,
            width: 200,
            margin: const EdgeInsets.only(left: 10, top: 15),
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Text('Approximatly $approxDistance km away'),
            ),
          )
        ]));
  }
}
