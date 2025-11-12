import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
class Place with _$Place {
  const factory Place({
    required int id,
    required String name,
    required String address,
    required double lat,
    required double lng,
    String? description,
    String? imageUrl,
    @Default([]) List<String> tags,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
