import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/model/store.dart';
import 'package:coupon_market/model/user.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class StoreWidget extends StatefulWidget {
  final Store store;
  final Function(Store) onClickStore;
  const StoreWidget({super.key, required this.store, required this.onClickStore});

  @override
  State<StoreWidget> createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onClickStore.call(widget.store),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: AssetWidget(widget.store.image, width: 70, height: 70),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.store.tCategory, style: Typo.bodyXLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.grey300,
                          ),
                          const SizedBox(width: 4),
                          Flexible(child: Text(widget.store.address, style: Typo.bodyLarge3, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                const Icon(Icons.text_snippet_outlined, size: 16, color: AppColors.grey300,),
                const SizedBox(width: 5),
                Text('???', style: Typo.bodyLarge2.colored(AppColors.grey300)),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.grey300,),
                const SizedBox(width: 5),
                Text('???', style: Typo.bodyLarge2.colored(AppColors.grey300)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}