// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TermImpl _$$TermImplFromJson(Map<String, dynamic> json) => _$TermImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      isRequired: json['isRequired'] as bool,
    );

Map<String, dynamic> _$$TermImplToJson(_$TermImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'isRequired': instance.isRequired,
    };
