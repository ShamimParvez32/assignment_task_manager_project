import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class DeleteController extends ChangeNotifier {
  bool _deleteInProgress = false;
  bool get deleteInProgress => _deleteInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> deleteTask(String id) async {
    bool isSuccess = false;
    _deleteInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(id),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _deleteInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
