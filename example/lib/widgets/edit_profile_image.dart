import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/api_config/api_config.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileImageController>(
      global: false,
      init: EditProfileImageController(),
      builder: (controller) => UFUScaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.themeColors.base,
          centerTitle: true,
          title: UFUText(text: "Profile", textSize: UFUTextSize.heading1,),
          leading: UFUIconButton(
            onTap: () => Get.back(),
            backgroundColor: AppTheme.themeColors.transparent,
            icon: Icons.arrow_back_ios,
            iconColor: AppTheme.themeColors.text,
            iconSize: 24,
          ),
        ),
        body: Obx(() => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 50),
              Stack(
                children: [
                  Center(
                    child: Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        border: UFUDashedBorder.fromBorderSide(
                          dashLength: 3,
                          side: BorderSide(
                            color: AppTheme.themeColors.primary,
                            width: 1
                          )
                        ),
                        borderRadius: BorderRadius.circular(70)
                      ),
                      padding: const EdgeInsets.all(1),
                      child: UFUAvatar(
                        size: UFUAvatarSize.extraLarge,
                        isDashedBorder: true,
                        dashLength: 3,
                        borderWidth: 1,
                        child: UFUNetworkImage(
                          src: controller.profileImage.value,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 135,
                      width: 120,
                      alignment: Alignment.bottomRight,
                      child: UFUIconButton(
                        onTap: controller.selectImage,
                        backgroundColor: AppTheme.themeColors.transparent,
                        icon: Icons.camera_alt_rounded,
                        iconSize: 30,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: UFUInputBox(
                      disabled: controller.isEdit.isFalse,
                      hintText: "First Name",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: UFUInputBox(
                      disabled: controller.isEdit.isFalse,
                      hintText: "Last Name",
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              UFUInputBox(
                disabled: controller.isEdit.isFalse,
                hintText: "Phone Number",
              ),
              SizedBox(height: 10),
              UFUInputBox(
                disabled: controller.isEdit.isFalse,
                hintText: "E-Mail",
              ),
              if(controller.isEdit.isTrue) ...[
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(flex: 1,
                      child: UFUButton(colorType: UFUButtonColorType.lightGray,
                      text: "Cancel", onPressed: controller.toggleIsEdit
                    )),
                    SizedBox(width: 10),
                    Expanded(flex: 1,
                      child: UFUButton(text: "Edit", onPressed: () {}
                    )),
                  ],
                ),
              ],
              SizedBox(height: controller.isEdit.isTrue ? 20 : 50),
              UFUButton(text: "Log Out", onPressed: () {}),
            ],
          ),
        )),
      ),
    );
  }
}

class EditProfileImageController extends GetxController {
  RxString profileImage = "".obs;
  RxBool isEdit = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    String? token = await UFUtils.preferences.readAuthToken();
    print(token);
  }

  void toggleIsEdit() => isEdit.value = !isEdit.value;

  Future<void> selectImage() async {
    String? filepath = await UFUImagePicker.show();

    try {
      ShowUFULoader(msg: "Uploading Image");

      if(filepath?.isNotEmpty ?? false) {
        Map<String, dynamic>? response = await UFApiConfig().uploadFile(
            path: "upload-photo/",
            fileParam: "image",
            file: File(filepath!),
            data: {"category" : "profile"}
        );

        if(response?["data"] != null) {
          profileImage.value = response?["data"]?["image_url"] ?? "";
          if(profileImage.value.isNotEmpty) {
            profileImage.value = "http://aapkedukan.in:8000/${profileImage.value}";
          }
        }
        Get.back();
      }
      update();
    } catch(e) {
      Get.back();
      UFUtils.handleError(e);
    }
  }

  void logOut() {
    UFUtils.preferences.clearPref();
  }


}
