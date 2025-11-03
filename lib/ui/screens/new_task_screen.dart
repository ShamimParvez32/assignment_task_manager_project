import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_task_manager_project/ui/controllers/new_task_list_controller.dart';
import 'package:assignment_task_manager_project/ui/controllers/task_summery_counter_controller.dart';
import 'package:assignment_task_manager_project/ui/screens/add_new_task_screen.dart';
import 'package:assignment_task_manager_project/ui/widgets/centered_progress_indicator.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskSummeryCounterController>().getTaskCount();
      context.read<NewTaskListController>().getTaskList();
    });
  }

  void _refreshCounts() {
    context.read<TaskSummeryCounterController>().getTaskCount();
  }

  void _refreshTasks() {
    context.read<NewTaskListController>().getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    final counterController = context.watch<TaskSummeryCounterController>();
    final newTaskController = context.watch<NewTaskListController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: Visibility(
                visible: counterController.taskSummeryCounterInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: ListView.separated(
                  itemCount: counterController.taskCount.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountByStatusCard(
                      title: counterController.taskCount[index].status,
                      count: counterController.taskCount[index].count,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 4);
                  },
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: newTaskController.newTaskListInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: ListView.separated(
                  itemCount: newTaskController.newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: newTaskController.newTaskList[index],
                      refreshParent: () {
                        _refreshTasks();
                        _refreshCounts();
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }
}
