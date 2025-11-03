import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment_task_manager_project/ui/widgets/snack_bar_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:assignment_task_manager_project/ui/screens/login_screen.dart';
import 'package:assignment_task_manager_project/ui/screens/reset_password_screen.dart';
import 'package:assignment_task_manager_project/ui/screens/sign_up_screen.dart';
import 'package:assignment_task_manager_project/ui/widgets/screen_background.dart';
import 'package:assignment_task_manager_project/ui/controllers/forgot_password_verify_otp_controller.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key});

  static const String name = '/forgot-password-verify-otp';

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Progress handled by ForgotPasswordVerifyOtpController via Provider


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
                    'Enter Your OTP',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits OTP has been sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,

                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    controller: _otpTEController,
                    appContext: context,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your otp';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(height: 16),
                  Consumer<ForgotPasswordVerifyOtpController>(
                    builder: (context, controller, _) {
                      return Visibility(
                        visible:
                            controller.forgotPasswordOtpInProgress == false,
                        replacement: CenteredProgressIndicator(),
                        child: FilledButton(
                          onPressed: _onTapVerifyButton,
                          child: Text('Verify'),
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
                              ..onTap = () => Navigator.pushNamed(
                                    context,
                                    LoginScreen.name,
                                  ),
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

  void _onTapVerifyButton() {
    if (_formKey.currentState!.validate()) {
      _recoveryOtp(context.read<AuthController>().getEmail, _otpTEController.text);
    }
  }

  void _recoveryOtp(String email, String pinCode) async {
    final controller = context.read<ForgotPasswordVerifyOtpController>();
    final isSuccess = await controller.forgotPasswordVerifyOtp(email, pinCode);

    if (!mounted) return;

    if (isSuccess) {
      showSnackBarMessage(context, 'Otp verification successful');
      context.read<AuthController>().setPinCode = pinCode;
      Navigator.pushNamed(context, ResetPasswordScreen.name);
      _otpTEController.clear();
    } else {
      showSnackBarMessage(
        context,
        controller.errorMessage ?? 'Something went wrong',
      );
    }
  }





  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}
