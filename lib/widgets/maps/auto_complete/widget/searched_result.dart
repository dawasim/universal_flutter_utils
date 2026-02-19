import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class SearchedResultTile extends StatelessWidget {
  const SearchedResultTile({
    super.key,
    required this.content
  });

  final Prediction content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.themeColors.base,
        // border: Border.all(color: AppTheme.themeColors.tertiary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Image.asset("assets/images/ic_location_pin.png", color: Colors.black, height: 18, width: 18),
              const SizedBox(width: 12),
              Expanded(child: UFUText(
                text: content.terms!.first.value,
                textAlign: TextAlign.start,
              ))
            ],
          ),
          const SizedBox(height: 5),
          UFUText(text: content.description ?? '',
            maxLine: 5,
            textSize: UFUTextSize.heading6,
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
