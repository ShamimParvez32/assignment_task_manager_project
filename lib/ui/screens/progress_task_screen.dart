import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/controllers/progress_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/task_summery_counter_controller.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressTaskListController>().getProgressTaskList();
      context.read<TaskSummeryCounterController>().getTaskCount();
    });
  }

  void _refresh() {
    context.read<ProgressTaskListController>().getProgressTaskList();
    context.read<TaskSummeryCounterController>().getTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    final progressController = context.watch<ProgressTaskListController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: progressController.progressTaskListInProgress == false,
          replacement: CenteredProgressIndicator(),
          child: ListView.separated(
            itemCount: progressController.progressTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: progressController.progressTaskList[index],
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
