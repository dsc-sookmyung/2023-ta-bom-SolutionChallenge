class Variables {
  // number 이상 -> 타이틀 얻음
  static final List<Map<String, dynamic>> userLevelStates = [
    {
      "name": "이제시작",
      "count": 0,
    },
    {
      "name": "용기내는",
      "count": 10,
    },
    {
      "name": "꽤용기낸",
      "count": 30,
    },
    {
      "name": "용기충만",
      "count": 80,
    },
    {
      "name": "용기스승",
      "count": 100,
    },
  ];

  static final Map<String, String> orderStates = {
    "checking": "주문 접수 중",
    "accepted": "요리 중",
    "cooked": "요리 완료",
    "packed": "포장 완료",
  };

  static final Map<String, String> storeStates = {
    "open": "영업 중",
    "closed": "마감",
    "disabled": "철수",
  };

  static final List<Map<String, dynamic>> prepareContainerTexts = [
    {
      "id": 0,
      "name": "",
      "explain": "",
      "imgPath": "",
    },
    {
      "id": 1,
      "name": "작은 용기",
      "explain":
          "냉장고에 있는 멸치볶음, 김치가 담겨 있는 반찬통을 생각해보세요. 기본적으로 가장 많이 사용하는 400ml~900ml 용량의 반찬통입니다. 간단한 간식, 공기밥, 반찬 등을 담을 때 활용하세요.",
      "imgPath": "assets/icons/small_container.svg",
    },
    {
      "id": 2,
      "name": "중간 용기",
      "explain":
          "가장 활용하기 좋은 크기의 용기입니다. 1L ~ 2L 용량의 밀폐 용기입니다. 볶음밥처럼 국물이 없으면 1L이상이면 적당하고, 국물있는 1인분 요리는 1.5L이상이 적당해요! 치킨은 2L 이상을 추천드립니다.",
      "imgPath": "assets/icons/medium_container.svg",
    },
    {
      "id": 3,
      "name": "큰 용기",
      "explain":
          "오늘은 다같이 음식 파티하는 날~! 3L 이상의 밀폐 용기입니다. 냄비나 김치통도 좋아요. 2~3인분의 국물 요리, 마라탕, 떡볶이, 여러 종류의 빵들을 담을 때 활용하세요.",
      "imgPath": "assets/icons/large_container.svg",
    },
    {
      "id": 4,
      "name": "텀블러",
      "explain":
          "메뉴 정보에 적혀있는 음료의 용량을 확인하면 실패 확률 Zero! 스타벅스의 Tall 사이즈의 용량은 355ml이라는 점을 기억하면 좋아요.",
      "imgPath": "assets/icons/tumbler.svg",
    },
    {
      "id": 5,
      "name": "소스통",
      "explain": "소스통도 잊지 말고 챙겨가요! 300ml~400ml면 적당해요.",
      "imgPath": "assets/icons/sauce_container.svg",
    },
    {
      "id": 6,
      "name": "후라이팬",
      "explain": "16인치의 후라이팬이라면 왠만한 사이즈의 피자는 담길 거에요.",
      "imgPath": "assets/icons/pen.svg",
    },
  ];

  static final List<Map<String, dynamic>> onboarindgTexts = [
    {
      "title": "지구를 위해, Good To Go!",
      "content":
          "배달 음식에 사용되는 플라스틱 용기 중 재활용이 되는 것은 전체 절반(45.5%)도 못 미치는 것, 알고 계셨나요?\nGood To Go로 지구를 지켜요!",
      "imgPath": "assets/images/onboarding_trash.svg",
    },
    {
      "title": "나를 위해, Good To Go!",
      "content": "높은 배달료로 인해 망설이셨죠?\nGood To Go로 포장해요.\n걸으면서 건강도 지키고, 지갑도 지켜요!",
      "imgPath": "assets/images/onboarding_money.svg",
    },
    {
      "title": "미리 주문해요",
      "content":
          "음식점 사장님을 귀찮게 하는 건 아닐까...?\n용기를 들고 머뭇거리기 일쑤, 이젠 걱정하지 마세요.\nGood To Go로 미리 주문하고, 받아오기만 하면 되니까!",
      "imgPath": "assets/images/onboarding_order.svg",
    },
    {
      "title": "고민은 이제 끝!",
      "content":
          "내가 가져간 용기가 작은 건 아닐까...?\n걱정하지 마세요, Good To Go로 미리 확인하면 되니까!\n이제 Good To Go와 함께 용기내러 가볼까요?",
      "imgPath": "assets/images/onboarding_container.svg",
    },
  ];

  static final List<Map<String, dynamic>> foodCategories = [
    {
      "id": 0,
      "text": "전체",
      "assetName": "category_all.svg",
    },
    {
      "id": 1,
      "text": "한식",
      "assetName": "category_korean_food.svg",
    },
    {
      "id": 2,
      "text": "중식",
      "assetName": "category_chinese_food.svg",
    },
    {
      "id": 3,
      "text": "일식",
      "assetName": "category_japanese_food.svg",
    },
    {
      "id": 4,
      "text": "양식",
      "assetName": "category_western_food.svg",
    },
    {
      "id": 5,
      "text": "아시안",
      "assetName": "category_asian.svg",
    },
    {
      "id": 6,
      "text": "패스트푸드",
      "assetName": "category_fast_food.svg",
    },
    {
      "id": 7,
      "text": "고기/구이",
      "assetName": "category_meat.svg",
    },
    {
      "id": 8,
      "text": "분식",
      "assetName": "category_korean_snack.svg",
    },
    {
      "id": 9,
      "text": "카페/디저트",
      "assetName": "category_cafe.svg",
    },
  ];
}
