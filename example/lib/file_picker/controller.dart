import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class FilePickerController extends GetxController {

  RxString filePath = RxString("");
  RxString imagePathFromGallery = RxString("");
  RxString imagePath = RxString("");
  RxString audioPath = RxString("");
  RxString contact = RxString("");
  RxString date = RxString("");
  RxString time = RxString("");


  Future<void> pickFile() async {
    filePath.value = await UFUtils.picker.selectDocument() ?? "";
  }

  Future<void> pickImageFromGallery() async {
    List<XFile> fileList = await UFUtils.picker.selectImageFromGallery();
    if(fileList.isNotEmpty) imagePathFromGallery.value = fileList.first.path;
  }

  Future<void> pickImageFromCamera() async {
    List<XFile> fileList = await UFUtils.picker.captureImageFromCamera();
    if(fileList.isNotEmpty) imagePath.value = fileList.first.path;
  }

  Future<void> recordAudio() async {
    audioPath.value = await UFUtils.picker.recordAudio() ?? "";
  }

  Future<void> pickContact() async {
    contact.value = await UFUtils.picker.selectContacts() ?? "";
  }

  Future<void> pickDate() async {
    DateTime? selectedDate = await UFUtils.picker.selectDate();
    if(selectedDate != null) {
      date.value = UFUtils.formatDate(selectedDate) ?? "";
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? selectedTime = await UFUtils.picker.selectTime();
    if(selectedTime != null) {
      time.value = "${selectedTime.hour} : ${selectedTime.minute}";
    }
  }
}