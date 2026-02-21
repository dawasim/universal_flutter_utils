import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

import '../../../api_config/api_config.dart';
import '../../../models/address.dart';


class UFULocationPickerController extends GetxController {
  late final apiService = UFApiConfig();
  Rx<GeocodingResult?> selectedAddress = Rx<GeocodingResult?>(null);
  Rx<PlaceDetails?> autocompletePlace = Rx<PlaceDetails?>(null);

  String apiKey = "";
  final Map<String, String>? placesAPIHeader;
  UFUAddressModel? address;

  bool? isEdit = false;

  UFULocationPickerController({required this.apiKey, this.placesAPIHeader, this.address, this.isEdit});

  LatLng? currentLocation;

  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFormData();
  }

  void loadFormData() {
    if(address?.latitude != null && address?.longitude != null) {
      currentLocation = LatLng(address!.latitude!, address!.longitude!);
      selectedAddress.value = GeocodingResult.fromJson({
        "geometry": {
          "location": {
            "lat": address?.latitude ?? "",
            "lng": address?.longitude ?? "",
          }
        },
        "place_id": address?.placeId ?? "",
        'formatted_address': address?.getFormatedAddress() ?? "",
      });
      isEdit = true;
    }
    update();
  }

  Future<void> saveCurrentLocation() async {
    final selectedPlace = selectedAddress.value;
    if (selectedPlace == null) return;
    try {
      String? city;
      String? state;
      String? country;
      String? postcode;

      for (var component in selectedPlace.addressComponents ?? []) {
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

      debugPrint("selectedLocLatLng----> ${selectedPlace.geometry?.location.lat}----${selectedPlace.geometry?.location.lng}");

      address = address ?? UFUAddressModel();

      address!
        ..placeId = selectedPlace.placeId
        ..address = selectedPlace.formattedAddress
        ..completeAddress = selectedPlace.formattedAddress
        ..address1 = selectedPlace.formattedAddress
        ..address2 = null
        ..latitude = selectedPlace.geometry?.location.lat
        ..longitude = selectedPlace.geometry?.location.lng
        ..city = city
        ..state = state
        ..country = country
        ..postcode = postcode;

      Get.back(result: address);
    } catch (e) {
      UFUtils.handleError(e);
    }
  }

  void setSelectedAddress(GeocodingResult? result, {bool? isFromSearch}) {
    if (result != null) {
      if(isFromSearch ?? false) isEdit = true;
      if(isEdit ?? false) {
        isEdit = false;
      } else {
        selectedAddress.value = result;
      }
    }
  }

  void setSearchedAddress(PlacesDetailsResponse? result) {
    if (result != null) {
      autocompletePlace.value = result.result;
      selectedAddress.value = GeocodingResult(
        geometry: result.result?.geometry ??
            Geometry(location: Location(lat: 0, lng: 0)),
        placeId: result.result?.placeId,
        addressComponents: result.result?.addressComponents,
        formattedAddress: result.result?.formattedAddress,
      );
      isEdit = true;
    }
  }

  void disposeControllers() {
    // searchController.dispose();
  }
}
