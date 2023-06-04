import 'options_model.dart';

class MenuModel {
  final int container;
  final String name;
  final int count;
  late List<OptionsModel> optionsList;

  MenuModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        count = json['amount'] ?? 0,
        container = json['container'] {
    final List<OptionsModel> options = [];

    if (json['menu_option'] == null) {
      optionsList = options;
      return;
    }

    for (var i = 0; i < json["menu_option"].length; i++) {
      options.add(OptionsModel.fromJson(json["menu_option"][i]));
    }
    optionsList = options;
  }
}
