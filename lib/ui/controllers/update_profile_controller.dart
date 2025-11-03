import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:assignment_task_manager_project/data/models/user_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';
import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';

class UpdateProfileController extends ChangeNotifier {
  bool _updateProfileInProgress = false;

  bool get updateProfileInProgress => _updateProfileInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  XFile? _pickedImage;

  XFile? get pickedImage => _pickedImage;


  Future<void> pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }


  Future<bool> updateProfile(String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      AuthController authController,
      ) async {
    bool isSuccess = false;
    _updateProfileInProgress = true;
    notifyListeners();


    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile
    };

    String? base64Photo;
    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      base64Photo = base64Encode(imageBytes);
      requestBody['photo'] = base64Photo;
    }



    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    if (response.isSuccess) {


      // Method == 3 updating  data  by response to auth updateUserData function;
      if (requestBody['photo'] == null) {
        requestBody['photo'] = AuthController.userModel?.photo;
      }
      authController.updateUserData(UserModel.fromJson(requestBody));

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _updateProfileInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
