// To parse this JSON data, do
//
//     final url = urlFromJson(jsonString);

import 'dart:convert';

Url urlFromJson(String str) => Url.fromJson(json.decode(str));

String urlToJson(Url data) => json.encode(data.toJson());

class Url {
  String url;

  Url({
    this.url,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        url: json["URL"],
      );

  Map<String, dynamic> toJson() => {
        "URL": url,
      };
}
