// To parse this JSON data, do
//
//     final efeitoInfo = efeitoInfoFromJson(jsonString);

import 'dart:convert';

EfeitoInfo efeitoInfoFromJson(String str) =>
    EfeitoInfo.fromJson(json.decode(str));

String efeitoInfoToJson(EfeitoInfo data) => json.encode(data.toJson());

class EfeitoInfo {
  String school;
  String type;

  EfeitoInfo({
    this.school,
    this.type,
  });

  factory EfeitoInfo.fromJson(Map<String, dynamic> json) => EfeitoInfo(
        school: json["School"],
        type: json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "School": school,
        "Type": type,
      };
}
