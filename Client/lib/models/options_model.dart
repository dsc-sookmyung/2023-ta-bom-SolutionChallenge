import 'package:good_to_go/models/option_model.dart';

class OptionsModel {
  final String id;
  final String optionName;
  int? maxCheck;
  bool? isRequired;
  late List<OptionModel> optionList;
  int checkedCount = 0;

  OptionsModel.fromJson(Map<String, dynamic> json)
      : optionName = json['option_name'],
        id = json['id'] {
    if (json['max_check'] != null && json['required'] != null) {
      maxCheck = json['max_check'];
      isRequired = json['required'];
    }
    List<OptionModel> options = [];
    for (var option in json['content']) {
      options.add(OptionModel.fromJson(option));
    }
    optionList = options;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ops_id'] = id;
    final List<String> selectedOptionsIdList = [];
    for (var option in optionList) {
      if (option.isChecked) {
        selectedOptionsIdList.add(option.id);
      }
    }
    data['content_id'] = selectedOptionsIdList;
    return data;
  }
}
