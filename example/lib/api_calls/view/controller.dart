import 'package:get/get.dart';
import 'package:universal_flutter_utils/api_config/api_config.dart';
import 'package:universal_flutter_utils/universal_flutter_utils.dart';

class APISampleCallsController extends GetxController {
  
  RxString token = RxString(""); 

  Future<void> getToken() async {
    dynamic response = await UFApiConfig().post("auth/login", data: {
      "username":"emilys",
      "password":"emilyspass",
      "expiresInMins":30
    });
    token.value = response["accessToken"]?.toString() ?? "";
    UFUtils.preferences.writeString(UFUtils.preferences.authToken, token.value);
  }

  Future<void> getRequest() async {
    dynamic response = await UFApiConfig().get("auth/me");
    UFUToast.showToast("Hello! \n"
        "${response["firstName"]?.toString()} ${response["maidenName"]?.toString()} ${response["lastName"]?.toString()} "
        "Welcome onboard");
  }
}