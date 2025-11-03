import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment_task_manager_project/ui/widgets/snack_bar_message.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment_task_manager_project/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:assignment_task_manager_project/ui/widgets/screen_background.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/controllers/forgot_password_verify_email_controller.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  static const String name = '/forget-password-verify-email';
  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Progress handled by ForgotPasswordVerifyEmailController via Provider



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
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits OTP will be sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if (EmailValidator.validate(inputText) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<ForgotPasswordVerifyEmailController>(
                    builder: (context, controller, _) {
                      return Visibility(
                        visible:
                            controller.forgotPasswordEmailInProgress == false,
                        replacement: CenteredProgressIndicator(),
                        child: FilledButton(
                          onPressed: _onTapNextButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
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
                              ..onTap = (){Navigator.pop(context);}
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

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _recoveryEmail(_emailTEController.text.trim());
    }
  }


  Future<void> _recoveryEmail(String email) async {
    final controller = context.read<ForgotPasswordVerifyEmailController>();
    final isSuccess = await controller.forgotPasswordVerifyEmail(email);

    if (!mounted) return;

    if (isSuccess) {
      showSnackBarMessage(context, 'Email verification successful');
      context.read<AuthController>().setEmail = email;
      Navigator.pushNamed(context, ForgotPasswordVerifyOtpScreen.name);
      _emailTEController.clear();
    } else {
      showSnackBarMessage(
        context,
        controller.errorMessage ?? 'Something went wrong',
      );
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}

