import 'dart:async';

import 'package:location/location.dart';
import 'package:inphomeet/models/user_location.dart';

class LocationService {
  UserLocation _currentLocation;

  var location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();
  LocationService() {
    location.requestPermission().then((granted) {
      if (granted != null) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
    });
  }
  Stream<UserLocation> get locationStream => _locationController.stream;
  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation;
  }
}
