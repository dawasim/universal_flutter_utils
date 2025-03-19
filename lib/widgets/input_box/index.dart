import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class UFUInputBox extends StatefulWidget {
  const UFUInputBox({
    this.label,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.disabled = false,
    this.focusNode,
    this.autofocus = false,
    this.hintText,
    this.prefixChild,
    this.suffixChild,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.onPressed,
    this.debounceTime,
    this.autoGrow = false,
    this.type = UFUInputBoxType.withoutLabel,
    this.fillColor,
    this.labelBgColor,
    this.cursorWidth = 1.5,
    this.cursorHeight,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(8.0),
    this.scrollPhysics,
    this.enableSuggestions = false,
    this.inputFormatters,
    this.cancelButtonColor,
    this.cancelButtonSize,
    this.padding,
    this.textSize = UFUTextSize.heading4,
    this.onTapSuffix,
    this.borderColor,
    this.isCounterText = false,
    this.inputBoxController,
    this.chip,
    this.chipsList,
    this.moreChipsWidget,
    this.isRequired = false,
    this.avoidPrefixConstraints = false,
    this.isExtWidget = false,
    this.extInputBoxController,
    this.prefixIconConstraints,
    this.showCursor,
    this.textColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.top,
    this.textCapitalization = TextCapitalization.sentences,
    super.key});

  /// It is required to add label of a inputBox.
  final String? label;

  /// It is use to get value from inputBox.
  final TextEditingController? controller;

  /// It is use to change keyboardType of inputBox.
  final TextInputType? keyboardType;

  /// Defines inputBox is writeable or readOnly.
  final bool readOnly;

  /// Defines inputBox text should be secure or not(For password field).
  final bool obscureText;

  /// Defines maxLines of input value of inputBox.
  final int? maxLines;

  /// Defines maxLength of input value of inputBox.
  final int? maxLength;

  /// It is use to set inputBox enabled or disabled.
  final bool disabled;

  /// It is use to get focus of a inputBox.
  final FocusNode? focusNode;

  /// It is use to get autofocus or not in a inputBox.
  final bool autofocus;

  /// It is use to set  hintText of inputBox.
  final String? hintText;

  /// It is use as prefixChild of inputBox.
  /// like... Icon(Icons.lock);
  final Widget? prefixChild;

  /// Defines suffixChild of inputBox.
  /// like... Icon(Icons.lock);
  final Widget? suffixChild;

  /// Use to save values into parent controller of inputBox.
  /// (value){controller.email = value!;},
  final FormFieldSetter<dynamic>? onSaved;

  /// Use to validate values of inputBox.
  final FormFieldValidator<dynamic>? validator;

  /// This method is called when inputBox value get changed of inputBox.
  final ValueChanged<String>? onChanged;

  /// It is use to set method of inputBox.
  final VoidCallback? onPressed;

  /// we used it when we debounce.
  /// We give time in milliseconds.
  final int? debounceTime;

  final bool autoGrow;

  final UFUInputBoxType type;

  final bool? showCursor;

  /// filledColor can be used to give background color to text field
  /// in case field is disabled default color will be [AppTheme.themeColors.dimGray]
  final Color? fillColor;

  final Color? labelBgColor;

  final double cursorWidth;

  final double? cursorHeight;

  final bool enableSuggestions;

  final ScrollController? scrollController;

  final ScrollPhysics? scrollPhysics;

  final EdgeInsets scrollPadding;

  ///   For masking content
  final List<TextInputFormatter>? inputFormatters;

  /// cancelButtonSize is used to adjust cancel button size, default size [22]
  final double? cancelButtonSize;

  /// cancelButtonSize is used to adjust cancel button color
  final Color? cancelButtonColor;

  /// padding is used to adjust text field padding
  final EdgeInsets? padding;

  /// textSize is used to adjust textField text size, default value is [UFUTextSize.heading4]
  final UFUTextSize textSize;

  /// onTapSuffix will handle tap on suffix icon
  final VoidCallback? onTapSuffix;

  /// use to give border color to text field
  final Color? borderColor;

  final bool isCounterText;

  final TextCapitalization textCapitalization;

  final UFUInputBoxController? inputBoxController;

  final Widget Function(dynamic)? chip;

  final List<dynamic>? chipsList;

  final Widget? moreChipsWidget;

  final bool? isRequired;

  final bool avoidPrefixConstraints;

  final bool isExtWidget;

  final UFUInputBoxController? extInputBoxController;

  /// [prefixIconConstraints] can be used to give customised constraints to prefix icon
  final BoxConstraints? prefixIconConstraints;

  final Color? textColor;

  final TextAlign? textAlign;

  final TextAlignVertical? textAlignVertical;

  @override
  _UFUInputBoxState createState() => _UFUInputBoxState();
}

class _UFUInputBoxState extends State<UFUInputBox> {
  FocusNode focusNode = FocusNode();
  bool showClearButton = false;
  String errorText = '';
  int chracterCount = 0;
  double scale = 1;
  late Debounce debounce =
  Debounce(Duration(milliseconds: widget.debounceTime!));
  late UFUInputBoxController inputBoxController;
  late UFUInputBoxController extInputBoxController;

  bool get showChips => widget.chip != null && widget.chipsList != null;

  bool get isLabelOutside => widget.type == UFUInputBoxType.withLabelOutside;

  /// Default text style for label and hint text.
  TextStyle getStyle() {
    return TextStyle(
      fontFamily: 'Roboto',
      package: 'UFU_mobile_flutter_ui',
      fontWeight: widget.type == UFUInputBoxType.withoutLabel
          ? FontWeight.w500
          : FontWeight.w400,
      height: 1.2,
      fontSize: TextHelper.getTextSize(widget.textSize),
    );
  }

  void setClearButtonState(String value) {
    setState(() {
      showClearButton = value
          .trim()
          .isEmpty ? false : true;
    });
  }

  void getOnChanged(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
      setClearButtonState(value.trim());
      if (inputBoxController.validateOnChange) {
        validateField(value);
      }
    }
  }

  /// prefix clear button in search bar for clearing inputBox.
  Widget getClearButton() {
    if (!showClearButton) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(right: widget.padding?.right ?? 12, left: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        child: widget.suffixChild ??
            UFUInputBoxClearIcon(
              type: widget.type,
              cancelButtonColor: widget.cancelButtonColor,
              cancelButtonSize: widget.cancelButtonSize,
            ),
        onTap: () {
          if (widget.onTapSuffix != null) {
            widget.onTapSuffix!();
          } else {
            inputBoxController.controller.clear();
            if (widget.onChanged != null) widget.onChanged!("");
            setClearButtonState("");
          }
        },
      ),
    );
  }

  String getLabelText() {
    if (!doShowLabel()) {
      return '';
    }
    return widget.label ?? '';
  }

  Widget getLabel() =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isLabelOutside ? 0 : 12,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: (widget.isRequired! ? 10 : 8) * scale,
                  color: widget.labelBgColor ?? AppTheme.themeColors.base,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 3,
                  left: 4,
                  bottom: 1.5 * scale
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: UFUText(
                      text: getLabelText(),
                      maxLine: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      height: 0,
                      textSize: isLabelOutside
                          ? UFUTextSize.heading3
                          : UFUTextSize.heading5,
                      fontWeight: isLabelOutside
                          ? UFUFontWeight.bold
                          : UFUFontWeight.regular,
                    ),
                  ),
                  if(widget.isRequired! && !isLabelOutside)
                    UFUText(
                      text: ' *',
                      maxLine: 1,
                      textAlign: TextAlign.start,
                      textColor: AppTheme.themeColors.red,
                      overflow: TextOverflow.ellipsis,
                      textSize: UFUTextSize.heading4,
                    ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();

    inputBoxController = widget.inputBoxController ?? UFUInputBoxController();
    inputBoxController.setParentController(widget.controller);
    inputBoxController.setParentFocusNode(widget.focusNode);
    inputBoxController.setValidator(validateField);

    extInputBoxController =
        widget.extInputBoxController ?? UFUInputBoxController();
    extInputBoxController.setParentController(widget.controller);

    if (inputBoxController.validateOnChange) {
      validateField(inputBoxController.text);
    }

    if (doShowClearIcon() && widget.controller != null) {
      // in case initial text is not empty text field should display cancel icon
      // as listener will work only while text field will be focused or updated
      showClearButton = inputBoxController.controller.text.isNotEmpty;

      inputBoxController.controller.addListener(() {
        if (mounted) {
          setState(() {
            showClearButton = inputBoxController.controller.text.isNotEmpty;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant UFUInputBox oldWidget) {
    if (widget.controller?.text != null
        && widget.controller?.text != inputBoxController.text
        && widget.inputBoxController == null) {
      inputBoxController.text = widget.controller?.text ?? "";
    }
    if (widget.controller?.text != null
        && widget.controller?.text != extInputBoxController.text
        && widget.extInputBoxController == null) {
      extInputBoxController.text = widget.controller?.text ?? "";
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    scale = MediaQuery
        .of(context)
        .textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: inputBoxController.key,
      children: [
        if (widget.type == UFUInputBoxType.withLabelOutside) ...{
          getLabel(),
          const SizedBox(height: 10),
          textFormField(),
        } else
          ...{
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: doShowLabel() ? scale * 8 : 0),
                  child: textFormField(),
                ),
                if (doShowLabel()) getLabel(),
              ],
            ),
          },
        errorText.isNotEmpty
            ? const SizedBox(height: 5)
            : const SizedBox.shrink(),
        errorText.isEmpty || widget.type == UFUInputBoxType.searchbar
            ? const SizedBox.shrink()
            : Align(
          alignment: Alignment.topLeft,
          child: UFUText(
            textAlign: TextAlign.start,
            text: errorText,
            textSize: UFUTextSize.heading5,
            textColor: AppTheme.themeColors.red,
          ),
        )
      ],
    );
  }

  Widget textFormField() {
    return Material(
      borderRadius: BorderRadius.circular(
        getBorderRadius(),
      ),
      color: widget.disabled
          ? AppTheme.themeColors.inverse.withValues(alpha: 0.6)
          : widget.fillColor ?? AppTheme.themeColors.base,
      child: TextFormField(

        textCapitalization: widget.textCapitalization,
        keyboardAppearance: MediaQuery
            .of(context)
            .platformBrightness,
        showCursor: widget.readOnly ? false : widget.showCursor ?? true,
        onChanged: (value) {
          if (widget.debounceTime != null &&
              (widget.type == UFUInputBoxType.searchbar ||
                  widget.type ==
                      UFUInputBoxType.searchbarWithoutBorder)) {
            debounce(() {
              getOnChanged(value);
            });
          } else {
            getOnChanged(value);
          }
        },
        controller: showChips ? null : inputBoxController.controller,
        onTap: widget.onPressed,
        validator: validateField,
        textAlign: widget.textAlign ?? TextAlign.start,
        textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.top,
        onSaved: widget.onSaved,
        keyboardType: widget.autoGrow
            ? TextInputType.multiline
            : widget.keyboardType,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        minLines: widget.autoGrow ? 1 : null,
        maxLines: widget.maxLines,
        cursorColor: (widget.type == UFUInputBoxType.searchbar ||
            widget.type == UFUInputBoxType.composeEmail)
            ? AppTheme.themeColors.text
            : AppTheme.themeColors.primary,
        maxLength: widget.maxLength,
        enabled: !widget.disabled,
        cursorHeight: widget.cursorHeight,
        scrollController: widget.scrollController,
        scrollPadding: widget.scrollPadding,
        scrollPhysics: widget.scrollPhysics,
        enableSuggestions: widget.enableSuggestions,
        cursorWidth: widget.cursorWidth,
        focusNode: inputBoxController.focusNode,
        autofocus: widget.autofocus,
        style: getStyle().copyWith(
          color: widget.textColor ?? AppTheme.themeColors.text
              .withValues(alpha: widget.disabled ? 0.4 : 1),
          fontSize: TextHelper.getTextSize(widget.textSize),
        ),
        decoration: InputDecoration(
          counterStyle: const TextStyle(
            height: 0,
          ),
          counterText: (!widget.isCounterText && widget.maxLength != null)
              ? ''
              : null,
          border: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.themeColors.inverse, width: 1.5),
          ),
          filled: widget.disabled || widget.fillColor != null,
          fillColor: widget.disabled ? UFUColor.lightGray : widget.fillColor ??
              AppTheme.themeColors.base,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: getInActiveBorder(),
          disabledBorder: getInActiveBorder(),
          focusedBorder: getActiveBorder(),
          focusedErrorBorder: getInActiveBorder(),
          errorBorder: getInActiveBorder(),
          contentPadding: getContentPadding(),
          isCollapsed: true,
          isDense: widget.type == UFUInputBoxType.inline,
          hintText: widget.hintText,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          hintStyle: getStyle().copyWith(
              color: widget.type == UFUInputBoxType.composeEmail ?
              AppTheme.themeColors.tertiary :
              AppTheme.themeColors.text.withValues(alpha: 0.3),
              fontSize: typeToHintFontSize(),
              letterSpacing: 0
          ),
          errorStyle: const TextStyle(
            fontSize: 0.01,
          ),
          prefixIconConstraints: widget.prefixIconConstraints
              ?? (showChips || widget.avoidPrefixConstraints
                  ? null
                  : const BoxConstraints(maxWidth: 40, maxHeight: 20)),
          prefixIcon: getPrefixChild(),
          suffixIcon: getSuffixChild(),
          suffixIconConstraints: const BoxConstraints(maxHeight: 40),
        ),
        inputFormatters: widget.inputFormatters,
      ),
    );
  }

  InputBorder getInActiveBorder() {
    if (widget.type == UFUInputBoxType.searchbarWithoutBorder
        || widget.type == UFUInputBoxType.composeEmail
        || widget.type == UFUInputBoxType.inline
    ) {
      return InputBorder.none;
    } else {
      return OutlineInputBorder(
        gapPadding: 0,
        borderRadius: (widget.type == UFUInputBoxType.searchbar)
            ? BorderRadius.circular(12.0)
            : BorderRadius.circular(14.0),
        borderSide: BorderSide(
            width: 0.8,
            color:
            widget.borderColor ?? (errorText.isNotEmpty &&
                widget.type != UFUInputBoxType.searchbar
                ? AppTheme.themeColors.red.withValues(alpha: 0.4)
                : AppTheme.themeColors.dimGray)),
      );
    }
  }

  InputBorder getActiveBorder() {
    if (widget.type == UFUInputBoxType.searchbarWithoutBorder
        || widget.type == UFUInputBoxType.composeEmail
        || widget.type == UFUInputBoxType.inline
    ) {
      return InputBorder.none;
    } else {
      return OutlineInputBorder(
        gapPadding: 0,
        borderRadius: (widget.type == UFUInputBoxType.searchbar)
            ? BorderRadius.circular(12.0)
            : BorderRadius.circular(14.0),
        borderSide: BorderSide(
          width: 0.8,
          color: widget.borderColor ??
              ((widget.type == UFUInputBoxType.searchbar)
                  ? AppTheme.themeColors.dimGray
                  : AppTheme.themeColors.primary),
        ),
      );
    }
  }

  EdgeInsets getContentPadding() {
    if (widget.type == UFUInputBoxType.inline) {
      return const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6
      );
    }

    return EdgeInsets.only(
      left: getHorizontalPadding(),
      right: widget.suffixChild != null ? 0 : getHorizontalPadding(),
      top: getVerticalPadding(),
      bottom: getVerticalPadding(),
    );
  }

  double getVerticalPadding() {
    if (doShowLabel()) {
      return widget.padding?.vertical ?? 13;
    }

    switch (widget.type) {
      case UFUInputBoxType.withoutLabel:
        return 16;
      case UFUInputBoxType.composeEmail:
        return 15;
      default:
        return widget.padding?.vertical ?? 13;
    }
  }

  double getHorizontalPadding() {
    if (widget.type == UFUInputBoxType.searchbar || widget.isExtWidget) {
      if (showClearButton) return 0;
      return 6;
    }
    if (widget.type == UFUInputBoxType.composeEmail) {
      return 16;
    }
    return widget.padding?.horizontal ?? 15;
  }

  bool doShowLabel() {
    return (widget.type == UFUInputBoxType.withLabel ||
        widget.type == UFUInputBoxType.withLabelOutside ||
        widget.type == UFUInputBoxType.withLabelAndClearIcon) &&
        widget.label != null;
  }

  Widget? getSuffixChild() {
    if (doShowClearIcon()) {
      return getClearButton();
    } else if (widget.isExtWidget) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: UFUColor.lightGray,
          ),
          constraints: const BoxConstraints(maxWidth: 80),
          child: TextFormField(
            keyboardAppearance: MediaQuery
                .of(context)
                .platformBrightness,
            onChanged: (value) {
              widget.onChanged!(value);
            },
            textCapitalization: widget.textCapitalization,
            controller: extInputBoxController.controller,
            maxLength: 12,
            style: getStyle().copyWith(
              color: widget.textColor ?? AppTheme.themeColors.text.withValues(
                  alpha: widget.disabled ? 0.4 : 1),
              fontSize: TextHelper.getTextSize(UFUTextSize.heading5),
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 2),
                counterText: '',
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0),
                ),
                hintText: 'Ext',
                hintStyle: getStyle().copyWith(
                    color: AppTheme.themeColors.text.withValues(alpha: 0.3),
                    fontSize: 14.0,
                    letterSpacing: 0,
                    height: 0
                ),
                fillColor: UFUColor.lightGray
            ),
          ),
        ),
      );
    } else {
      return widget.suffixChild;
    }
  }

  Widget? getPrefixChild() {
    if (widget.type == UFUInputBoxType.searchbar) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 6,
        ),
        child: widget.prefixChild ??
            UFUIcon(
              Icons.search,
              color: AppTheme.themeColors.dimGray,
              size: 25,
            ),
      );
    } else if (showChips) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 42,
            bottom: 12
        ),
        child: Wrap(
          runSpacing: 8,
          spacing: 8,
          children: List.generate(
              widget.chipsList!.length > 5 ? 6 : widget.chipsList!.length, (
              index) {
            if (index < 5) {
              return widget.chip!(widget.chipsList![index]);
            } else {
              return widget.moreChipsWidget ?? const SizedBox();
            }
          }),
        ),
      );
    } else {
      return widget.prefixChild;
    }
  }

  double getBorderRadius() {
    switch (widget.type) {
      case UFUInputBoxType.searchbar:
        return 12;

      case UFUInputBoxType.inline:
        return 4;

      default:
        return 8;
    }
  }

  bool doShowClearIcon() =>
      widget.type == UFUInputBoxType.searchbar ||
          widget.type == UFUInputBoxType.searchbarWithoutBorder ||
          widget.type == UFUInputBoxType.withLabelAndClearIcon;

  String? validateField(String? value) {
    setState(() {
      if (widget.validator != null) {
        errorText = widget.validator!(value) ?? '';
      }
    });
    return errorText.isEmpty ? null : errorText;
  }

  double typeToHintFontSize() {
    switch (widget.type) {
      case UFUInputBoxType.composeEmail:
        return 12.0;

      case UFUInputBoxType.withLabelOutside:
        return 15;

      default:
        return 14.0;
    }
  }
}
