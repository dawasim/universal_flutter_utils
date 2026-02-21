//MIT License

//Copyright (c) 2019 Jonny Borges

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';


enum TrimMode {
  length,
  line,
}

class UFUReadMoreText extends StatefulWidget {
  const UFUReadMoreText(
    this.text, {
    super.key,
    this.trimExpandedText = 'less',
    this.trimCollapsedText = 'read more',
    this.trimLength = 250,
    this.trimLines = 3,
    this.trimMode = TrimMode.line,
    this.textAlign = TextAlign.start,
    this.dialogTitle,
    this.dialogSubTitle,
    this.dialogDescriptionColor,
    this.textDirection,
    this.semanticsLabel,
    this.delimiter = '$ellipsisChar ',
    this.callback,
    this.textSize = UFUTextSize.heading4,
    // this.fontFamily = UFUFontFamily.productSans,
    this.fontWeight = UFUFontWeight.regular,
    this.textColor,
    this.height,
    this.showDialogOnReadMore = false,
  });

  /// Used on TrimMode.Length
  final int trimLength;

  /// Used on TrimMode.Lines
  final int trimLines;

  /// Determines the type of trim. TrimMode.Length takes into account
  /// the number of letters, while TrimMode.Lines takes into account
  /// the number of lines
  final TrimMode trimMode;

  ///Called when state change between expanded/compress
  final Function(bool val)? callback;

  final String delimiter;
  final String text;
  final String? dialogTitle;
  final String? dialogSubTitle;
  final Color? dialogDescriptionColor;
  final String trimExpandedText;
  final String trimCollapsedText;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final String? semanticsLabel;

  final UFUTextSize textSize;
  // final UFUFontFamily fontFamily;
  
  final UFUFontWeight fontWeight;
  final Color? textColor;
  final double? height;
  final bool? showDialogOnReadMore;

  @override
  UFUReadMoreTextState createState() => UFUReadMoreTextState();
}

const String ellipsisChar = '\u2026';

const String lineSeparator = '\u2028';

class UFUReadMoreTextState extends State<UFUReadMoreText> {
  bool isReadMore = true;
  

  void _onTapLink() {
    setState(() {
      if((widget.text.length>250&&widget.text.length<500) && !(widget.showDialogOnReadMore!)) {
         isReadMore = !isReadMore;
      widget.callback?.call(isReadMore);
      }
      else
      {
        showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return !UFUScreen.isTablet ? Animations.fromBottom(animation, secondaryAnimation, child) : child;
        }, 
        pageBuilder:(animation, secondaryAnimation, child) {
          return UFUReadDialog(text: widget.text, title: widget.dialogTitle ?? 'Title', subtitle: widget.dialogSubTitle);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    final textDirection = widget.textDirection ?? Directionality.of(context);
    final overflow = defaultTextStyle.overflow;

    TextSpan link = UFUTextSpan.getSpan(
      isReadMore ? widget.trimCollapsedText.capitalize() : widget.trimExpandedText.capitalize(),
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
      textColor: AppTheme.themeColors.primary,
      fontStyle: FontStyle.italic,
      textSize: widget.textSize
    );

    TextSpan delimiter = UFUTextSpan.getSpan(
      isReadMore ? widget.trimCollapsedText.isNotEmpty ? widget.delimiter : '' : '',
      recognizer: TapGestureRecognizer()..onTap = _onTapLink,
      fontStyle: FontStyle.italic
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        // Create a TextSpan with text
        final text = UFUTextSpan.getSpan(
          widget.text,
          textColor: widget.textColor,
          textSize: widget.textSize,
          // fontFamily: widget.fontFamily,
          fontWeight: widget.fontWeight
        );

        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: widget.textAlign,
          textDirection: textDirection,
          maxLines: widget.trimLines,
          ellipsis: overflow == TextOverflow.ellipsis ? widget.delimiter : null,
        );
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        // Layout and measure delimiter
        textPainter.text = delimiter;
        textPainter.layout(minWidth: 0, maxWidth: maxWidth);
        final delimiterSize = textPainter.size;

        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        // Get the endIndex of text
        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final readMoreSize = linkSize.width + delimiterSize.width;
          final pos = textPainter.getPositionForOffset(Offset(
            textDirection == TextDirection.rtl
                ? readMoreSize
                : textSize.width - readMoreSize,
            textSize.height,
          ));
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          var pos = textPainter.getPositionForOffset(
            textSize.bottomLeft(Offset.zero),
          );
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }

        TextSpan textSpan;
        switch (widget.trimMode) {
          case TrimMode.length:
            if (widget.trimLength < widget.text.length) {
              textSpan = UFUTextSpan.getSpan(
                isReadMore
                    ? widget.text.substring(0, widget.trimLength)
                    : widget.text,
                children: <TextSpan>[delimiter, link],
                textColor: widget.textColor,
                textSize: widget.textSize,
                // fontFamily: widget.fontFamily,
                fontWeight: widget.fontWeight,
                 height: widget.height
              );
            } else {
              textSpan = UFUTextSpan.getSpan(
                widget.text,
                textColor: widget.textColor,
                textSize: widget.textSize,
                // fontFamily: widget.fontFamily,
                fontWeight: widget.fontWeight,
                height: widget.height
              );
            }
            break;
          case TrimMode.line:
            if (textPainter.didExceedMaxLines) {
              textSpan = UFUTextSpan.getSpan(
                isReadMore
                    ? widget.text.substring(0, endIndex) +
                        (linkLongerThanLine ? lineSeparator : '')
                    : '${widget.text} ',
                children: <TextSpan>[delimiter, link],
                textColor: widget.textColor,
                textSize: widget.textSize,
                // fontFamily: widget.fontFamily,
                fontWeight: widget.fontWeight,
                height: widget.height
              );
            } else {
              textSpan = UFUTextSpan.getSpan(
                widget.text,
                textColor: widget.textColor,
                // fontFamily: widget.fontFamily,
                fontWeight: widget.fontWeight,
                textSize: widget.textSize,
                height: widget.height
              );
            }
            break;
          // default:
          //   throw Exception('TrimMode type: ${widget.trimMode} is not supported');
        }

        return RichText(
          textAlign: widget.textAlign,
          textDirection: textDirection,
          softWrap: true,
          //softWrap,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }
}