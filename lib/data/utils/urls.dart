class Urls {
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';

  static const String registrationUrl = '$_baseUrl/Registration';
  static const String loginUrl = '$_baseUrl/Login';
  static  String recoveryMailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static  String recoveryOtpUrl(String email, String pinCode) => '$_baseUrl/RecoverVerifyOTP/$email/$pinCode';
  static const String resetPasswordUrl = '$_baseUrl/RecoverResetPassword';
  static const String createTaskUrl = '$_baseUrl/createTask';
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static const String newTaskListUrl = '$_baseUrl/listTaskByStatus/New';
  static const String progressTaskListUrl = '$_baseUrl/listTaskByStatus/Progress';
  static const String cancelledTaskListUrl = '$_baseUrl/listTaskByStatus/Cancelled';
  static const String completedTaskListUrl = '$_baseUrl/listTaskByStatus/Completed';

  static String updateTaskStatusUrl(String id, String newStatus) =>
      '$_baseUrl/updateTaskStatus/$id/$newStatus';

  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';
}
//https://documenter.getpostman.com/view/25827808/2s9Yyqi2JF#c53d9def-eb51-40fc-a61f-cb8bceb0aab7