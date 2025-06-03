import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUThumb extends StatelessWidget {
  const UFUThumb({
    this.type = UFUThumbType.folder,
    this.iconType = UFUThumbIconType.pdf,
    this.fileName,
    this.folderCount,
    this.thumbImage,
    this.suffixTap,
    this.suffixIcon,
    this.onTap,
    this.isDisabled = false,
    this.isSelect = false,
    this.isQuickActionIconDisabled = false,
    this.thumbIconList,
    this.statusTag,
    this.onLongPress,
    this.userName,
    this.titleBottomText = 'Uploaded by',
    super.key
  });

  /// It is used to defines type of thumb as [UFUThumbType.folder]
  final UFUThumbType type;

  /// It is used to defines type of thumbIcon as [UFUThumbIconType.pdf]
  final UFUThumbIconType iconType;

  /// It is used to set file name of a thumb.
  final String? fileName;

  /// It is used to set folder count name of a thumb.
  final String? folderCount;

  /// It is used to set image of thumbImage of a thumb.
  final Widget? thumbImage;

  /// It is used to set stages tags of a thumb.
  final Widget? statusTag;

  /// It is used to set Opacity of a thumb.
  final bool isDisabled;

  /// It is used to set thumb is selected or not.
  final bool isSelect;

  /// It is used to set more icon visible or not.
  final bool isQuickActionIconDisabled;

  /// It is used to set onTap method suffix icon.
  final ValueChanged<bool>? suffixTap;

  /// It is used to set suffix icon.
  final Widget? suffixIcon;

  /// It is used to set onTap method of Thumb.
  final ValueChanged<bool>? onTap;

  /// It is used to set list of thumb icons .
  final List<Widget>? thumbIconList;

  /// It is used when user long press on items
  final VoidCallback? onLongPress;

  // It is used to set user name.
  final String? userName;

  // It is used to show Label like created by and uploaded by.
  final String? titleBottomText;

  Widget getFolder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Stack(
          children: [
            const UFUThumbFolder(),
            (folderCount != null)
                ? Positioned(
                top: 40,
                left: 10,
                child: UFUText(
                  text: folderCount!,
                  textColor: AppTheme.themeColors.primary,
                ))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget getImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: UFUThumbImage(
        thumbImage: thumbImage,
      ),
    );
  }

  Widget getIcon() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16
      ),
      child: Center(
        child: UFUThumbIcon(
          isSelect: isSelect,
          iconType: iconType,
          size: ThumbSize.large,
        ),
      ),
    );
  }

  String getDefaultName(UFUThumbType type) {
    switch (type) {
      case UFUThumbType.folder:
        return 'Folder Name';
      case UFUThumbType.image:
        return 'image.png';
      case UFUThumbType.icon:
        return 'File Name';
      default:
        return 'Folder Name';
    }
  }

  Widget getType(UFUThumbType type) {
    switch (type) {
      case UFUThumbType.folder:
        return getFolder();
      case UFUThumbType.image:
        return getImage();
      case UFUThumbType.icon:
        return getIcon();
      default:
        return getFolder();
    }
  }

  List<Widget>? getChild() {
    List<Widget> content = [];
    for (int i = 0; i < thumbIconList!.length; i++) {
      content.add(Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: AppTheme.themeColors.darkGray,
            borderRadius: BorderRadius.circular(20),
          ),
          child: thumbIconList![i],
        ),
      ));
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: UFUColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          onTap!(isSelect);
        },
        onLongPress: onLongPress,
        child: Opacity(
          opacity: (isDisabled) ? 0.6 : 1.0,
          child: Container(
            height: 163,
            width: 163,
            decoration: BoxDecoration(
              color: (isSelect)
                  ? AppTheme.themeColors.lightBlue
                  : UFUColor.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1.0,
                color: (isSelect) ? Colors.transparent : AppTheme.themeColors.dimGray,
              ),
              boxShadow: (isSelect)
                  ? [
                BoxShadow(
                  color: AppTheme.themeColors.text.withAlpha(25),
                  blurRadius: 4.0,
                  spreadRadius: -2.0,
                  offset: const Offset(0.0, 4.0),
                ),
              ]
                  : null,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: (isSelect)
                          ? AppTheme.themeColors.lightBlue
                          : ((type == UFUThumbType.image)
                          ? AppTheme.themeColors.dimGray
                          : UFUColor.transparent),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: [
                        getType(type),
                        (thumbIconList != null)
                            ? Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              children: getChild()!,
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: statusTag ?? const SizedBox.shrink(),
                            ),
                          )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UFUText(
                              text: fileName ?? getDefaultName(type),
                              textAlign: TextAlign.left,
                              maxLine: 2,
                              textSize: UFUTextSize.heading4,
                              overflow: TextOverflow.ellipsis,
                              textColor: AppTheme.themeColors.text,
                            ),
                            if(userName != null && userName!.isNotEmpty) Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: UFUText(
                                text: '$titleBottomText: $userName',
                                textAlign: TextAlign.left,
                                maxLine: 2,
                                textSize: UFUTextSize.heading5,
                                overflow: TextOverflow.ellipsis,
                                textColor: AppTheme.themeColors.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      suffixIcon ?? (isSelect ? getSuffixIcon() : isQuickActionIconDisabled ? const SizedBox(height: 29, width: 29,) : getSuffixIcon()),
                      const SizedBox(width: 8,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSuffixIcon() => UFUTextButton(
    padding: 3,
    iconSize: 22,
    onPressed: () => suffixTap!(isSelect),
    color: isSelect ? AppTheme.themeColors.primary : AppTheme.themeColors.text,
    icon: isSelect ? Icons.check_circle : Icons.more_horiz,
  );
}
