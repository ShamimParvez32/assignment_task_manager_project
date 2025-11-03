import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/controllers/completed_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/task_summery_counter_controller.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompletedTaskListController>().getCompletedTaskList();
      context.read<TaskSummeryCounterController>().getTaskCount();
    });
  }

  void _refresh() {
    context.read<CompletedTaskListController>().getCompletedTaskList();
    context.read<TaskSummeryCounterController>().getTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    final completedController = context.watch<CompletedTaskListController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: completedController.completedTaskListInProgress == false,
          replacement: CenteredProgressIndicator(),
          child: ListView.separated(
            itemCount: completedController.completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: completedController.completedTaskList[index],
                refreshParent: () {
                  _refresh();
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8);
            },
          ),
        ),
      ),
    );
  }
}
