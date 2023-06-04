class OptionModel {
  String? id;
  int? price;
  final String name;
  final int container;

  OptionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json["price"],
        container = json["container"];
}
