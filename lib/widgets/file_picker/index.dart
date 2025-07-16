import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUFilePicker {
  static Future<String?> show({primary, Color? bgColor, List<String>? allowedExtensions}) async {
    return await ShowUFUBottomSheet(
    child: (controller) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
          color: bgColor ?? AppTheme.themeColors.themeBlue),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const UFUText(
                    text: "Select File",
                    textSize: UFUTextSize.heading3,
                    fontWeight: UFUFontWeight.medium,
                    // fontFamily: UFUFontFamily.productSans,
                  ),
                  UFUIconButton(
                    onTap: () => Get.back(),
                    iconSize: 30,
                    icon: Icons.clear,
                    iconColor: AppTheme.themeColors.text,
                    backgroundColor: AppTheme.themeColors.transparent,
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 100,
                      child: UFUIconButton(
                        onTap: () async {
                          String? filepath = await pickImageFromCamera();
                          Get.back(result: filepath);
                        },
                        iconSize: 40,
                        icon: Icons.camera_alt_rounded,
                        iconColor: AppTheme.themeColors.text,
                        backgroundColor: AppTheme.themeColors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 100,
                      child: UFUIconButton(
                        onTap: () async {
                          String? filepath = await pickImageFromDocuments(allowedExtensions: allowedExtensions);
                          Get.back(result: filepath);
                        },
                        iconSize: 40,
                        icon: Icons.photo_library_outlined,
                        iconColor: AppTheme.themeColors.text,
                        backgroundColor: AppTheme.themeColors.transparent,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: UFUText(
                      text: "Camera",
                      textSize: UFUTextSize.heading4,
                      // fontFamily: UFUFontFamily.productSans,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    flex: 1,
                    child: UFUText(
                      text: "Documents",
                      textSize: UFUTextSize.heading4,
                      // fontFamily: UFUFontFamily.productSans,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  static Future<String?> pickImageFromDocuments({List<String>? allowedExtensions}) async {
    ShowUFULoader();
    String? document = await UFUtils.picker.selectDocument(allowedExtensions: allowedExtensions);
    Get.back();
    return document;
  }

  static Future<String?> pickImageFromCamera() async {
    ShowUFULoader();
    List<XFile> fileList = await UFUtils.picker.captureImageFromCamera();
    Get.back();
    return fileList.firstOrNull?.path;
  }
}