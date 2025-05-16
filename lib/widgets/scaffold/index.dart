import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../utils/index.dart';


class UFUScaffold extends StatelessWidget {
  const UFUScaffold({
    super.key,
    this.backgroundDecoration,
    this.appBar,
    this.drawer,
    this.body,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.bottomSheet,
  });

  final BoxDecoration? backgroundDecoration;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? body;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UFUtils.commonMethods.hideKeyboard(),
      child: Container(
        decoration: backgroundDecoration ?? BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0XFF551600), AppTheme.themeColors.themeBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.5],
          ),
        ),
        child: Scaffold(
          backgroundColor: AppTheme.themeColors.transparent,
          appBar: appBar,
          drawer: drawer,
          body: body,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
        ),
      ),
    );
  }
}