class AppVariables {
  static final List<String> emojis = [
    '🙂',
    '😊',
    '😁',
    '🥰',
    '🤤',
    '😲',
    '😟',
    '🤔',
    '😅',
    '😂',
    '🥲',
    '😭',
  ];

  static final Map<String, String> orderStates = {
    "checking": "대기 중",
    "cooking": "요리 중",
    "cooked": "요리 완료",
    "packed": "포장 완료",
  };
}

enum OrderType {
  checking,
  cooking,
  cooked,
  packed,
}
