import 'package:assignment_task_manager_project/ui/controllers/add_new_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import 'package:assignment_task_manager_project/ui/widgets/screen_background.dart';
import 'package:assignment_task_manager_project/ui/widgets/snack_bar_message.dart';
import 'package:assignment_task_manager_project/ui/widgets/tm_app_bar.dart';
import 'package:provider/provider.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
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
                  const SizedBox(height: 32),
                  Text(
                    'Add new task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 6,
                    decoration: InputDecoration(hintText: 'Description'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<AddNewTaskController>(
                      builder: (context, controller, child) {
                        return Visibility(
                          visible: controller.addNewTaskControllerInProgress == false,
                          replacement: CenteredProgressIndicator(),
                          child: ElevatedButton(
                            onPressed: () {
                              _onTapAddButton();
                            },
                            child: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }



  Future<void> _addNewTask() async {
    final _addNewTaskController =context.read<AddNewTaskController>();
    final bool isSuccess =await _addNewTaskController.addNewTask(
        _titleTEController.text.trim(),
        _descriptionTEController.text.trim());

    if (isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'task added Successfully');
      Navigator.pop(context,true);
    } else {
      showSnackBarMessage(context, 'create task failed');

    }
  }







  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }
}
