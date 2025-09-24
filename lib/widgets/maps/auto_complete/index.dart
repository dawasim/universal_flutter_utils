import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import '../../../models/address.dart';
import 'controller.dart';
import 'widget/auto_complete.dart';
import 'widget/empty_result.dart';
import 'widget/searched_result.dart';

class UFUPlaceAutoComplete extends StatelessWidget {
  const UFUPlaceAutoComplete({
    super.key,
    this.backButton,
    required this.apiKey,
    this.searchHintText,
    this.placesAPIHeader,
    this.address,
    this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.onDecodeAddress,
    this.borderColor,
  });

  /// Back button replacement when [hideBackButton] is false and [backButton] is not null
  final Widget? backButton;
  final String apiKey;
  final String? searchHintText;
  final Map<String, String>? placesAPIHeader;
  final UFUAddressModel? address;
  final TextEditingController? textController;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(UFUAddressModel?)? onDecodeAddress;
  final Color? borderColor;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UFUPlaceAutoCompleteController>(
      global: false,
      init: UFUPlaceAutoCompleteController(searchController: textController),
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(backButton != null)
            backButton!,
          Expanded(
            child: Padding(
              padding: backButton != null ? EdgeInsets.only(
                  left: UFUtils.isRtl ? 15 : 0,
                  right: UFUtils.isRtl ? 0 : 15,
              ) : EdgeInsets.zero,
              child: CustomPlaceAutoComplete(
                topCardMargin: EdgeInsets.zero,
                topCardColor: AppTheme.themeColors.transparent,
                decoration: InputDecoration(
                  border: customBorder(borderColor: borderColor ?? AppTheme.themeColors.primary),
                ),
                apiKey: apiKey,
                searchHintText: searchHintText ?? "Search here",
                placesApiHeaders: placesAPIHeader,
                mounted: false,
                hideBackButton: true,
                hideOnUnfocus: false,
                initialValue: null,
                controller: controller.searchController,
                showClearButton: true,
                left: true,
                // decoration: widget.decoration,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                onGetDetailsByPlaceId: (p0, {Prediction? searchedPlace}) =>
                    controller.saveCurrentLocation(p0?.result,
                        searchedItem: searchedPlace,
                        onDecodeAddress: onDecodeAddress
                    ),
                emptyBuilder: (_) => (controller.searchController?.text.trim().isEmpty ?? true)
                    ? const SizedBox.shrink() : const EmptySearchResult(),
                itemBuilder: (_, content) => SearchedResultTile(content: content),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder customBorder({Color? borderColor}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: borderColor ?? AppTheme.themeColors.lightestGray, width: 0));
}
