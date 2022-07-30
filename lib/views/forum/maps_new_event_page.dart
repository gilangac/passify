import 'package:passify/constant/color_constant.dart';
import 'package:passify/controllers/forum/detail_event_controller.dart';
import 'package:passify/controllers/forum/event_controller.dart';
import 'package:passify/widgets/general/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapsPageNewEvent extends StatelessWidget {
  MapsPageNewEvent({Key? key}) : super(key: key);
  var position = LatLng(-7.629653, 111.516387).obs;
  late GoogleMapController mapController;
  final String kGoogleApiKey = 'AIzaSyByPMj-ayWn1KfOYOkutZPIwEz1RkxWjIk';
  Position? initialPosition;
  LatLng? tapPosition;
  LatLng? selectedPosition;
  String? positionAddress;
  String? selectedCity;
  String? selectedProvince;

  @override
  Widget build(BuildContext context) {
    goToMyPosition();
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _fab(),
    );
  }

  PreferredSizeWidget _appBar() {
    return appBar(
      title: "Pilih Lokasi",
      actions: [
        GestureDetector(
          onTap: () {
            if (Get.arguments == "create") {
              EventController controller = Get.find();
              controller.latitude.value = position.value.latitude.toString();
              controller.longitude.value = position.value.longitude.toString();
              controller.addressFC.text = positionAddress.toString();
            } else {
              DetailEventController controller = Get.find();
              controller.latitude.value = position.value.latitude.toString();
              controller.longitude.value = position.value.longitude.toString();
              controller.addressFC.text = positionAddress.toString();
            }

            Get.back();
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 15, right: 10),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Colors.black54),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'Oke',
                style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () => goToMyPosition(),
      backgroundColor: Colors.white,
      child: Icon(Icons.my_location),
    );
  }

  Widget _body() {
    return Obx(() => Container(
          child: GoogleMap(
            onMapCreated: onMapCreated,
            zoomControlsEnabled: false,
            markers: <Marker>{
              Marker(
                  markerId: MarkerId('place_name'),
                  position: position.value,
                  // icon: BitmapDescriptor.,
                  infoWindow: InfoWindow(
                    title: 'title',
                    snippet: 'address',
                  )),
            },
            onTap: _mapTapped,
            initialCameraPosition:
                CameraPosition(target: position.value, zoom: 15),
            mapType: MapType.normal,
          ),
        ));
  }

  _mapTapped(LatLng location) {
    position.value = location;
    print(location);
    getLocationAddress(location);
// The result will be the location you've been selected
// something like this LatLng(12.12323,34.12312)
// you can do whatever you do with it
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> goToMyPosition() async {
    var _currentLocation = await Geolocator.getCurrentPosition();
    LatLng coord =
        LatLng(_currentLocation.latitude, _currentLocation.longitude);
    position.value =
        LatLng(_currentLocation.latitude, _currentLocation.longitude);

    goToPlace(coord);
    getLocationAddress(coord);
  }

  Future<void> goToPlace(LatLng target) async {
    final CameraPosition _position = CameraPosition(
      target: target,
      zoom: 15,
    );

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(_position),
    );
  }

  Future<String?> getLocationAddress(LatLng position) async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark = newPlace[0];

    String? street = placeMark.street;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;

    String? address = "$street, $locality, $administrativeArea, $postalCode";
    String? formatedAddress =
        address[0] == ',' ? address.replaceFirst(', ', '') : address;

    print(street);
    print(locality);
    print(administrativeArea);
    print(postalCode);
    positionAddress = formatedAddress;
    selectedCity = placeMark.locality;
    selectedProvince = placeMark.administrativeArea;
    tapPosition = position;
  }
}
