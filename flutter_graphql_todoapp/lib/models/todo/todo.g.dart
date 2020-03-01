// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
    id: json['_id'] as String,
    body: json['body'] as String,
    completed: json['completed'] as bool,
    createdOn: Todo.parseDateString(json['createdOn'] as String),
  );
}

Map<String, dynamic> _$TodoToJson(Todo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  writeNotNull('body', instance.body);
  writeNotNull('completed', instance.completed);
  writeNotNull('createdOn', instance.createdOn?.toIso8601String());
  return val;
}
