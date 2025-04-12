import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/assets.dart';
import 'package:flutter/material.dart';

class DefaultModal extends StatelessWidget {

  final bool canPop;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  final double width;

  const DefaultModal({
    super.key,
    required this.child,
    this.canPop = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.all(12),
    this.width = 310,
  });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      content: Wrap(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * (width/360),
            child: Container(
              alignment: Alignment.center,
              padding: padding,
              child: Column(
                children: [
                  if(canPop) Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          color: Colors.transparent,
                          child: const AssetWidget(Assets.ic_modal_close, width: 24, height: 24),
                        ),
                      )
                    ],
                  ),
                  if(canPop) const SizedBox(height: 12),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<dynamic> showModal({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  Color? barrierColor,
  bool barrierDismissible = true,
  String modalName = "modal_widget"
}) {
  return showDialog(
    routeSettings: RouteSettings(name: modalName),
    context: context,
    builder: builder,
    barrierColor: barrierColor ?? Colors.black.withOpacity(0.6),
    barrierDismissible: barrierDismissible,
  );
}