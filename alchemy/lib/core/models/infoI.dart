// To parse this JSON data, do
//
//     final ingredienteInfo = ingredienteInfoFromJson(jsonString);

import 'dart:convert';

IngredienteInfo ingredienteInfoFromJson(String str) =>
    IngredienteInfo.fromJson(json.decode(str));

String ingredienteInfoToJson(IngredienteInfo data) =>
    json.encode(data.toJson());

class IngredienteInfo {
  String background;
  List<String> locations;
  String titleLocation;

  IngredienteInfo({
    this.background,
    this.locations,
    this.titleLocation,
  });

  factory IngredienteInfo.fromJson(Map<String, dynamic> json) =>
      IngredienteInfo(
        background: json["background"],
        locations: List<String>.from(json["locations"].map((x) => x)),
        titleLocation: json["titleLocation"],
      );

  Map<String, dynamic> toJson() => {
        "background": background,
        "locations": List<dynamic>.from(locations.map((x) => x)),
        "titleLocation": titleLocation,
      };
}
