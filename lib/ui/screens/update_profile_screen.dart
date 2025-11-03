import 'package:flutter/material.dart';
import 'package:assignment_task_manager_project/data/models/user_model.dart';
import 'package:assignment_task_manager_project/ui/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment_task_manager_project/ui/widgets/screen_background.dart';
import 'package:assignment_task_manager_project/ui/widgets/snack_bar_message.dart';
import 'package:assignment_task_manager_project/ui/widgets/tm_app_bar.dart';
import 'package:assignment_task_manager_project/ui/controllers/update_profile_controller.dart';

import '../widgets/photo_picker_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Image and progress handled by UpdateProfileController via Provider

  @override
  void initState() {
    super.initState();
    UserModel user = AuthController.userModel!;

    _emailTEController.text = user.email;
    _firstNameTEController.text = user.firstName;
    _lastNameTEController.text = user.lastName;
    _mobileTEController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromUpdateProfile: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Update Profile',
                    style: TextTheme.of(context).titleLarge,
                  ),
                  const SizedBox(height: 24),
                  Consumer<UpdateProfileController>(
                    builder: (context, controller, _) {
                      return PhotoPickerField(
                        onTap: () => controller.pickImage(),
                        selectedPhoto: controller.pickedImage,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    enabled: false,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'First name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'Last name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password (Optional)'),
                    validator: (String? value) {
                      if ((value != null && value.isNotEmpty) && value.length < 6) {
                        return 'Enter a password more than 6 letters';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<UpdateProfileController>(
                    builder: (context, controller, _) {
                      return Visibility(
                        visible: controller.updateProfileInProgress == false,
                        replacement: CenteredProgressIndicator(),
                        child: FilledButton(
                          onPressed: _onTapUpdateButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }
  
  Future<void> _updateProfile() async {
    final controller = context.read<UpdateProfileController>();
    final auth = context.read<AuthController>();

    final isSuccess = await controller.updateProfile(
      _emailTEController.text,
      _firstNameTEController.text.trim(),
      _lastNameTEController.text.trim(),
      _mobileTEController.text.trim(),
      _passwordTEController.text,
      auth,
    );

    if (!mounted) return;

    if (isSuccess) {
      _passwordTEController.clear();
      showSnackBarMessage(context, 'Profile has been updated!');
    } else {
      showSnackBarMessage(
        context,
        controller.errorMessage ?? 'Something went wrong',
      );
    }
  }


  // Image picking handled by UpdateProfileController



  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
