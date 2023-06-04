import 'package:good_to_go/models/menus_model.dart';

import 'geo_point_model.dart';

class StoreModel {
  final num starRating;
  final int category, reviewCount;
  final String id,
      name,
      owner,
      description,
      telephone,
      address,
      imgUrl,
      spentTime;
  final String state;
  final List<dynamic> openingHours;
  final GeoPointModel geoPoint;
  List<MenusModel> menuList = [];

  StoreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'],
        description = json['description'],
        imgUrl = json['img'],
        openingHours = json['opening_hours'],
        owner = json['owner'],
        spentTime = json['spent_time'],
        address = json['address'],
        reviewCount = json['review_count'],
        telephone = json['telephone'],
        starRating = json['star_rating'],
        name = json['name'],
        state = json['state'],
        geoPoint = GeoPointModel(
            latitude: json["geo_point"]["_latitude"],
            longitude: json["geo_point"]["_longitude"]);

  StoreModel.fromJsonWithMenu(Map<String, dynamic> json, List<MenusModel> menus)
      : id = json['id'],
        category = json['category'],
        description = json['description'],
        imgUrl = json['img'],
        openingHours = json['opening_hours'],
        owner = json['owner'],
        spentTime = json['spent_time'],
        address = json['address'],
        reviewCount = json['review_count'],
        telephone = json['telephone'],
        starRating = json['star_rating'],
        name = json['name'],
        state = json['state'],
        menuList = menus,
        geoPoint = GeoPointModel(
            latitude: json["geo_point"]["_latitude"],
            longitude: json["geo_point"]["_longitude"]);
}
