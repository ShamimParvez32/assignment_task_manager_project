import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/models/task_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class NewTaskListController extends ChangeNotifier {
  bool _newTaskListInProgress = false;
  bool get newTaskListInProgress => _newTaskListInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<TaskModel> _newTaskList = [];
  List<TaskModel> get newTaskList => _newTaskList;

  Future<bool> getTaskList() async {
    bool isSuccess = false;
    _newTaskListInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.newTaskListUrl,
    );

    if (response.isSuccess) {
      _newTaskList.clear();
      for (Map<String, dynamic> json in response.responseData['data']) {
        _newTaskList.add(TaskModel.fromJson(json));
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _newTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
