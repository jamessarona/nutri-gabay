import 'dart:convert';

AssessmentType assessmentTypeFromJson(String str) =>
    AssessmentType.fromJson(json.decode(str));

String assessmentTypeToJson(AssessmentType data) => json.encode(data.toJson());

class AssessmentType {
  final String id;
  final String description;

  AssessmentType({
    required this.id,
    required this.description,
  });

  factory AssessmentType.fromJson(Map<String, dynamic> json) => AssessmentType(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
      };
}
