class OptionModel {
  final String id, name;
  final int container, price;
  bool isChecked = false;

  OptionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json["price"],
        container = json["container"];
}
