import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class ForgotPasswordVerifyEmailController extends ChangeNotifier{

  bool _forgotPasswordEmailInProgress = false;

  bool get forgotPasswordEmailInProgress => _forgotPasswordEmailInProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;


  Future<bool> forgotPasswordVerifyEmail (String email,) async {
     bool isSuccess=false;
    _forgotPasswordEmailInProgress = true;
     notifyListeners();


     final ApiResponse response = await ApiCaller.getRequest(
       url: Urls.recoveryMailUrl(email),
     );

    if (response.isSuccess) {
      isSuccess=true;
      _errorMessage = null;
    }
    else{
      _errorMessage=response.errorMessage;
    }

    _forgotPasswordEmailInProgress=false;

     notifyListeners();

     return isSuccess;

  }


}
