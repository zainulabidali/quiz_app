import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/models/question_models.dart';
import 'package:quiz_app/views/admin/scorePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Animation & Page Controller
  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  late PageController _pageController;
  PageController get pageControllerInstance => _pageController;

  bool _isAnswer = false;
  bool get isAnswer => _isAnswer;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  int _selectedAns = 0;
  int get selectedAns => _selectedAns;

  int _numofCorrectAns = 0;
  int get numofCorrectAns => _numofCorrectAns;

  final RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => _questionNumber;

  // Question Management
  List<Question> _questions = [];
  List<Question> get questions => _questions;

  List<Question> _filteredQuestions = [];
  List<Question> get filteredQuestions => _filteredQuestions;

  final TextEditingController questionControllerText = TextEditingController();
  List<TextEditingController> optionalControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController correctAnswerController = TextEditingController();

  // Admin Dashboard Keys
  final String _categoriesBox = "categoriesBox";
  final String _questionsBox = "questionsBox";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedTitleCategory = <String>[].obs;
  RxList<String> savedSubtitleCategory = <String>[].obs;

  /// Save a question to Hive
  Future<void> saveQuestionToHive(Question question) async {
    final box = Hive.box(_questionsBox);

    // Add new question to Hive
    _questions.add(question);
    box.add(jsonEncode(question.toJson()));

    update();
    Get.snackbar("Success", "Question saved  to hive successfully.");
  }

  /// Load questions from Hive
  Future<void> loadQuestionsFromHive() async {
    final box = Hive.box(_questionsBox);

    _questions = box.values
        .map((jsonString) => Question.fromJson(jsonDecode(jsonString)))
        .toList()
        .cast<Question>();

    update();
    print("Loaded ${_questions.length} questions from Hive.");
  }

  /// Get questions by category
  List<Question> getQuestionsByCategory(String category) {
    return _questions.where((question) => question.category == category).toList();
  }

  /// Check the answer and move to the next question
  void checkAns(Question question, int selectedIndex) {
    _isAnswer = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) _numofCorrectAns++;
    _animationController.stop();
    update();

    Future.delayed(Duration(seconds: 2), () {
      nextQuestion();
    });
  }

  /// Move to the next question
  void nextQuestion() {
    if (_questionNumber.value != _filteredQuestions.length) {
      _isAnswer = false;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      Get.to(() => const Scorepage());
    }
  }



Future<void> saveCategory(String title, String subtitle) async {
  final box = Hive.box(_categoriesBox);

  try {
    // Save to Firebase
    DocumentReference docRef = await _firestore.collection("categories").add({
      "title": title,
      "subtitle": subtitle,
      "createdAt": Timestamp.now(),
    });

    // Save to Hive (with Firestore document ID for future reference)
    savedTitleCategory.add(title);
    savedSubtitleCategory.add(subtitle);

    box.put("titles", savedTitleCategory.toList());
    box.put("subtitles", savedSubtitleCategory.toList());

    // Clear text fields after saving
    categoryTitleController.clear();
    categorySubtitleController.clear();

    update();

    Get.snackbar("Success", "Category saved successfully.");
  } catch (e) {
    Get.snackbar("Error", "Failed to save category: $e");
    print("Error saving category: $e");
  }
}


Future<void> saveQuestion(Question question) async {
  final box = Hive.box(_questionsBox);

  try {
    // Save to Firebase
    DocumentReference docRef = await _firestore.collection("questions").add(question.toJson());

    // Save to Hive (optional: store Firestore ID for reference)
    _questions.add(question);
    box.add(jsonEncode(question.toJson()));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      update(); // Ensure update happens after the build phase
    });

    Get.snackbar("Success", "Question saved successfully.");
  } catch (e) {
    Get.snackbar("Error", "Failed to save question: $e");
    print("Error saving question: $e");
  }
}


  /// Filter questions by category
  void setFilteredQuestions(String category) {
    _filteredQuestions = getQuestionsByCategory(category);
    _questionNumber.value = 1;
    update();
  }

  /// Update the current question number
  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    update();
  }
  /// Save a new category to Hive
  Future<void> saveCategoryToHive(String title, String subtitle) async {
    final box = Hive.box(_categoriesBox);

    // Save to Hive
    savedTitleCategory.add(title);
    savedSubtitleCategory.add(subtitle);

    box.put("titles", savedTitleCategory.toList());
    box.put("subtitles", savedSubtitleCategory.toList());

    categoryTitleController.clear();
    categorySubtitleController.clear();
    update();

    Get.snackbar("Success", "Category created to hive successfully.");
  }

  /// Load categories from Hive
  Future<void> loadCategoriesFromHive() async {
    final box = Hive.box(_categoriesBox);

    savedTitleCategory.assignAll(box.get("titles", defaultValue: []) as List<String>);
    savedSubtitleCategory.assignAll(box.get("subtitles", defaultValue: []) as List<String>);

    update();
  }
/// Delete a category from both Hive and Firestore
Future<void> deleteCategory(int index) async {
  if (index >= 0 && index < savedTitleCategory.length) {
    final box = Hive.box(_categoriesBox);
    final String categoryTitle = savedTitleCategory[index];

    try {
      // Delete from Hive
      savedTitleCategory.removeAt(index);
      savedSubtitleCategory.removeAt(index);

      box.put("titles", savedTitleCategory.toList());
      box.put("subtitles", savedSubtitleCategory.toList());

      // Delete from Firestore
      QuerySnapshot snapshot = await _firestore
          .collection("categories")
          .where("title", isEqualTo: categoryTitle)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      update();
      Get.snackbar("Deleted", "Category deleted successfully.");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete category: $e");
      print("Error deleting category: $e");
    }
  } else {
    Get.snackbar("Error", "Invalid category index.");
  }
}

@override
void onInit() {
  _animationController =
      AnimationController(vsync: this, duration: Duration(seconds: 60));
  _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
    ..addListener(() {
      // Safely call update after the animation completes, if needed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
    });
  _animationController.forward().whenComplete(nextQuestion);

  // Make sure to load data after the widget build
  WidgetsBinding.instance.addPostFrameCallback((_) {
    loadCategoriesFromHive();
    loadQuestionsFromHive();
  });

  _pageController = PageController();

  super.onInit();
}

}
