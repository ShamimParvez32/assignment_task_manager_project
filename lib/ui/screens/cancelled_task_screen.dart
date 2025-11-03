import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/controllers/cancelled_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/task_summery_counter_controller.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CancelledTaskListController>().getCancelledTaskList();
      context.read<TaskSummeryCounterController>().getTaskCount();
    });
  }

  void _refresh() {
    context.read<CancelledTaskListController>().getCancelledTaskList();
    context.read<TaskSummeryCounterController>().getTaskCount();
  }

  @override
  Widget build(BuildContext context) {
    final cancelledController = context.watch<CancelledTaskListController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: cancelledController.cancelledTaskListInProgress == false,
          replacement: CenteredProgressIndicator(),
          child: ListView.separated(
            itemCount: cancelledController.cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: cancelledController.cancelledTaskList[index],
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
