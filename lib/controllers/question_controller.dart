import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/models/question_models.dart';
import 'package:quiz_app/views/admin/scorePage.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
    Get.snackbar("Success", "Question saved successfully.");
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

    Get.snackbar("Success", "Category created successfully.");
  }

  /// Load categories from Hive
  Future<void> loadCategoriesFromHive() async {
    final box = Hive.box(_categoriesBox);

    savedTitleCategory.assignAll(box.get("titles", defaultValue: []) as List<String>);
    savedSubtitleCategory.assignAll(box.get("subtitles", defaultValue: []) as List<String>);

    update();
  }

  /// Delete a category
  Future<void> deleteCategory(int index) async {
    if (index >= 0 && index < savedTitleCategory.length) {
      final box = Hive.box(_categoriesBox);

      savedTitleCategory.removeAt(index);
      savedSubtitleCategory.removeAt(index);

      // Update Hive
      box.put("titles", savedTitleCategory.toList());
      box.put("subtitles", savedSubtitleCategory.toList());

      update();
      Get.snackbar("Deleted", "Category deleted successfully.");
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
        update();
      });
    _animationController.forward().whenComplete(nextQuestion);

    loadCategoriesFromHive();
    loadQuestionsFromHive();
    _pageController = PageController();

    super.onInit();
  }
}
