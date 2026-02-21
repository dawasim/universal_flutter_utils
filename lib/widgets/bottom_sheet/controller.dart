
import 'package:get/get.dart';

class UFUBottomSheetController extends GetxController{

  bool isLoading = false;

  bool switchValue = false;

  void toggleIsLoading(){
    isLoading = !isLoading;
    update();
  }

  void toggleSwitchValue(bool val){
    switchValue = val;
    update();
  }

}