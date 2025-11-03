import 'package:assignment_task_manager_project/ui/controllers/add_new_task_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/cancelled_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/completed_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/delete_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/forgot_password_verify_otp_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/new_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/progress_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/reset_password_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/sign_in_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/sign_up_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/status_update_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/task_summery_counter_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/update_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:assignment_task_manager_project/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>AuthController()),
      ChangeNotifierProvider(create: (_)=>AddNewTaskController()),
      ChangeNotifierProvider(create: (_)=>SignInController()),
      ChangeNotifierProvider(create: (_)=>SignUpController()),
      ChangeNotifierProvider(create: (_)=>NewTaskListController()),
      ChangeNotifierProvider(create: (_)=>UpdateProfileController()),
      ChangeNotifierProvider(create: (_)=>TaskSummeryCounterController()),
      ChangeNotifierProvider(create: (_)=>DeleteController()),
      ChangeNotifierProvider(create: (_)=>StatusUpdateController()),
      ChangeNotifierProvider(create: (_)=>ProgressTaskListController()),
      ChangeNotifierProvider(create: (_)=>ForgotPasswordVerifyOtpController()),
      ChangeNotifierProvider(create: (_)=>ForgotPasswordVerifyEmailController()),
      ChangeNotifierProvider(create: (_)=>ResetPasswordController()),
      ChangeNotifierProvider(create: (_)=>CancelledTaskListController()),
      ChangeNotifierProvider(create: (_)=>CompletedTaskListController()),

    ],
    child: TaskManagerApp(),));
}
