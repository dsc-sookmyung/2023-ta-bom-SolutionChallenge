import 'option_model.dart';

class OptionsModel {
  final String optionName;
  late List<OptionModel> optionList;

  OptionsModel.fromJson(Map<String, dynamic> json)
      : optionName = json['option_name'] {
    List<OptionModel> options = [];
    for (var option in json['contents']) {
      options.add(OptionModel.fromJson(option));
    }
    optionList = options;
  }
}
