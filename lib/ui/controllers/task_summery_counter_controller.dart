import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/models/task_status_count_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class TaskSummeryCounterController extends ChangeNotifier {
  bool _taskSummeryCounterInProgress = false;
  bool get taskSummeryCounterInProgress => _taskSummeryCounterInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<TaskStatusCountModel> _taskCountList = [];
  List<TaskStatusCountModel> get taskCount => _taskCountList;

  Future<bool> getTaskCount() async {
    bool isSuccess = false;
    _taskSummeryCounterInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.taskStatusCountUrl,
    );

    if (response.isSuccess) {
      _taskCountList.clear();
      for (Map<String, dynamic> json in response.responseData['data']) {
        _taskCountList.add(TaskStatusCountModel.fromJson(json));
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _taskSummeryCounterInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
