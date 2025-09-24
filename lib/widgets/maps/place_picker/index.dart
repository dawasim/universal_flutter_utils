import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import '../../../models/address.dart';
import 'controller.dart';
import 'widget/custom_place_picker.dart';


class UFULocationPicker extends StatelessWidget {
  UFULocationPicker({
    super.key,
    this.backButton,
    required this.apiKey,
    this.placesAPIHeader,
    this.address,
  });

  /// Back button replacement when [hideBackButton] is false and [backButton] is not null
  final Widget? backButton;
  final String? apiKey;
  final Map<String, String>? placesAPIHeader;
  final UFUAddressModel? address;

  final coordinateX = Get.size.height ~/ 2;
  final coordinateY = Get.size.width ~/ 2;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UFULocationPickerController>(
      init: UFULocationPickerController(
        apiKey: apiKey ?? "",
        placesAPIHeader: placesAPIHeader,
        address: address
      ),
      global: false,
      dispose: (GetBuilderState<UFULocationPickerController> state) => state.controller?.disposeControllers(),
      builder: (controller) => Scaffold(
        // appBar: customToolbar(
        //   title: "currentLocation".tr,
        //   onBackPress: () => Get.back(),
        // ),
        body: Stack(
          children: [
            UFUPlacePicker(
              currentLatLng: controller.currentLocation,
              searchController: controller.searchController,
              apiKey: controller.apiKey,
              placesApiHeaders: controller.placesAPIHeader,
              geoCodingApiHeaders: controller.placesAPIHeader,
              popOnNextButtonTaped: true,
              debounceDuration: const Duration(milliseconds: 500),
              hideBackButton: true,
              zoomGesturesEnabled: true,
              minMaxZoomPreference: const MinMaxZoomPreference(0, 25),
              topCardColor: Colors.white,
              backButton: backButton,
              searchHintText: "search_here".tr,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.themeColors.primary,
                ),
                border: InputBorder.none,
              ),
              bottomCardBuilder: (BuildContext context, GeocodingResult? result, String address,) {
                return SafeArea(top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                    child: UFUButton(
                        text: "confirm_location".tr,
                        onPressed: () => controller.saveCurrentLocation()),
                  ),
                );
              },
              onDecodeAddress: controller.setSelectedAddress,
              onNext: controller.setSelectedAddress,
              onSuggestionSelected: controller.setSearchedAddress,
              hideMapTypeButton: true,
            ),
            Positioned.fill(
              child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 70),
                  child: Obx(() => controller.selectedAddress.value != null ? Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      Image.asset("assets/images/ic_location_marker.png", height: 60, width: 60),
                      const SizedBox(height: 8),
                      markerInfo(controller)
                    ],
                  ) : const UFULoader())),
            )
          ],
        ),
      ),
    );
  }

  markerInfo(UFULocationPickerController controller) => Container(
    constraints: const BoxConstraints(maxWidth: 300),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/ic_location_pin.png",
          height: 24,
          width: 24,
          color: AppTheme.themeColors.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(controller.selectedAddress.value?.addressComponents.firstOrNull?.longName?.isNotEmpty ?? false) ...[
                UFUText(
                  text: controller.selectedAddress.value?.addressComponents.firstOrNull?.longName ?? "",
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 4),
              ],

              UFUText(
                text: controller.selectedAddress.value?.formattedAddress ?? "",
                textColor: AppTheme.themeColors.secondaryText,
                maxLine: 4,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    ),
  );


  temp() => Column(
    children: [
      Positioned(
        left: coordinateY.toDouble() - 28, // Adjust for widget width/height
        top: coordinateX.toDouble() - 20, // Adjust for widget width/height
        child: Image.asset("assets/images/ic_location_marker.png", height: 60, width: 60),
      ),

      // Positioned.fill(
      //   child: Container(
      //       alignment: Alignment.center,
      //       margin: const EdgeInsets.only(bottom: 60),
      //       child: Obx(() => controller.selectedAddress.value != null
      //           ? markerInfo(controller)
      //           : const LoaderWidget())),
      // ),

      Positioned(
        left: coordinateY.toDouble(), // Adjust for widget width/height
        top: coordinateX.toDouble(), // Adjust for widget width/height
        child: const UFUText(text: ".",),
      ),
    ],
  );

}
