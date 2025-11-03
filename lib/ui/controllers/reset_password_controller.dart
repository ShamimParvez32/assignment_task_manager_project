import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';
import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';

class ResetPasswordController extends ChangeNotifier{

  bool _resetPasswordInProgress = false;

  bool get resetPasswordInProgress => _resetPasswordInProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;


  Future<bool> resetPassword (String password, AuthController authController,) async {
     bool isSuccess=false;
    _resetPasswordInProgress = true;
     notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": authController.getEmail,
      "OTP": authController.getPinCode,
      "password": password,
    };

     print("Request Body: $requestBody");

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.resetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess) {

      isSuccess=true;
      _errorMessage = null;
    }
    else{
      _errorMessage=response.errorMessage;
    }

    _resetPasswordInProgress=false;

     notifyListeners();

     return isSuccess;

  }


}
