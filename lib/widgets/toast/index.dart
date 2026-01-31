import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';
import 'package:get/get.dart';

class UFUToast {
  static DateTime? _lastShownTime;
  static const Duration _cooldown = Duration(seconds: 1);

  static void showToast(String message, {String? title, bool isError = false}) {
    if(!(Platform.isAndroid && Platform.isIOS)) {
      WindowsToast.show(message, isError: isError);
      return;
    }

    final now = DateTime.now();

    // Prevent showing toasts if another was just shown recently
    if (_lastShownTime != null &&
        now.difference(_lastShownTime!) < _cooldown) {
      return;
    }

    _lastShownTime = now;

    // Cancel existing toast before showing a new one
    if (!kIsWeb) {
      Fluttertoast.cancel();
    }

    // Show the toast
    Fluttertoast.showToast(
      msg: title != null ? "$title\n$message" : message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

/// Windows Toasts - for tablet and desktop screens.
class WindowsToast extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onDismissed;
  final IconData? icon;
  final Color? iconColor;
  final bool isError;

  const WindowsToast({
    super.key,
    required this.message,
    required this.duration,
    required this.onDismissed,
    this.icon,
    this.iconColor,
    this.isError = false
  });

  @override
  State<WindowsToast> createState() => _WindowsToastState();

  static void show(
      String message, {
        Duration duration = const Duration(seconds: 2),
        IconData? icon,
        Color? iconColor,
        bool isError = false
      }) {
    final overlay = Get.key.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => WindowsToast(message: message, icon: icon, iconColor: iconColor, isError: isError, duration: duration, onDismissed: () => entry.remove()),
    );

    overlay.insert(entry);
  }
}

class _WindowsToastState extends State<WindowsToast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));

    _slide = Tween<Offset>(
      begin: const Offset(1, 0), // enter from right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    Future.delayed(widget.duration, _hide);
  }

  Future<void> _hide() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.icon ?? (widget.isError ? Icons.cancel : Icons.check_circle_rounded);
    final iconColor = widget.iconColor ?? (widget.isError ? AppTheme.themeColors.red : AppTheme.themeColors.primary);

    return Positioned(
      bottom: 20,
      right: 20,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: AppTheme.themeColors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.themeColors.themeBlack.withAlpha(175),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 12),
                Flexible(
                  child: UFUText(
                    text: widget.message,
                    textAlign: TextAlign.start,
                    textSize: UFUTextSize.heading3,
                    textColor: AppTheme.themeColors.base,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}