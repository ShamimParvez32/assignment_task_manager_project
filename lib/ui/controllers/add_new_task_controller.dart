import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';
import 'package:flutter/widgets.dart';

class AddNewTaskController extends ChangeNotifier{

  bool _addNewTaskControllerInProgress = false;

  bool get addNewTaskControllerInProgress => _addNewTaskControllerInProgress;

  String? _errorMessage;
  String? get errorMessage=> _errorMessage;



  Future<bool> addNewTask (String title,String description,) async {
    bool isSuccess=false;
    _addNewTaskControllerInProgress = true;
      notifyListeners();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New"
    };
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess=true;
      _errorMessage = null;
    }
    else{
      _errorMessage=response.errorMessage;
    }

    _addNewTaskControllerInProgress=false;

    notifyListeners();
    return isSuccess;

  }


}
