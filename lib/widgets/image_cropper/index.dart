import 'dart:io';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:path_provider/path_provider.dart';

enum UFUImageCropRatio { ratio16x7, ratio1x1, ratio5x3 }
enum UFUImageCropShape { circle, square, ratio, }

class UFUImageCropper extends StatefulWidget {
  final String imagePath;
  final UFUImageCropRatio cropRatio;
  final UFUImageCropShape cropShape;

  const UFUImageCropper({super.key,
    required this.imagePath,
    required this.cropRatio,
    required this.cropShape,
  });

  @override
  UFUImageCropperState createState() => UFUImageCropperState();
}

class UFUImageCropperState extends State<UFUImageCropper> {
  late CustomImageCropController controller;
  CustomCropShape _currentShape = CustomCropShape.Circle;
  final CustomImageFit _imageFit = CustomImageFit.fillCropSpace;

  double _width = 16;
  double _height = 9;
  final double _radius = 4;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();

    switch(widget.cropShape) {
      case UFUImageCropShape.circle:
        _currentShape = CustomCropShape.Circle;
        break;
      case UFUImageCropShape.square:
        _currentShape = CustomCropShape.Square;
        break;
      case UFUImageCropShape.ratio:
        _currentShape = CustomCropShape.Ratio;
        break;
    }

    switch(widget.cropRatio) {
      case UFUImageCropRatio.ratio16x7:
        _width = 16;
        _height = 7;
        break;

      case UFUImageCropRatio.ratio1x1:
        _width = 1;
        _height = 1;
        break;

      case UFUImageCropRatio.ratio5x3:
        _width = 5;
        _height = 3;
        break;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: UFUText(
          text: "Adjust to Fit",
          textSize: UFUTextSize.heading3,
          textColor: AppTheme.themeColors.primary,
          fontWeight: UFUFontWeight.semiBold,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close, size: 24, color: AppTheme.themeColors.primary),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
              cropController: controller,
              image: FileImage(File(widget.imagePath)),
              shape: _currentShape,
              ratio: _currentShape == CustomCropShape.Ratio
                  ? Ratio(width: _width, height: _height)
                  : null,
              canRotate: false,
              canMove: true,
              canScale: true,
              outlineStrokeWidth: 2,
              borderRadius: _currentShape == CustomCropShape.Ratio ? _radius : 0,
              customProgressIndicator: const CupertinoActivityIndicator(),
              outlineColor: AppTheme.themeColors.primary,
              imageFit: _imageFit,
              // imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: UFUButton(
              text: "Save".tr,
              onPressed: () async {
                ShowUFULoader();
                final image = await controller.onCropImage();
                if (image != null) {
                  File file = await flipImage(image.bytes, horizontal: true);
                  UFUtils.hideLoaderDialog();
                  Future.delayed(const Duration(milliseconds: 300), () => Get.back(result: file.path));
                }
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Future<File> flipImage(Uint8List imageBytes, {bool horizontal = true}) async {
    File flippedFile;
    Directory downloadsDir = await getApplicationDocumentsDirectory();
    String newPath = "${downloadsDir.path}/${widget.imagePath.split("/").last}";
    flippedFile = File(newPath)..writeAsBytesSync(imageBytes);
    return flippedFile;
  }

}