import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/models/user_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';
import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';

class SignInController extends ChangeNotifier {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password,) async {
    bool isSuccess = false;
    _inProgress = true;
    notifyListeners();

    try {
      Map<String, dynamic> requestBody = {"email": email, "password": password};
      final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.loginUrl,
        body: requestBody,
      );


      if (response.isSuccess && response.responseData != null) {
        final responseData = response.responseData!;

        if (responseData.containsKey('token') && responseData.containsKey('data')) {

          String token = responseData['token'];
          UserModel userModel = UserModel.fromJson(responseData['data']);
          await AuthController.setUserData(token, userModel);

          isSuccess = true;
          _errorMessage = null;
        } else {
          _errorMessage = responseData['message'] ?? 'Login failed';
        }
      } else {
        if (response.responseCode == 401) {
          _errorMessage = 'Username/password is incorrect';
        } else {
          _errorMessage = response.errorMessage ?? 'Something went wrong';
        }
      }
    } catch (e) {
      _errorMessage = 'Something went wrong: $e';
    } finally {
      _inProgress = false;
      notifyListeners();
// 🔥 always stop loader
    }

    return isSuccess;
  }


}
