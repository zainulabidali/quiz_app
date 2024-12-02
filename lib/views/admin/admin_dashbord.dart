import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/question_controller.dart';
import 'package:quiz_app/views/admin/admin_Screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController questionController = Get.put(QuestionController());
  @override
  void initState() {
    questionController.loadCategoriesFromHive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedTitleCategory.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => AdminScreen(
                        quizCategory: controller.savedTitleCategory[index]));
                  },
                  leading: Icon(Icons.question_answer),
                  title: Text(controller.savedTitleCategory[index]),
                  subtitle: Text(controller.savedSubtitleCategory[index]),
                  trailing: IconButton(
                    onPressed: () {
                      controller.deleteCategory(index);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialogBox() {
    Get.defaultDialog(
      titlePadding: EdgeInsets.only(top: 15),
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            controller: questionController.categoryTitleController,
            decoration: InputDecoration(
              hintText: "Enter the category name",
            ),
          ),
          TextFormField(
            controller: questionController.categorySubtitleController,
            decoration: InputDecoration(
              hintText: "Enter the category subtitle",
            ),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        if (questionController.categoryTitleController.text.isNotEmpty &&
            questionController.categorySubtitleController.text.isNotEmpty) {
          questionController.saveCategory(
            questionController.categoryTitleController.text,
            questionController.categorySubtitleController.text,
          );
          Get.back(); // Close the dialog after saving
        } else {
          Get.snackbar("Error", "Title and Subtitle cannot be empty.");
        }
      },
    );
  }
}
