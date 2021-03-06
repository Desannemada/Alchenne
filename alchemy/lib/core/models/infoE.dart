import 'dart:convert';

EfeitoInfo efeitoInfoFromJson(String str) =>
    EfeitoInfo.fromJson(json.decode(str));

String efeitoInfoToJson(EfeitoInfo data) => json.encode(data.toJson());

class EfeitoInfo {
  String school;
  String type;
  double schoolsize;

  EfeitoInfo({
    this.school,
    this.type,
    this.schoolsize,
  });

  factory EfeitoInfo.fromJson(Map<String, dynamic> json) => EfeitoInfo(
        school: json["School"],
        type: json["Type"],
        schoolsize: json["Schoolsize"],
      );

  Map<String, dynamic> toJson() => {
        "School": school,
        "Type": type,
        "Schoolsize": schoolsize,
      };
}
