import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUThumbIcon extends StatelessWidget {
  const UFUThumbIcon({
      this.isSelect = false,
      this.iconType = UFUThumbIconType.pdf,
      this.size,
      Key? key,
  }) : super(key: key);

  /// It is used to set icon thumb is selected or not.
  final bool isSelect;

  /// It is used to defines type of thumbIcon as [UFUThumbIconType.pdf]
  final UFUThumbIconType iconType;

  /// It is used to set size of image thumb as [ThumbSize.large]
  final ThumbSize? size;

  bool get isSmall => size == ThumbSize.small;

  String getIconText(UFUThumbIconType iconType) {
    switch (iconType) {
      case UFUThumbIconType.pdf:
        return 'PDF';
      case UFUThumbIconType.txt:
        return 'TXT';
      case UFUThumbIconType.xls:
        return 'XLS';
      case UFUThumbIconType.xlsm:
        return 'XLSM';
      case UFUThumbIconType.xlsx:
        return 'XLSX';
      case UFUThumbIconType.doc:
        return 'DOC';
      case UFUThumbIconType.docx:
        return 'DOCX';
      case UFUThumbIconType.csv:
        return 'CSV';
      case UFUThumbIconType.ppt:
        return 'PPT';
      case UFUThumbIconType.pptx:
        return 'PPTX';
      case UFUThumbIconType.zip:
        return 'ZIP';
      case UFUThumbIconType.rar:
        return 'RAR';
      case UFUThumbIconType.eml:
        return 'EML';
      case UFUThumbIconType.ai:
        return 'AI';
      case UFUThumbIconType.psd:
        return 'PSD';
      case UFUThumbIconType.ve:
        return 'VE';
      case UFUThumbIconType.eps:
        return 'EPS';
      case UFUThumbIconType.dxf:
        return 'DXF';
      case UFUThumbIconType.skp:
        return 'SKP';
      case UFUThumbIconType.ac5:
        return 'AC5';
      case UFUThumbIconType.ac6:
        return 'AC6';
      case UFUThumbIconType.sdr:
        return 'SDR';
      case UFUThumbIconType.json:
        return 'JSON';
      case UFUThumbIconType.pages:
        return 'PAGES';
      case UFUThumbIconType.numbers:
        return 'NUMBERS';
      case UFUThumbIconType.dwg:
        return 'DWG';
      case UFUThumbIconType.esx:
        return 'ESX';
      case UFUThumbIconType.sfz:
        return 'SFZ';
      case UFUThumbIconType.png:
        return 'PNG';
      case UFUThumbIconType.UFUeg:
        return 'UFUEG';
      case UFUThumbIconType.UFUg:
        return 'UFUG';
      case UFUThumbIconType.xml:
        return 'XML';
      case UFUThumbIconType.url:
        return 'URL';
      case UFUThumbIconType.html:
        return 'HTML';
      case UFUThumbIconType.hover:
        return 'HOVER';
      default:
        return 'PDF';
    }
  }

  Color getIconColor(UFUThumbIconType iconType) {
    switch (iconType) {
      case UFUThumbIconType.pdf:
        return const Color(0xffDC4437);
      case UFUThumbIconType.txt:
        return const Color(0xff1BC860);
      case UFUThumbIconType.xls:
      case UFUThumbIconType.xlsm:
      case UFUThumbIconType.xlsx:
        return const Color(0xff1E6E42);
      
      case UFUThumbIconType.ac5:
      case UFUThumbIconType.ac6:
        return const Color(0xff000000);

      case UFUThumbIconType.ai:
        return const Color(0xffB95500);    
      
      case UFUThumbIconType.csv:
        return const Color(0xff1F7246);    
      
      case UFUThumbIconType.doc:
      case UFUThumbIconType.docx:
        return const Color(0xff335599);    
      
      case UFUThumbIconType.dwg:
        return const Color(0xff7361AB);
      
      case UFUThumbIconType.dxf:
      case UFUThumbIconType.templateGroup:
        return const Color(0xff955E88);
      
      case UFUThumbIconType.eml:
        return const Color(0xff525050);
        
      case UFUThumbIconType.eps:
        return const Color(0xffFF7300);

      case UFUThumbIconType.esx:
      case UFUThumbIconType.template:
        return const Color(0xff3B70BC);
      
      case UFUThumbIconType.json:
        return const Color(0xffE77D4B);
      
      case UFUThumbIconType.numbers:
        return const Color(0xff1A72E8);
      
      case UFUThumbIconType.pages:
        return const Color(0xff1BB2DC);
      
      case UFUThumbIconType.ppt:
      case UFUThumbIconType.pptx:
        return const Color(0xffD04626);
      
      case UFUThumbIconType.psd:
      case UFUThumbIconType.hover:
        return const Color(0xff0095EF);
      
      case UFUThumbIconType.sdr:
        return const Color(0xff4B85CD);
      
      case UFUThumbIconType.sfz:
        return const Color(0xff546A7A);

      case UFUThumbIconType.skp:
        return const Color(0xffFF0000);
        
      case UFUThumbIconType.ve:
        return const Color(0xff6D6DFD);

      case UFUThumbIconType.zip:
        return const Color(0xff157EFB);
        
      case UFUThumbIconType.png:
        return const Color(0xff2A3C50);

      case UFUThumbIconType.url:
        return const Color(0xff2A3C50);

      case UFUThumbIconType.UFUeg:
      case UFUThumbIconType.UFUg:
        return const Color(0xff155994);
        
      case UFUThumbIconType.html:
        return const Color(0xffB95500);    

      default:
        return const Color(0xffDC4437);
    }
  }

  double getSize() {
    switch (size) {
      case ThumbSize.small:
        return 30;
      case ThumbSize.large:
        return 48;
      default:
        return 48;
    }
  }

  double getAssetSize() {
    switch (size) {
      case ThumbSize.small:
        return 30;
      case ThumbSize.large:
        return 120;
      default:
        return 120;
    }
  }
  
  bool doGetIconFromAsset() {
    switch (iconType) {
      case UFUThumbIconType.hover:
      case UFUThumbIconType.eagleView:
      case UFUThumbIconType.quickMeasure:
      case UFUThumbIconType.skyMeasure:
        return true;
      default:
        return false;
    }
  }

  String getAssetIcon() {
    switch (iconType) {
      case UFUThumbIconType.hover:
        return isSmall ? 'assets/images/hover/hover-logo.png' : 'assets/images/hover/hover-bg.png';
      case UFUThumbIconType.eagleView:
        return isSmall ? 'assets/images/eagleview/eagle_view.png' : 'assets/images/eagleview/evlogo.png';
      case UFUThumbIconType.skyMeasure:
        return isSmall ? 'assets/images/skymeasure/skymeasure.png' : 'assets/images/skymeasure/smlogo.png';
      case UFUThumbIconType.quickMeasure:
        return isSmall ? 'assets/images/quick_measure/quickmeasure.png' : 'assets/images/quick_measure/quickmeasure_bg.png';
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if(doGetIconFromAsset()) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: getAssetSize(),
          maxHeight: getAssetSize(),
        ),
        padding: const EdgeInsets.all(4),
        child: Center(
          child: Image.asset(
            getAssetIcon(),
          ),
        ),
      );
    }
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: getSize(),
        maxHeight: getSize(),
      ),
      decoration: BoxDecoration(
        color: (isSelect)
            ? AppTheme.themeColors.primary
            : getIconColor(iconType).withOpacity(0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: getThumbTextOrIcon(),
      ),
    );
  }

  Widget getThumbTextOrIcon() {

    switch (iconType) {
      case UFUThumbIconType.template:
        return UFUIcon(Icons.description_outlined,
          color: (isSelect) ? AppTheme.themeColors.base : getIconColor(iconType),
          size: size == ThumbSize.small ? 18 : 24,
        );

      case UFUThumbIconType.templateGroup:
        return UFUIcon(Icons.filter_none_outlined,
          color: (isSelect) ? AppTheme.themeColors.base : getIconColor(iconType),
          size: size == ThumbSize.small ? 18 : 24,
        );

      default:
        return UFUText(
          text: getIconText(iconType),
          fontWeight: UFUFontWeight.bold,
          textSize: (size == ThumbSize.small)
              ? UFUTextSize.heading6
              : UFUTextSize.heading4,
          textColor:
          (isSelect) ? AppTheme.themeColors.base : getIconColor(iconType),
        );

    }
  }
}
