import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/models/address.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {

  Future<void> openMap(UFUAddressModel? address) async {
    if(address == null) return;

    try {
      if (address.longitude != null && address.longitude != null) {
        return await openMapWithLatLng(address.latitude!, address.longitude!,
            label: address.completeAddress ?? "");
      } else if (address.placeId?.isNotEmpty ?? false) {
        return await openMapWithPlaceId(
            address.placeId!, label: address.completeAddress ?? "");
      } else {
        return await openMapWithAddress(address.completeAddress ?? "");
      }
    } catch (error) {
      return await _showError(error.toString());
    }
  }

  /// 🔹 Open map with lat/lng
  Future<void> openMapWithLatLng(double latitude, double longitude, {String label = "Here"}) async {
    try {
      Uri url;
      if (Platform.isIOS) {
        // iOS → Apple Maps
        final encodedLabel = Uri.encodeComponent(label);
        url = Uri.parse('http://maps.apple.com/?ll=$latitude,$longitude&q=$encodedLabel');
      } else {
        // Android → geo: scheme
        url = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude($label)');
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      _showError(error.toString());
    }
  }

  /// 🔹 Open map with formatted address
  Future<void> openMapWithAddress(String formattedAddress) async {
    try {
      Uri url;
      final query = Uri.encodeComponent(formattedAddress);

      if (Platform.isIOS) {
        // iOS → Apple Maps
        url = Uri.parse('http://maps.apple.com/?q=$query');
      } else {
        // Android → geo: scheme
        url = Uri.parse('geo:0,0?q=$query');
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      _showError(error.toString());
    }
  }

  /// 🔹 Open map with Google PlaceId
  Future<void> openMapWithPlaceId(String placeId, {String label = "Here"}) async {
    try {
      Uri url;
      if (Platform.isIOS) {
        // iOS does not support PlaceId → use Google Maps web link
        url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$label&query_place_id=$placeId');
      } else {
        // Android → Google Maps web link (safer than geo: for placeId)
        url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$label&query_place_id=$placeId');
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (error) {
      _showError(error.toString());
    }
  }

  /// 🔹 Common error handler
  Future<void> _showError(String message) async {
    await showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        title: const UFUText(text: "Error", fontWeight: UFUFontWeight.medium),
        content: UFUText(text: message),
        actions: [
          UFUTextButton(
            onPressed: () => Get.back(),
            text: "ok".tr,
          ),
        ],
      ),
    );
  }
}
