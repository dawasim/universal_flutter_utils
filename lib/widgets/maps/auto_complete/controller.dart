import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/models/address.dart';

import '../../../utils/index.dart';

class UFUPlaceAutoCompleteController extends GetxController {

  Completer<GoogleMapController> mapController = Completer();

  TextEditingController? searchController;
  GeocodingResult? _geocodingResult;


  UFUPlaceAutoCompleteController({this.searchController});

  @override
  void onInit() {
    super.onInit();

    searchController ??= TextEditingController();
  }

  Future<void> saveCurrentLocation(PlaceDetails? selectedPlace, {Prediction? searchedItem, Function(UFUAddressModel?)? onDecodeAddress}) async {
    UFUtils.hideKeyboard();
    if (selectedPlace == null && searchedItem == null) return;

    Location? sLocation = selectedPlace?.geometry?.location;

    if(searchedItem != null) {

      Map<String, dynamic> addressComponent = {"address_components": []};
      if(searchedItem.terms.isNotEmpty) {
        for (var element in selectedPlace!.addressComponents) {
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

      for (var component in _geocodingResult!.addressComponents) {
        if (component.types.contains('locality')) {
          city = component.longName;
        } else if (component.types.contains('administrative_area_level_1')) {
          state = component.longName;
        } else if (component.types.contains('country')) {
          country = component.longName;
        } else if (component.types.contains('postal_code')) {
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