// To parse this JSON data, do
//
//     final ingredienteInfo = ingredienteInfoFromJson(jsonString);

import 'dart:convert';

IngredienteInfo ingredienteInfoFromJson(String str) => IngredienteInfo.fromJson(json.decode(str));

String ingredienteInfoToJson(IngredienteInfo data) => json.encode(data.toJson());

class IngredienteInfo {
    String background;
    InnerLocations innerLocations;
    List<String> locations;
    String titleLocation;

    IngredienteInfo({
        this.background,
        this.innerLocations,
        this.locations,
        this.titleLocation,
    });

    factory IngredienteInfo.fromJson(Map<String, dynamic> json) => IngredienteInfo(
        background: json["background"],
        innerLocations: InnerLocations.fromJson(json["innerLocations"]),
        locations: List<String>.from(json["locations"].map((x) => x)),
        titleLocation: json["titleLocation"],
    );

    Map<String, dynamic> toJson() => {
        "background": background,
        "innerLocations": innerLocations.toJson(),
        "locations": List<dynamic>.from(locations.map((x) => x)),
        "titleLocation": titleLocation,
    };
}

class InnerLocations {
    List<int> indexes;
    List<String> inners;

    InnerLocations({
        this.indexes,
        this.inners,
    });

    factory InnerLocations.fromJson(Map<String, dynamic> json) => InnerLocations(
        indexes: List<int>.from(json["indexes"].map((x) => x)),
        inners: List<String>.from(json["inners"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "indexes": List<dynamic>.from(indexes.map((x) => x)),
        "inners": List<dynamic>.from(inners.map((x) => x)),
    };
}