import 'package:assignment_task_manager_project/data/services/api_caller.dart';
import 'package:assignment_task_manager_project/data/utils/urls.dart';
import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';
import 'package:assignment_task_manager_project/ui/screens/sign_up_screen.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment_task_manager_project/ui/widgets/snack_bar_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment_task_manager_project/ui/screens/login_screen.dart';
import 'package:assignment_task_manager_project/ui/widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String name = '/reset-password';
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}


class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _resetPasswordScreenInProgress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 82),
                  Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Password should be more than 6 letters and combination of numbers',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'New Password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Confirm new password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _resetPasswordScreenInProgress==false,
                    replacement:  CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapResetPasswordButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.name, (value) => false);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapResetPasswordButton() {
    if (_formKey.currentState!.validate()) {
      if(_passwordTEController.text == _confirmPasswordTEController.text) {
        _resetPassword();
      }
      else{
        if (mounted) {
          showSnackBarMessage(context, 'Passwords do not match');
        }
      }
    }
  }




  void _resetPassword() async{

    _resetPasswordScreenInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": AuthController.getEmail,
      "OTP": AuthController.getPinCode,
      "password": _passwordTEController.text,
    };
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.resetPasswordUrl,
      body: requestBody,
    );

    if (!mounted) return;
    _resetPasswordScreenInProgress = false;
    setState(() {});


    if (response.isSuccess) {
      print(requestBody);
      showSnackBarMessage(context, 'password reset successful');
      await Future.delayed(const Duration(seconds: 1));


      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.name,
              (_) => false,
        );
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage ?? 'Something went wrong');
      }
    }

    _passwordTEController.clear();
    _confirmPasswordTEController.clear();
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}