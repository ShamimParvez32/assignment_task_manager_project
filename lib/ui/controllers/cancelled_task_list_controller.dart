import 'package:flutter/cupertino.dart';
import 'package:assignment_task_manager_project/data/models/task_model.dart';
import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';

class CancelledTaskListController extends ChangeNotifier {
  bool _cancelledTaskListInProgress = false;
  bool get cancelledTaskListInProgress => _cancelledTaskListInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<TaskModel> _cancelledTaskList = [];
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _cancelledTaskListInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.cancelledTaskListUrl,
    );

    if (response.isSuccess) {
      _cancelledTaskList.clear();
      for (Map<String, dynamic> json in response.responseData['data']) {
        _cancelledTaskList.add(TaskModel.fromJson(json));
      }
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _cancelledTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
