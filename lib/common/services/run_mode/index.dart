import 'package:universal_flutter_utils/universal_flutter_utils.dart';

/// [RunModeService] helps in setting the run mode of code
/// which further helps in easily differentiating between test runs
/// and actual app run.
class RunModeService {
  /// [mode] stores the current run mode of app
  /// by default it's value is going to be [RunMode.app]
  static RunMode mode = RunMode.app;

  /// Individual getter for checking run mode
  static bool get isUnitTestMode => mode == RunMode.unitTesting;
  static bool get isIntegrationTestMode => mode == RunMode.integrationTesting;
  static bool get isAppMode => mode == RunMode.app;

  /// [setRunMode] is used to set app's run mode
  /// majorly to avoid opening dialog while unit testing
  static void setRunMode(RunMode newMode) {
    mode = newMode;
  }
}