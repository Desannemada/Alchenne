import 'dart:convert';

List<Efeitos> efeitosFromJson(String str) =>
    List<Efeitos>.from(json.decode(str).map((x) => Efeitos.fromJson(x)));

String efeitosToJson(List<Efeitos> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Efeitos {
  String description;
  String icon;
  List<String> ingredients;
  String title;
  String url;

  Efeitos({
    this.description,
    this.icon,
    this.ingredients,
    this.title,
    this.url,
  });

  factory Efeitos.fromJson(Map<String, dynamic> json) => Efeitos(
        description: json["description"],
        icon: json["icon"],
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "icon": icon,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "title": title,
        "url": url,
      };
}
