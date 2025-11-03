import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/models/task_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class ProgressTaskListController extends ChangeNotifier {
  bool _progressTaskListInProgress = false;
  bool get progressTaskListInProgress => _progressTaskListInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<TaskModel> _progressTaskList = [];
  List<TaskModel> get progressTaskList => _progressTaskList;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _progressTaskListInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.progressTaskListUrl,
    );

    if (response.isSuccess) {
      _progressTaskList.clear();
      for (Map<String, dynamic> json in response.responseData['data']) {
        _progressTaskList.add(TaskModel.fromJson(json));
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _progressTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
