// To parse this JSON data, do
//
//     final feedbacks = feedbacksFromJson(jsonString);

import 'dart:convert';

Reviews reviewsFromJson(String str) => Reviews.fromJson(jsonDecode(str));

String reviewsToJson(Reviews data) => json.encode(data.toJson());

class Reviews {
  Reviews({
    this.id,
    this.name,
    this.review,
  });

  String id;
  String name;
  String review;

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    id: json["id"],
    name: json["name"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "review": review,
  };
}
