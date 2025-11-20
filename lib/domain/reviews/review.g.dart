// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: (json['id'] as num).toInt(),
      planId: (json['planId'] as num).toInt(),
      planTitle: json['planTitle'] as String,
      placeName: json['placeName'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      authorId: (json['authorId'] as num).toInt(),
      authorName: json['authorName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Reply.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planId': instance.planId,
      'planTitle': instance.planTitle,
      'placeName': instance.placeName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'replies': instance.replies,
      'replyCount': instance.replyCount,
    };

_$ReplyImpl _$$ReplyImplFromJson(Map<String, dynamic> json) => _$ReplyImpl(
      id: (json['id'] as num).toInt(),
      reviewId: (json['reviewId'] as num?)?.toInt(),
      authorId: (json['authorId'] as num).toInt(),
      authorName: json['authorName'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReplyImplToJson(_$ReplyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewId': instance.reviewId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CreateReviewRequestImpl _$$CreateReviewRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReviewRequestImpl(
      planId: (json['planId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$CreateReviewRequestImplToJson(
        _$CreateReviewRequestImpl instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'title': instance.title,
      'content': instance.content,
    };

_$CreateReplyRequestImpl _$$CreateReplyRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReplyRequestImpl(
      content: json['content'] as String,
    );

Map<String, dynamic> _$$CreateReplyRequestImplToJson(
        _$CreateReplyRequestImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
    };
