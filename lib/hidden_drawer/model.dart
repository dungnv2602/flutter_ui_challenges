import 'dart:convert';

import 'package:flutter/material.dart';

const restaurantMeals = [
  RestaurantMeal(
    imagePath: 'assets/images/paddock/eggs_in_skillet.jpg',
    icon: Icons.fastfood,
    iconColor: Colors.orange,
    title: 'il domacca',
    subtitle: '77 5TH AVENUE, NEW YORK',
    likes: 17,
  ),
  RestaurantMeal(
    imagePath: 'assets/images/paddock/steak_on_cooktop.jpg',
    icon: Icons.local_dining,
    iconColor: Colors.red,
    title: 'McGrady',
    subtitle: '78 5TH AVENUE, NEW YORK',
    likes: 18,
  ),
  RestaurantMeal(
    imagePath: 'assets/images/paddock/spoons_of_spices.jpg',
    icon: Icons.fastfood,
    iconColor: Colors.purpleAccent,
    title: 'Sugar & Spice',
    subtitle: '79 5TH AVENUE, NEW YORK',
    likes: 19,
  ),
];

@immutable
class RestaurantMeal {
  const RestaurantMeal({
    @required this.imagePath,
    @required this.icon,
    @required this.iconColor,
    @required this.title,
    @required this.subtitle,
    @required this.likes,
  });

  factory RestaurantMeal.fromJson(String source) =>
      RestaurantMeal.fromMap(json.decode(source) as Map<String, dynamic>);

  factory RestaurantMeal.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RestaurantMeal(
      imagePath: map['imagePath'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      iconColor: Color(map['iconColor'] as int),
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      likes: map['likes'] as int,
    );
  }

  final IconData icon;
  final Color iconColor;
  final String imagePath;
  final int likes;
  final String subtitle;
  final String title;

  @override
  int get hashCode {
    return imagePath.hashCode ^
        icon.hashCode ^
        iconColor.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        likes.hashCode;
  }

  @override
  bool operator ==(Object obj) {
    if (identical(this, obj)) return true;

    return obj is RestaurantMeal &&
        obj.imagePath == imagePath &&
        obj.icon == icon &&
        obj.iconColor == iconColor &&
        obj.title == title &&
        obj.subtitle == subtitle &&
        obj.likes == likes;
  }

  @override
  String toString() {
    return '_RestaurantMeal(imagePath: $imagePath, icon: $icon, iconColor: $iconColor, title: $title, subtitle: $subtitle, likes: $likes)';
  }

  RestaurantMeal copyWith({
    String imagePath,
    IconData icon,
    Color iconColor,
    String title,
    String subtitle,
    int likes,
  }) {
    return RestaurantMeal(
      imagePath: imagePath ?? this.imagePath,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imagePath': imagePath,
      'icon': icon?.codePoint,
      'iconColor': iconColor?.value,
      'title': title,
      'subtitle': subtitle,
      'likes': likes,
    };
  }

  String toJson() => json.encode(toMap());
}
