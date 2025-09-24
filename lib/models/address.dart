
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUAddressModel {
  String? id;
  String? address;
  String? address1;
  String? address2;
  String? completeAddress;
  String? city;
  String? state;
  String? country;
  String? postcode;
  double? latitude;
  double? longitude;
  String? placeId;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  UFUAddressModel({
    this.id,
    this.address,
    this.address1,
    this.address2,
    this.completeAddress,
    this.city,
    this.state,
    this.country,
    this.postcode,
    this.latitude,
    this.longitude,
    this.placeId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory UFUAddressModel.fromJson(Map<String, dynamic> json) {
    return UFUAddressModel(
      id: json['id'],
      address: json['address'],
      address1: json['address1'],
      address2: json['address2'],
      completeAddress: json['complete_address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postcode: json['postcode'],
      latitude: (json['latitude'] is String?)
          ? (json['latitude'] as String?)?.formatUpTo()
          : json['latitude'] as double?,
      longitude: (json['longitude'] is String?)
          ? (json['longitude'] as String?)?.formatUpTo()
          : json['longitude'] as double?,
      placeId: json['place_id']?.toString(),
      userId: json['user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (address1 != null) 'address1': address1,
      if (address2 != null) 'address2': address2,
      if (completeAddress != null) 'complete_address': completeAddress,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (country != null) 'country': country,
      if (postcode != null) 'postcode': postcode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (placeId != null) 'place_id': placeId,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String getFormatedAddress() {
    return [
      address1 == null || (address1?.trim().isEmpty ?? true) ? null : '$address1',
      address2 == null || (address2?.trim().isEmpty ?? true) ? null : '$address2',
      city == null || (city?.trim().isEmpty ?? true) ? null : '$city',
      state == null || (state?.trim().isEmpty ?? true) ? null : '$state',
      country == null || (country?.trim().isEmpty ?? true) ? null : '$country',
      postcode == null || (postcode?.trim().isEmpty ?? true) ? null : '$postcode',
    ].where((e) => e != null).join(', ');
  }

  UFUAddressModel copyWith({
    String? id,
    String? address,
    String? address1,
    String? address2,
    String? completeAddress,
    String? city,
    String? state,
    String? country,
    String? postcode,
    double? latitude,
    double? longitude,
    String? placeId,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UFUAddressModel(
      id: id ?? this.id,
      address: address ?? this.address,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      completeAddress: completeAddress ?? this.completeAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postcode: postcode ?? this.postcode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeId: placeId ?? this.placeId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
