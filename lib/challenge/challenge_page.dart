import 'package:devQuiz/challenge/widgets/next_button/next_button_widget.dart';
import 'package:devQuiz/challenge/widgets/question_indicator/question_indicator_widget.dart';
import 'package:devQuiz/challenge/widgets/quiz/quiz_widget.dart';
import 'package:devQuiz/result/result_page.dart';
import 'package:devQuiz/shared/models/question_model.dart';
import 'package:devQuiz/challenge/challenge_controller.dart';
import 'package:flutter/material.dart';

class ChallengePage extends StatefulWidget {
  final List<QuestionModel> questions;

  final String title;

  ChallengePage({Key? key, required this.questions, required this.title})
      : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final controller = ChallengeController();
  final pageController = PageController();

  void nextPage() {
    if (controller.currentPage < widget.questions.length)
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  void onSelected(bool value) {
    if (value) {
      controller.qtdCorrectedAwnser++;
    }
    nextPage();
  }

  @override
  void initState() {
    pageController.addListener(() {
      controller.currentPage = pageController.page!.toInt() + 1;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => QuestionIndicatorWidget(
                  currentPage: value,
                  lenght: widget.questions.length,
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        children: widget.questions
            .map((e) => QuizWidget(
                  question: e,
                  onSelected: onSelected,
                ))
            .toList(),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ValueListenableBuilder<int>(
                valueListenable: controller.currentPageNotifier,
                builder: (context, value, _) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (value < widget.questions.length)
                          Expanded(
                              child: NextButtonWidget.white(
                            label: "Pular",
                            onTap: nextPage,
                          )),
                        if (value == widget.questions.length)
                          Expanded(
                              child: NextButtonWidget.green(
                            label: "Confirmar",
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                            result:
                                                controller.qtdCorrectedAwnser,
                                            title: widget.title,
                                            length: widget.questions.length,
                                          )));
                            },
                          )),
                      ],
                    ))),
      ),
    );
  }
}
