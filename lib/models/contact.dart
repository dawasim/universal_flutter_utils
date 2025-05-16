import 'package:flutter_native_contact_picker/model/contact.dart';

class ContactModel {
/*
{
  "fullName": "fullName",
  "phoneNumbers": [
    "9876543216"
  ]
} 
*/

  String? fullName;
  List<String?>? phoneNumbers;

  ContactModel({
    this.fullName,
    this.phoneNumbers,
  });

  ContactModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName']?.toString();
    if (json['phoneNumbers'] != null && (json['phoneNumbers'] is List)) {
      phoneNumbers = <String>[];
      json['phoneNumbers'].forEach((v) {
        phoneNumbers?.add(v.toString());
      });
    }
  }

  ContactModel.fromContacts(Contact? contact) {
    fullName = contact?.fullName;
    phoneNumbers = contact?.phoneNumbers;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fullName'] = fullName;
    if (phoneNumbers != null) {
      data['phoneNumbers'] = [];
      for (var v in phoneNumbers!) {
        data['phoneNumbers'].add(v);
      }
    }
    return data;
  }
}
