import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/theme/form_ui_helper.dart';
import 'package:universal_flutter_utils/theme/theme_colors.dart';
import 'package:universal_flutter_utils/theme/theme_model.dart';

class AppTheme {
  static ThemeModel themeData = ThemeModel(
    colors: ThemeColors.light(),
    formUiHelper: FormUiHelper(),
  );

  static void setTheme(bool isDark) {
    if (isDark) {
      themeData = ThemeModel(
          colors: ThemeColors.dark(),
          formUiHelper: FormUiHelper()
      );
    } else {
      themeData = ThemeModel(
          colors: ThemeColors.light(),
          formUiHelper: FormUiHelper()
      );
    }
  }

  static ThemeColors get themeColors {
    return themeData.colors;
  }

  static FormUiHelper get formUiHelper {
    return themeData.formUiHelper;
  }

  // Method to set custom colors for the app theme
  static void setThemeColors({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? inverse,
    Color? text,
    Color? secondaryText,
    Color? success,
    Color? warning,
    Color? dimGray,
    Color? darkGray,
    Color? lightBlue,
    Color? purple,
    Color? dimBlack,
    Color? lightGrassGreen,
    Color? grassGreen,
    Color? lightFoam,
    Color? foam,
    Color? lightBrown,
    Color? brown,
    Color? lightWildBlue,
    Color? wildBlue,
    Color? lightYellow,
    Color? yellow,
    Color? lightRed,
    Color? darkRed,
    Color? lemon,
    Color? darkYellow,
    Color? mintGreen,
    Color? oliveGreen,
    Color? darkPurple,
    Color? lightPurple,
    Color? uranianBlue,
    Color? gradientBlue,
    Color? cornFlowerBlue,
    Color? draft,
    Color? lightestGray,
    Color? dimRed,
    Color? tealGreen,
    Color? royalBlue,
    Color? themeBlack,
    Color? themeGreen,
    Color? themeBlue,
    Color? red,
  }) {
    if (primary != null) themeData.colors.primary = primary;
    if (secondary != null) themeData.colors.secondary = secondary;
    if (tertiary != null) themeData.colors.tertiary = tertiary;
    if (inverse != null) themeData.colors.inverse = inverse;
    if (text != null) themeData.colors.text = text;
    if (secondaryText != null) themeData.colors.secondaryText = secondaryText;
    if (success != null) themeData.colors.success = success;
    if (warning != null) themeData.colors.warning = warning;
    if (dimGray != null) themeData.colors.dimGray = dimGray;
    if (darkGray != null) themeData.colors.darkGray = darkGray;
    if (lightBlue != null) themeData.colors.lightBlue = lightBlue;
    if (purple != null) themeData.colors.purple = purple;
    if (dimBlack != null) themeData.colors.dimBlack = dimBlack;
    if (lightGrassGreen != null) themeData.colors.lightGrassGreen = lightGrassGreen;
    if (grassGreen != null) themeData.colors.grassGreen = grassGreen;
    if (lightFoam != null) themeData.colors.lightFoam = lightFoam;
    if (foam != null) themeData.colors.foam = foam;
    if (lightBrown != null) themeData.colors.lightBrown = lightBrown;
    if (brown != null) themeData.colors.brown = brown;
    if (lightWildBlue != null) themeData.colors.lightWildBlue = lightWildBlue;
    if (wildBlue != null) themeData.colors.wildBlue = wildBlue;
    if (lightYellow != null) themeData.colors.lightYellow = lightYellow;
    if (yellow != null) themeData.colors.yellow = yellow;
    if (lightRed != null) themeData.colors.lightRed = lightRed;
    if (darkRed != null) themeData.colors.darkRed = darkRed;
    if (lemon != null) themeData.colors.lemon = lemon;
    if (darkYellow != null) themeData.colors.darkYellow = darkYellow;
    if (mintGreen != null) themeData.colors.mintGreen = mintGreen;
    if (oliveGreen != null) themeData.colors.oliveGreen = oliveGreen;
    if (darkPurple != null) themeData.colors.darkPurple = darkPurple;
    if (lightPurple != null) themeData.colors.lightPurple = lightPurple;
    if (uranianBlue != null) themeData.colors.uranianBlue = uranianBlue;
    if (cornFlowerBlue != null) themeData.colors.cornFlowerBlue = cornFlowerBlue;
    if (gradientBlue != null) themeData.colors.gradientBlue = gradientBlue;
    if (draft != null) themeData.colors.draft = draft;
    if (lightestGray != null) themeData.colors.lightestGray = lightestGray;
    if (dimRed != null) themeData.colors.dimRed = dimRed;
    if (tealGreen != null) themeData.colors.tealGreen = tealGreen;
    if (royalBlue != null) themeData.colors.royalBlue = royalBlue;
    if (themeBlack != null) themeData.colors.themeBlack = themeBlack;
    if (themeGreen != null) themeData.colors.themeGreen = themeGreen;
    if (themeBlue != null) themeData.colors.themeBlue = themeBlue;
    if (red != null) themeData.colors.red = red;
  }
}
