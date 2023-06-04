import 'menus_model.dart';

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
  List<MenusModel> menusList = [];

  StoreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        category = json['category'],
        description = json['description'],
        imgUrl = json['img'],
        openingHours = json['opening_hours'],
        owner = json['owner_name'],
        spentTime = json['spent_time'],
        address = json['address'],
        reviewCount = json['review_count'],
        telephone = json['telephone'],
        starRating = json['star_rating'],
        name = json['name'],
        state = json['state'] {
    final List<MenusModel> menus = [];
    for (var menu in json["menu_list"]) {
      menus.add(MenusModel.fromJson(menu));
    }
    menusList = menus;
  }
}
