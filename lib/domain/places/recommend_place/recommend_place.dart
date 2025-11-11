import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oath_client/domain/places/place.dart';
import 'package:oath_client/domain/plans/participant.dart';

part 'recommend_place.freezed.dart';
part 'recommend_place.g.dart';

@freezed
class RecommendPlace with _$RecommendPlace {
  const factory RecommendPlace({
    required List<RecommendPlaceState> centerAvgPlace,
    required List<RecommendPlaceState> equalAvgPlace,
  }) = _RecommendPlace;

  factory RecommendPlace.fromJson(Map<String, dynamic> json) =>
      _$RecommendPlaceFromJson(json);
}

@Freezed(toJson: true)
@freezed
class RecommendPlaceState with _$RecommendPlaceState {
  const factory RecommendPlaceState({
    required Participant participant,
    required Place destination,
    required int distance,
    required String duration,
  }) = _RecommendPlaceState;

  factory RecommendPlaceState.fromJson(Map<String, dynamic> json) =>
      _$RecommendPlaceStateFromJson(json);
}
