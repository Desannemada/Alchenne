// To parse this JSON data, do
//
//     final ingredientes = ingredientesFromJson(jsonString);

import 'dart:convert';

List<Ingredientes> ingredientesFromJson(String str) => List<Ingredientes>.from(
    json.decode(str).map((x) => Ingredientes.fromJson(x)));

String ingredientesToJson(List<Ingredientes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ingredientes {
  AryEffect primaryEffect;
  AryEffect quaternaryEffect;
  AryEffect secondaryEffect;
  AryEffect tertiaryEffect;
  String title;
  String url;
  String value;
  String weight;

  Ingredientes({
    this.primaryEffect,
    this.quaternaryEffect,
    this.secondaryEffect,
    this.tertiaryEffect,
    this.title,
    this.url,
    this.value,
    this.weight,
  });

  factory Ingredientes.fromJson(Map<String, dynamic> json) => Ingredientes(
        primaryEffect: AryEffect.fromJson(json["primaryEffect"]),
        quaternaryEffect: AryEffect.fromJson(json["quaternaryEffect"]),
        secondaryEffect: AryEffect.fromJson(json["secondaryEffect"]),
        tertiaryEffect: AryEffect.fromJson(json["tertiaryEffect"]),
        title: json["title"],
        url: json["url"],
        value: json["value"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "primaryEffect": primaryEffect.toJson(),
        "quaternaryEffect": quaternaryEffect.toJson(),
        "secondaryEffect": secondaryEffect.toJson(),
        "tertiaryEffect": tertiaryEffect.toJson(),
        "title": title,
        "url": url,
        "value": value,
        "weight": weight,
      };
}

class AryEffect {
  String title;
  String url;

  AryEffect({
    this.title,
    this.url,
  });

  factory AryEffect.fromJson(Map<String, dynamic> json) => AryEffect(
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
      };
}
