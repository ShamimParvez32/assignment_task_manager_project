import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/models/task_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class CompletedTaskListController extends ChangeNotifier {
  bool _completedTaskListInProgress = false;
  bool get completedTaskListInProgress => _completedTaskListInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<TaskModel> _completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _completedTaskListInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.completedTaskListUrl,
    );

    if (response.isSuccess) {
      _completedTaskList.clear();
      for (Map<String, dynamic> json in response.responseData['data']) {
        _completedTaskList.add(TaskModel.fromJson(json));
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _completedTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
