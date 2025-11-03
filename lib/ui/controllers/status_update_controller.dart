import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class StatusUpdateController extends ChangeNotifier {
  bool _statusUpdateInProgress = false;
  bool get statusUpdateInProgress => _statusUpdateInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> statusUpdate(String id, String newStatus) async {
    bool isSuccess = false;
    _statusUpdateInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.updateTaskStatusUrl(id, newStatus),
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _statusUpdateInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
