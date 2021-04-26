import 'package:devQuiz/challenge/challenge_page.dart';
import 'package:devQuiz/challenge/widgets/quiz/quiz_widget.dart';
import 'package:devQuiz/home/home_controller.dart';
import 'package:devQuiz/home/widgets/appbar/app_bar_widget.dart';
import 'package:devQuiz/home/widgets/home_state.dart';
import 'package:devQuiz/home/widgets/level_button/level_button_widget.dart';
import 'package:devQuiz/home/widgets/quiz_card/quiz_card_widget.dart';
import 'package:devQuiz/core/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.getUser();
    controller.getQuizzes();
    controller.stateNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.state == HomeState.success) {
      return Scaffold(
        appBar: AppBarWidget(
          user: controller.user!,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LevelButtonWidget(label: "Fácil"),
                LevelButtonWidget(label: "Médio"),
                LevelButtonWidget(label: "Difícil"),
                LevelButtonWidget(
                  label: "Perito",
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: controller.quizzes!
                    .map((e) => QuizCardWidget(
                          title: e.title,
                          completed:
                              "${e.questionAnswered}/${e.questions.length}",
                          percent: e.questionAnswered / e.questions.length,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChallengePage(
                                          questions: e.questions,
                                          title: e.title,
                                        )));
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGreen),
        ),
      ));
    }
  }
}
