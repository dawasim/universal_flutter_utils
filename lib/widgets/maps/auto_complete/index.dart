import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import '../../../models/address.dart';
import 'controller.dart';
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
    this.textSize = UFUTextSize.heading4,
    this.fontWeight = UFUFontWeight.regular,
    this.trailing,
    this.showClearButton = true,
    this.onTextChange,
  });

  /// Back button replacement when [hideBackButton] is false and [backButton] is not null
  final Widget? backButton;
  final String apiKey;
  final String? searchHintText;
  final Map<String, String>? placesAPIHeader;
  final UFUAddressModel? address;
  final UFUInputBoxController? textController;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(UFUAddressModel?)? onDecodeAddress;
  final Color? borderColor;
  final UFUTextSize textSize;
  final UFUFontWeight fontWeight;
  final Widget? trailing;
  final bool showClearButton;
  final Function(String?)? onTextChange;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<UFUPlaceAutoCompleteController>(
      global: false,
      init: UFUPlaceAutoCompleteController(
        searchController: textController,
        textSize: textSize,
        fontWeight: fontWeight
      ),
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
                borderRadius: BorderRadius.circular(14),
                decoration: InputDecoration(
                  prefix: const SizedBox(width: 10),
                  suffix: const SizedBox(width: 10),
                  hintText: searchHintText ?? "Search Here",
                  hintStyle: controller.getHintStyle(),
                  labelStyle: controller.getHintStyle(),
                  errorStyle: controller.getErrorStyle(),
                  counterStyle: const TextStyle(
                    height: 0,
                  ),
                  focusedBorder: customBorder(borderColor: borderColor),
                  enabledBorder: customBorder(borderColor: borderColor),
                  disabledBorder: customBorder(borderColor: borderColor),
                  errorBorder: errorBorder(),
                  focusedErrorBorder: errorBorder(),
                  border: customBorder(borderColor: borderColor),
                ),
                validator: (val) => UFUtils.textValidator(val?.description, isRequired: true, minCount: 3),
                apiKey: apiKey,
                searchHintText: searchHintText ?? "Search here",
                placesApiHeaders: placesAPIHeader,
                mounted: false,
                hideBackButton: true,
                hideOnUnfocus: false,
                initialValue: null,
                controller: controller.searchController?.controller,
                focusNode: controller.searchController?.focusNode,
                showClearButton: showClearButton,
                left: true,
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                trailingIcon: trailing,
                onTextChange: onTextChange,
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
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: borderColor ?? AppTheme.themeColors.lightestGray, width: 0.8));

  OutlineInputBorder errorBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: AppTheme.themeColors.red, width: 0.8));
}
