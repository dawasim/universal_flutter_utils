import 'package:flutter/cupertino.dart';

enum UFUConfirmationDialogType {
  /// [UFUConfirmationDialogType.message] is the default dialog
  /// with which you can display two buttons with different functionality
  message,

  /// [UFUConfirmationDialogType.alert] in this case only [CANCEL] button will
  /// be there and default functionality will be [Navigator.pop] which can be overriden
  alert,
}
