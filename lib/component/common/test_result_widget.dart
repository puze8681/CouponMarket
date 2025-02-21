import 'package:coupon_market/component/common/asset_widget.dart';
import 'package:coupon_market/constant/colors.dart';
import 'package:coupon_market/constant/typo.dart';
import 'package:coupon_market/model/test_result.dart';
import 'package:coupon_market/util/extensions.dart';
import 'package:flutter/material.dart';

class TestResultWidget extends StatefulWidget {
  final TestResult testResult;
  final Function(TestResult) onClickTest;
  final Function(TestResult) onClickImage;
  const TestResultWidget({super.key, required this.testResult, required this.onClickTest, required this.onClickImage});

  @override
  State<TestResultWidget> createState() => _TestResultWidgetState();
}

class _TestResultWidgetState extends State<TestResultWidget> {
  @override
  Widget build(BuildContext context) {
    Widget imageWidget = widget.testResult.image != null ? ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: AssetWidget(widget.testResult.image!, width: 70, height: 70),
    ) : const Icon(Icons.add, color: Colors.white, size: 24);
    return GestureDetector(
      onTap: () => widget.onClickTest.call(widget.testResult),
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
                  onTap: () => widget.onClickImage.call(widget.testResult),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: imageWidget,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.testResult.category ?? "", style: Typo.bodyXLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.grey300,
                          ),
                          const SizedBox(width: 4),
                          Flexible(child: Text(widget.testResult.address, style: Typo.bodyLarge3, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis)),
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
                Text('Test Result', style: Typo.bodyLarge2.colored(AppColors.grey300)),
                const Spacer(),
                TestTag(title: widget.testResult.statusText, textColor: widget.testResult.statusTextColor, backgroundColor: widget.testResult.statusBackgroundColor),
                const SizedBox(width: 70),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.grey300,),
                const SizedBox(width: 5),
                Text('Date', style: Typo.bodyLarge2.colored(AppColors.grey300)),
                const Spacer(),
                Text(widget.testResult.createdAt.format("yyyy.MM.dd"), style: Typo.bodyLarge3),
                const SizedBox(width: 75),
              ],
            ),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _MeasurementCard(
                      title: 'pH',
                      value: widget.testResult.phValue,
                      level: widget.testResult.phLevel,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MeasurementCard(
                      title: 'Hardness',
                      value: widget.testResult.hardnessValue,
                      level: widget.testResult.hardnessLevel,
                      unit: 'mg/L',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MeasurementCard(
                      title: 'Total Alkalinity',
                      value: widget.testResult.totalAlkalinityValue,
                      level: widget.testResult.totalAlkalinityLevel,
                      unit: 'mg/L',
                    ),
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

class _MeasurementCard extends StatelessWidget {
  final String title;
  final double value;
  final int level;
  final String? unit;

  const _MeasurementCard({
    required this.title,
    required this.value,
    required this.level,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffF7F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(title, style: Typo.bodyMedium2.colored(AppColors.grey300)),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            height: 22,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(value.toString(), style: Typo.bodyXLarge),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Flexible(child: Text(unit!, style: Typo.bodyXSmall, overflow: TextOverflow.visible, maxLines: 1, softWrap: true)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 5),
          TestTag(title: level.resultText, textColor: level.resultTextColor, backgroundColor: level.resultBackgroundColor),
        ],
      ),
    );
  }
}

class TestTag extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;

  const TestTag({super.key,
    required this.title,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      height: 35,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: textColor),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: Typo.bodySmall.colored(textColor),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}