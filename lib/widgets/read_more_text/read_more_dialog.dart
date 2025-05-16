import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUReadDialog extends StatelessWidget {
  const UFUReadDialog({
    super.key, required this.text, required this.title, this.subtitle,
  });

  final String text;
  final String title;
  final String? subtitle;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AlertDialog(
          insetPadding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            padding: const EdgeInsets.only(top: 12,left:20,right: 20),
            width: UFUResponsiveDesign.maxPopOverWidth,
            constraints: BoxConstraints(
              maxHeight: UFUResponsiveDesign.maxPopOverHeight
            ),
            child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Padding(padding: const EdgeInsets.only(bottom:5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: UFUText(
                        text: title.toUpperCase(),
                        fontWeight: UFUFontWeight.medium,
                        textSize: UFUTextSize.heading3,
                        textAlign: TextAlign.start,
                        maxLine: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ), 
                    Transform.translate(
                      offset: const Offset(8, 0),
                      child: UFUTextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: AppTheme.themeColors.text,
                        icon: Icons.clear,
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
                ),
                if(subtitle != null)
                UFUText(
                  text: subtitle!,
                  textSize: UFUTextSize.heading3,
                  textAlign: TextAlign.left,
                  maxLine: 7,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.60),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children:[
                       UFUText(
                         textAlign: TextAlign.left,
                         text:text,
                         textColor: AppTheme.themeColors.tertiary),]),
                ),


              ],)
          )),
    );
  }
}
