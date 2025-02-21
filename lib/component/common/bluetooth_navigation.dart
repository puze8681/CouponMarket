import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:flutter/material.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';

class BluetoothNavigation extends StatefulWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final String title;
  final bool isBack;
  final Function? backButtonAction;
  final Widget? singleActionWidget;
  final Widget? doubleActionWidget;
  final double? opacity;
  final Widget? bottom;
  final double? bottomHeight;

  const BluetoothNavigation({
    super.key,
    this.backgroundColor,
    this.title = "",
    this.isBack = true,
    this.backButtonAction,
    this.singleActionWidget,
    this.doubleActionWidget,
    this.opacity,
    this.bottom,
    this.bottomHeight,
  });

  @override
  State<BluetoothNavigation> createState() => _BluetoothNavigationState();

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _BluetoothNavigationState extends State<BluetoothNavigation> {

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.backgroundColor ?? AppColors.white;
    Widget singleActionWidget = widget.singleActionWidget ?? const SizedBox();
    Widget doubleActionWidget = widget.doubleActionWidget ?? const SizedBox();

    return SafeArea(
      child: AppBar(
        surfaceTintColor: widget.opacity != null
            ? backgroundColor.withOpacity(widget.opacity!)
            : backgroundColor,
        leadingWidth: 36,
        leading: widget.isBack
            ? GestureDetector(
          onTap: () async {
            if (widget.backButtonAction != null) {
              await widget.backButtonAction!.call();
              return;
            }
            Navigator.pop(context);
          },
          child: Container(
              color: AppColors.transparent,
              child: Container(margin: const EdgeInsets.only(left: 12), child: const AssetWidget(Assets.ic_back, width: 24, height: 24, color: AppColors.mainText),)),
        )
            : const SizedBox(),
        centerTitle: true,
        title: Text(widget.title, style: Typo.headline5),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              doubleActionWidget,
              const SizedBox(
                width: 24,
              ),
              singleActionWidget,
              const SizedBox(width: 20),
            ].whereType<Widget>().toList(),
          )
        ],
        bottom: widget.bottom != null
            ? widget.bottom is PreferredSizeWidget
            ? widget.bottom as PreferredSizeWidget?
            : PreferredSize(
          preferredSize: Size.fromHeight(
            widget.bottomHeight ?? 60,
          ),
          child: widget.bottom!,
        )
            : null,
        backgroundColor: widget.opacity != null
            ? backgroundColor.withOpacity(widget.opacity!)
            : backgroundColor,
        elevation: 0.0,
      ),
    );
  }
}