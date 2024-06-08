import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_result.g.dart';

@JsonSerializable()
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

  factory StoryData.fromJson(Map<String, dynamic> json) => _$StoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$StoryDataToJson(this);

  String formattedDate() {
    return DateFormat('dd-MM-yyyy').format(createdAt);
  }
}