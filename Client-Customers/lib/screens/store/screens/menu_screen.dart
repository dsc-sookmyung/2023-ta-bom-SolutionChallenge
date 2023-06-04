import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:good_to_go/components/app_bar.dart';
import 'package:good_to_go/components/base_filled_button.dart';
import 'package:good_to_go/components/prepare_container_widget.dart';
import 'package:good_to_go/models/food_container_model.dart';
import 'package:good_to_go/models/menu_model.dart';
import 'package:good_to_go/models/options_model.dart';
import 'package:good_to_go/provider/cart_provider.dart';
import 'package:good_to_go/screens/store/components/option.dart';
import 'package:good_to_go/services/menu_service.dart';
import 'package:good_to_go/utilities/colors.dart';
import 'package:good_to_go/utilities/fonts.dart';
import 'package:good_to_go/utilities/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MenuScreen extends StatefulWidget {
  final String menuId;
  final String storeState;
  const MenuScreen(this.menuId, this.storeState, {super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final appBarTitle = "음식 상세 선택";
  final f = NumberFormat('###,###,###,###');
  late MenuModel _menuModel;
  bool isLoading = true;

  bool isButtonAvaliable() {
    for (var options in _menuModel.optionsList) {
      if (options.isRequired && options.checkedCount == 0) {
        return false;
      }
    }
    return true;
  }

  String getCheckText(int maxNum, int optionCount, bool isRequired) {
    if (maxNum == optionCount) {
      //필수 아님
      return "";
    } else if (maxNum == 1 && isRequired) {
      //1개
      return "(1개 선택)";
    } else if (maxNum != 1) {
      // 최대 개수 정해짐
      return "(최대 $maxNum개 선택)";
    }
    throw Error();
  }

  void addContainer(String optionId, int containerNum) {
    if (containerNum != 0) {
      _menuModel.containers.add(FoodContainer(optionId, containerNum));
      _menuModel.updateTotalContainers();
    }
  }

  void removeContainer(String optionId, int containerNum) {
    if (containerNum != 0) {
      _menuModel.containers.removeWhere((element) => element.id == optionId);
      _menuModel.updateTotalContainers();
    }
  }

  void checkOptionTapGester(int optionsIdx, int optionIdx) {
    final OptionsModel options = _menuModel.optionsList[optionsIdx];
    //필수 선택 메뉴, 최대 선택 개수 1개(라디오)
    if (options.maxCheck == 1 && options.isRequired!) {
      // 이미 선택된 라디오 메뉴 선택 시 그냥 종료
      if (options.optionList[optionIdx].isChecked) {
        return;
      }
      // 선택하지 않은 라디오 메뉴 선택 시
      for (var i = 0; i < options.optionList.length; i++) {
        // 전체 option을 살펴보며 선택된 option은 false로
        if (options.optionList[i].isChecked) {
          options.optionList[i].isChecked = false;
          subtractPrice(optionsIdx, i);
          removeContainer(
            options.optionList[i].id,
            options.optionList[i].container,
          );

          // 눌린 option은 true로 바꾼다.
          options.optionList[optionIdx].isChecked = true;
          addPrice(optionsIdx, optionIdx);
          addContainer(
            options.optionList[optionIdx].id,
            options.optionList[optionIdx].container,
          );
          break;
        }
      }
      // 여러 선택 가능할 시
      // 최대 개수 제한이 있는 옵션 중 최대 개수 만큼 선택했을 때
    } else if (options.maxCheck! < options.optionList.length &&
        options.maxCheck == options.checkedCount) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('최대 ${options.maxCheck}개까지 선택 가능합니다.'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: GrayScale.g800,
      ));
    }
    // 1개 이상 선택해야하는데 여러 개 선택 가능

    // 최대 선택 개수가 전체 개수와 같을 때 , 선택
    // 최대 선택 개수가 전체 개수보다 작을 때, 선택
    // 최대 선택 개수가 전체 개수보다 작을 때, 필수

    else {
      // 선택되어 있지 않을 때
      if (!options.optionList[optionIdx].isChecked) {
        options.optionList[optionIdx].isChecked = true;
        _menuModel.optionsList[optionsIdx].checkedCount++;
        addPrice(optionsIdx, optionIdx);
        addContainer(
          options.optionList[optionIdx].id,
          options.optionList[optionIdx].container,
        );
        // 선택되어 있을 때
      } else {
        options.optionList[optionIdx].isChecked = false;
        options.checkedCount--;
        subtractPrice(optionsIdx, optionIdx);
        removeContainer(
          options.optionList[optionIdx].id,
          options.optionList[optionIdx].container,
        );
      }
    }

    _menuModel.updateTotalPrice();
    setState(() {});
  }

  void subtractPrice(int optionsIdx, int optionIdx) {
    _menuModel.menuPrice = (_menuModel.menuPrice -
            _menuModel.optionsList[optionsIdx].optionList[optionIdx].price)
        .round();
  }

  void addPrice(int optionsIdx, int optionIdx) {
    _menuModel.menuPrice = (_menuModel.menuPrice +
            _menuModel.optionsList[optionsIdx].optionList[optionIdx].price)
        .round();
  }

  void getMenuAndInitData() async {
    _menuModel = await MenuService.getMenu(widget.menuId);
    isLoading = false;
    _menuModel.containers.add(FoodContainer("default", _menuModel.container));
    _menuModel.menuPrice = _menuModel.price;
    _menuModel.count = 1;
    _menuModel.updateTotalContainers();
    _menuModel.updateTotalPrice();

    for (var i = 0; i < _menuModel.optionsList.length; i++) {
      if (_menuModel.optionsList[i].isRequired &&
          _menuModel.optionsList[i].maxCheck == 1) {
        _menuModel.optionsList[i].optionList[0].isChecked = true;

        addContainer(_menuModel.optionsList[i].optionList[0].id,
            _menuModel.optionsList[i].optionList[0].container);

        _menuModel.optionsList[i].checkedCount++;
      }
    }
    setState(() {});
  }

  Widget getOptionWidgets(bool isOptionsListEmpty) {
    if (!isOptionsListEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "옵션",
            style: FontStyle.captionStyle,
          ),
          SizedBox(
            height: 6.h,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void initState() {
    super.initState();
    getMenuAndInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(appBarTitle),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15).w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 22.h,
                        ),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)).r,
                          child: Container(
                            height: 180.h,
                            width: 330.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.center,
                                image: NetworkImage(_menuModel.imgUrl!),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Text(
                          _menuModel.name,
                          style: FontStyle.headlineStyle,
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          _menuModel.description!,
                          style: TextStyle(
                            fontFamily: nanumSquareNeo,
                            fontSize: 12.sp,
                            height: 1.65,
                            fontVariations: const [
                              FontVariation('wght', 500),
                            ],
                            color: GrayScale.g700,
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        PrepareContainerWdiget(
                            containerList: _menuModel.totalContainers),
                        SizedBox(
                          height: 28.h,
                        ),
                        getOptionWidgets(_menuModel.optionsList.isEmpty),
                        ListView.separated(
                            itemCount: _menuModel.optionsList.length,
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 20.h,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${_menuModel.optionsList[index].optionName}${getCheckText(
                                          _menuModel
                                              .optionsList[index].maxCheck,
                                          _menuModel.optionsList[index]
                                              .optionList.length,
                                          _menuModel
                                              .optionsList[index].isRequired,
                                        )}',
                                        style: FontStyle.subCaptionStyle,
                                      ),
                                      _menuModel.optionsList[index].isRequired
                                          ? Text(
                                              " 필수*",
                                              style: TextStyle(
                                                fontFamily: nanumSquareNeo,
                                                fontSize: 10.sp,
                                                fontVariations: const [
                                                  FontVariation('wght', 700),
                                                ],
                                                color: primaryColor,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  ListView.separated(
                                      itemCount: _menuModel
                                          .optionsList[index].optionList.length,
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                      itemBuilder:
                                          (BuildContext context, int idx) {
                                        return Column(
                                          children: [
                                            Option(
                                                callback: () {
                                                  checkOptionTapGester(
                                                      index, idx);
                                                },
                                                isRadius: (_menuModel
                                                        .optionsList[index]
                                                        .maxCheck ==
                                                    1),
                                                isSelected: _menuModel
                                                    .optionsList[index]
                                                    .optionList[idx]
                                                    .isChecked,
                                                id: _menuModel
                                                    .optionsList[index]
                                                    .optionList[idx]
                                                    .id,
                                                name: _menuModel
                                                    .optionsList[index]
                                                    .optionList[idx]
                                                    .name,
                                                container: _menuModel
                                                    .optionsList[index]
                                                    .optionList[idx]
                                                    .container,
                                                price: _menuModel
                                                    .optionsList[index]
                                                    .optionList[idx]
                                                    .price)
                                          ],
                                        );
                                      }),
                                ],
                              );
                            }),
                        SizedBox(
                          height: 42.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "수량",
                              style: TextStyle(
                                fontFamily: nanumSquareNeo,
                                fontSize: 12.sp,
                                fontVariations: const [
                                  FontVariation('wght', 700),
                                ],
                                color: GrayScale.g900,
                              ),
                            ),
                            Container(
                              color: GrayScale.g100,
                              width: 140.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: GrayScale.g200,
                                      borderRadius: BorderRadius.circular(6).r,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (_menuModel.count > 1) {
                                          _menuModel.count--;
                                          _menuModel.updateTotalContainers();
                                          _menuModel.updateTotalPrice();
                                          setState(() {});
                                        }
                                      },
                                      icon: _menuModel.count > 1
                                          ? SvgPicture.asset(
                                              'assets/icons/remove.svg',
                                            )
                                          : SvgPicture.asset(
                                              'assets/icons/remove_light.svg',
                                            ),
                                      iconSize: 24.sp,
                                      padding: const EdgeInsets.all(8).w,
                                    ),
                                  ),
                                  Text(_menuModel.count.toString(),
                                      style: TextStyle(
                                        fontFamily: nanumSquareNeo,
                                        fontSize: 15.sp,
                                        fontVariations: const [
                                          FontVariation('wght', 600),
                                        ],
                                        color: GrayScale.g700,
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: GrayScale.g200,
                                      borderRadius: BorderRadius.circular(6).r,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        _menuModel.count++;
                                        _menuModel.updateTotalContainers();
                                        _menuModel.updateTotalPrice();
                                        setState(() {});
                                      },
                                      icon: SvgPicture.asset(
                                          'assets/icons/add.svg'),
                                      iconSize: 24.sp,
                                      padding: const EdgeInsets.all(8).w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28.h,
                        ),
                        BaseFilledButton(
                            isDisable: widget.storeState == "closed" ||
                                    !isButtonAvaliable()
                                ? true
                                : false,
                            widget.storeState == "closed"
                                ? "가게가 영업 중이지 않아서 주문할 수 없습니다"
                                : !isButtonAvaliable()
                                    ? "필수 옵션을 모두 선택해야 합니다."
                                    : "${f.format(_menuModel.totalPrice)}원 장바구니에 담기",
                            () {
                          final String uuid = const Uuid().v4();
                          MenuModel menu = _menuModel;
                          menu.uuid = uuid;
                          if (context
                              .read<CartProvider>()
                              .isTheStoreIdSame(menu.storeId!)) {
                            context.read<CartProvider>().addMenuToCart(menu);
                            Navigator.pop(
                              context,
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CartWarningDialog(
                                    confirm: () {
                                      context
                                          .read<CartProvider>()
                                          .clearMenuInCart();
                                      context
                                          .read<CartProvider>()
                                          .addMenuToCart(menu);

                                      Navigator.pop(
                                        context,
                                      );
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    cancel: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                  );
                                });
                          }
                        }),
                        SizedBox(
                          height: 32.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CartWarningDialog extends StatelessWidget {
  final void Function()? confirm;
  final void Function()? cancel;
  const CartWarningDialog({
    super.key,
    required this.confirm,
    required this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.r),
      ),
      buttonPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 25.h),
      contentPadding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 0),
      contentTextStyle: TextStyle(
        fontFamily: nanumSquareNeo,
        fontSize: 13.sp,
        height: 1.5,
        color: GrayScale.g900,
        fontVariations: const [
          FontVariation('wght', 600),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "장바구니에는 같은 가게 메뉴만 담을 수 있습니다. 장바구니에 담긴 이전 메뉴를 모두 삭제하고 현재 메뉴로 새롭게 담을까요?",
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: cancel,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: GrayScale.g200,
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                ),
                child: Text(
                  "취소",
                  style: TextStyle(
                    fontFamily: nanumSquareNeo,
                    fontSize: 12.sp,
                    color: GrayScale.g500,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: confirm,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                ),
                child: Text(
                  "현재 메뉴 담기",
                  style: TextStyle(
                    fontFamily: nanumSquareNeo,
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontVariations: const [
                      FontVariation('wght', 600),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
