import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/constants/color.constant.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/auth/widgets/custom_image_view.dart';
import 'package:tsmobile/src/interfaces/bottom_navigation_menu.dart';
import 'package:tsmobile/src/utils/size.utils.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onChangeIndex;
  final List<BottomNavigationMenu> bottomMenuList;
  final int currentIndex;
  final Color? backgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.onChangeIndex,
    required this.bottomMenuList,
    this.currentIndex = 0,
    this.backgroundColor,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
    _currentIndex = widget.currentIndex!;
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _currentIndex = widget.currentIndex;
      });
    }
  }

  void _onTappedItem(int index) {
    _currentIndex = index;
    widget.onChangeIndex(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      backgroundColor: widget.backgroundColor,
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        widget.bottomMenuList.length,
        (index) {
          return BottomNavigationBarItem(
              label: '',
              icon: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: CustomImageView(
                      svgPath: widget.bottomMenuList[index].icon,
                      height: getSize(24),
                      width: getSize(24),
                      color: ColorConstant.gray00,
                    ),
                  ),
                  if (widget.bottomMenuList[index].title != null)
                    Text(
                      widget.bottomMenuList[index].title ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14White.copyWith(
                        color: ColorConstant.gray00,
                      ),
                    ),
                ],
              ),
              activeIcon: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: CustomImageView(
                        svgPath: widget.bottomMenuList[index].icon,
                        height: getSize(24),
                        width: getSize(24),
                        color: ColorConstant.gray00),
                  ),
                  if (widget.bottomMenuList[index].title != null)
                    Text(
                      widget.bottomMenuList[index].title ?? '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium14White.copyWith(
                        color: ColorConstant.black00,
                      ),
                    ),
                ],
              ));
        },
      ),
      onTap: _onTappedItem,
    );
  }
}
