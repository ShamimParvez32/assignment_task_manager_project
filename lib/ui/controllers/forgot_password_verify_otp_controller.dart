import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class ForgotPasswordVerifyOtpController extends ChangeNotifier{

  bool _forgotPasswordOtpInProgress = false;

  bool get forgotPasswordOtpInProgress => _forgotPasswordOtpInProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;


  Future<bool> forgotPasswordVerifyOtp (String email, String pinCode,) async {
     bool isSuccess=false;
    _forgotPasswordOtpInProgress = true;
     notifyListeners();

      final ApiResponse response = await ApiCaller.getRequest(
        url: Urls.recoveryOtpUrl(email, pinCode),
      );

     if (response.isSuccess) {
      isSuccess=true;
      _errorMessage = null;
    }
    else{
      _errorMessage=response.errorMessage;
    }

    _forgotPasswordOtpInProgress=false;

     notifyListeners();

     return isSuccess;

  }


}
