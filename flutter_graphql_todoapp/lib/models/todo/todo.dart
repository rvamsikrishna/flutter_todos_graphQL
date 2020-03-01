import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(includeIfNull: false)
class Todo {
  @JsonKey(name: '_id')
  final String id;
  final String body;
  final bool completed;
  @JsonKey(fromJson: parseDateString)
  final DateTime createdOn;

  Todo({
    this.id,
    this.body,
    this.completed = false,
    this.createdOn,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  static DateTime parseDateString(String date) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(date));
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Todo &&
        o.id == id &&
        o.body == body &&
        o.completed == completed &&
        o.createdOn == createdOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        body.hashCode ^
        completed.hashCode ^
        createdOn.hashCode;
  }

  Todo copyWith({
    String body,
    bool completed,
  }) {
    return Todo(
      id: id,
      body: body ?? this.body,
      completed: completed ?? this.completed,
      createdOn: createdOn,
    );
  }
}
