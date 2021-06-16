import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;
  static String pin;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      print(position.longitude);

      latitude = position.latitude;
      longitude = position.longitude;

      final coordinates = new Coordinates(latitude, longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      pin = address.first.postalCode.toString();
    } catch (e) {}
  }
}
