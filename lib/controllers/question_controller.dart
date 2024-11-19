import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/models/question_models.dart';
import 'package:quiz_app/views/admin/scorePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // user inderface codes

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

  // admin
  List<Question> _questions = [];
  List<Question> get questions => _questions;

  List<Question> _filterdQuestion = [];
  List<Question> get filterdQuestion => _filterdQuestion;

  final TextEditingController questionControllertext = TextEditingController();
  List<TextEditingController> optionalControllers =
      List.generate(4, (index) => TextEditingController());
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController quizCategory = TextEditingController();

  Future<void> saveQuestionToSharedPreferences(Question question) async {
    final prefs = await SharedPreferences.getInstance();
    final questions = prefs.getStringList("questions") ?? [];

    // convert the questions list to save into sharedpre
    _questions.add(question);
    questions.add(jsonEncode(question.toJson()));
    await prefs.setStringList("questions", questions);
  }

  // Admin dashboard keys
  final String _categoryTitleKey = "category_title";
  final String _categorySubtitleKey = "category_subtitle";
  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubtitleController = TextEditingController();

  RxList<String> savedTitleCategory = <String>[].obs;
  RxList<String> savedSubtitleCategory = <String>[].obs;

  void saveQuestionCategoryToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    savedTitleCategory.add(categoryTitleController.text);
    savedSubtitleCategory.add(categorySubtitleController.text);

    await prefs.setStringList(_categoryTitleKey, savedTitleCategory);
    await prefs.setStringList(_categorySubtitleKey, savedSubtitleCategory);

    categoryTitleController.clear();
    categorySubtitleController.clear();
    Get.snackbar("Saved", "Category created successfully");
  }

  void loadQuestionCategoryFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final titleCategory = prefs.getStringList(_categoryTitleKey) ?? [];
    final subtitleCategory = prefs.getStringList(_categorySubtitleKey) ?? [];

    savedTitleCategory.assignAll(titleCategory);
    savedSubtitleCategory.assignAll(subtitleCategory);
    update();
  }

  //  check code -----------------------------------------------------

  void loadQuestionsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionJson = prefs.getStringList("questions") ?? [];
    _questions = questionJson
        .map((json) => Question.fromJson(jsonDecode(json)))
        .toList();
    update();
    print(
        "questions loaded from shared preferences: ${_questions.length} questions");
  }

  List<Question> getQuestionsdByCategory(String category) {
    return _questions
        .where((question) => question.category == category)
        .toList();
  }

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

  void nextQuestion() async {
    if (_questionNumber.value != _questions.length) {
      _isAnswer = false;

      _pageController.nextPage(
        duration: const Duration(microseconds: 250),
        curve: Curves.ease,
      );
      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      Get.to(const Scorepage());
    }
  }

  void setFilteredQuestions(String category) {
    _filterdQuestion = getQuestionsdByCategory(category);
    _questionNumber.value = 1;
    update();
    nextQuestion();
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
    update();
  }

  @override
  void onInit() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(
        () {
          update();
        },
      );
    _animationController.forward().whenComplete(nextQuestion);

    loadQuestionCategoryFromSharedPreferences();
    loadQuestionsFromSharedPreferences();
    _pageController = PageController();
    update();

    super.onInit();
  }
}
