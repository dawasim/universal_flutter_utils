import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUHtmlViewer extends StatelessWidget {
  const UFUHtmlViewer({
    super.key,
    this.data,
    this.ulColor,
    this.liColor,
    this.strongColor,
    this.emColor,
    this.insColor,
    this.pColor,
    this.spanColor,
  });

  final String? data;
  final Color? ulColor;
  final Color? liColor;
  final Color? strongColor;
  final Color? emColor;
  final Color? insColor;
  final Color? pColor;
  final Color? spanColor;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data ?? "",
      style: {
        "ul": Style(
          padding: HtmlPaddings.all(0),
          color: ulColor ?? AppTheme.themeColors.text,
          textDecoration: TextDecoration.underline,
        ),
        "li": Style(
          fontSize: FontSize.medium,
          color: liColor ?? AppTheme.themeColors.text,
          padding: HtmlPaddings.symmetric(vertical: 4),
        ),
        "strong": Style(
          fontWeight: FontWeight.bold,
          color: strongColor ?? AppTheme.themeColors.text,
        ),
        "em": Style(
          fontStyle: FontStyle.italic,
          color: emColor ?? AppTheme.themeColors.text,
        ),
        "ins": Style(
          textDecoration: TextDecoration.underline,
          color: insColor ?? AppTheme.themeColors.text,
        ),
        "p": Style(
          fontSize: FontSize.medium,
          color: pColor ?? AppTheme.themeColors.text,
        ),
        "span": Style(
          fontSize: FontSize.large,
          color: spanColor ?? AppTheme.themeColors.text,
        ),
      },
    );
  }
}
