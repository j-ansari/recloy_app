import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../../core/utils/utils.dart';

void showBottomSheetDialog({
  required BuildContext context,
  required GlobalKey monthExpenseTrendKey,
}) {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(right: 50, left: 30),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(AppColor.primaryColor),
                width: 2,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              const Text(
                'MONTH EXPENSE TREND',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(AppColor.primaryColor),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Track month-on-month trend and average spending per month.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColor.primaryColor),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'SELECT month from the graph to view details of any previous month expenses.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColor.primaryColor),
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  color: const Color(AppColor.primaryColor),
                  height: 40,
                  minWidth: 100,
                  onPressed: () {
                    Navigator.pop(context);
                    tutorialCoachMark(
                      monthExpenseTrendKey: monthExpenseTrendKey,
                      context: context,
                    );
                  },
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  });
}

void tutorialCoachMark({
  required GlobalKey monthExpenseTrendKey,
  required BuildContext context,
}) {
  TutorialCoachMark(
    targets: [
      TargetFocus(
        identify: "monthExpenseTrendKey",
        keyTarget: monthExpenseTrendKey,
        color: const Color(AppColor.primaryColor),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "MONTH EXPENSE SUMMERY",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(AppColor.primaryColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tap on slice of pie to view list of transactions",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(AppColor.primaryColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    ],
    skipWidget: MaterialButton(
      onPressed: () {},
      minWidth: 100,
      height: 40,
      color: const Color(AppColor.primaryColor),
      child: const Text(
        'Finish',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    opacityShadow: 0.4,
    onSkip: () => UtilPreferences.setBool(Preferences.firstLoginUser, true),
    onFinish: () => UtilPreferences.setBool(Preferences.firstLoginUser, true),
  ).show(context: context);
}
