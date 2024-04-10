import 'package:intl/intl.dart';

class StoryData {
  static const key = 'listStory';

  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final dynamic lat;
  final dynamic lon;

  StoryData({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory StoryData.fromJson(Map<String, dynamic> json) => StoryData(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    photoUrl: json["photoUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    lat: json["lat"]?.toDouble(),
    lon: json["lon"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "photoUrl": photoUrl,
    "createdAt": createdAt.toIso8601String(),
    "lat": lat,
    "lon": lon,
  };

  String formattedDate() {
    return DateFormat('dd-MM-yyyy').format(createdAt);
  }
}