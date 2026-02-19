import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:universal_flutter_utils/models/address.dart';

class UFUPlaceAutoCompleteController extends GetxController {

  Completer<GoogleMapController> mapController = Completer();

  UFUInputBoxController? searchController;
  GeocodingResult? _geocodingResult;

  UFUTextSize textSize;
  UFUFontWeight fontWeight;


  UFUPlaceAutoCompleteController({
    this.searchController,
    required this.textSize,
    required this.fontWeight,
  });

  @override
  void onInit() {
    super.onInit();
    searchController ??= UFUInputBoxController();
  }

  /// Default text style for label and hint text.
  TextStyle getHintStyle() {
    return TextStyle(
      fontFamily: UFUtils.fontFamily, // TODO - 'Roboto',
      fontWeight: TextHelper.getFontWeight(fontWeight), //fontWeight ?? FontWeight.w300,
      height: 1.2,
      color: AppTheme.themeColors.hintText,
      fontSize: TextHelper.getTextSize(textSize),
    );
  }

  TextStyle getErrorStyle() {
    return TextStyle(
      fontFamily: UFUtils.fontFamily, // TODO - 'Roboto',
      fontWeight: TextHelper.getFontWeight(fontWeight), //fontWeight ?? FontWeight.w300,
      height: 1.2,
      color: AppTheme.themeColors.red,
      fontSize: TextHelper.getTextSize(UFUTextSize.heading5),
    );
  }


  Future<void> saveCurrentLocation(PlaceDetails? selectedPlace, {Prediction? searchedItem, Function(UFUAddressModel?)? onDecodeAddress}) async {
    UFUtils.hideKeyboard();
    if (selectedPlace == null && searchedItem == null) return;

    Location? sLocation = selectedPlace?.geometry?.location;

    if(searchedItem != null) {

      Map<String, dynamic> addressComponent = {"address_components": []};
      if(searchedItem.terms.isNotEmpty) {
        for (var element in selectedPlace?.addressComponents ?? []) {
          addressComponent["address_components"].add(element.toJson());
        }
      }

      _geocodingResult = GeocodingResult.fromJson({
        "geometry": {
          "location": {
            "lat": sLocation?.lat,
            "lng": sLocation?.lng,
          }
        },
        "place_id": searchedItem.placeId,
        'formatted_address': searchedItem.description,
        ...addressComponent,
      });
    }

    try {
      String? city;
      String? state;
      String? country;
      String? postcode;

      for (var component in _geocodingResult?.addressComponents ?? []) {
        if (component.types?.contains('locality') ?? false) {
          city = component.longName;
        } else if (component.types?.contains('administrative_area_level_1') ?? false) {
          state = component.longName;
        } else if (component.types?.contains('country') ?? false) {
          country = component.longName;
        } else if (component.types?.contains('postal_code') ?? false) {
          postcode = component.longName;
        }
      }

      debugPrint("selectedLocLatLng----> ${_geocodingResult?.geometry.location.lat}----${_geocodingResult?.geometry.location.lng}");

      UFUAddressModel address = UFUAddressModel();

      address
        ..placeId = _geocodingResult?.placeId
        ..address = _geocodingResult?.formattedAddress
        ..completeAddress = _geocodingResult?.formattedAddress
        ..address1 = _geocodingResult?.formattedAddress
        ..address2 = null
        ..latitude = _geocodingResult?.geometry.location.lat
        ..longitude = _geocodingResult?.geometry.location.lng
        ..city = city
        ..state = state
        ..country = country
        ..postcode = postcode;

      onDecodeAddress?.call(address);
    } catch (e) {
      UFUtils.handleError(e);
    }

  }

}