// ignore_for_file: public_member_api_docs, sort_constructors_first
class Location {
  String name;
  double latitude;
  double longtitude;
  Location({
    required this.name,
    required this.latitude,
    required this.longtitude,
  });
}

class FakeData {
  static List<Location> fakeLocation = [
    Location(name: 'semarang', latitude: -6.983647, longtitude: 110.387389),
    Location(name: "semarang1", latitude: -6.983489, longtitude: 110.384995)
  ];
}
