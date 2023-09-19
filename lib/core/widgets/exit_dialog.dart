import 'dart:io';

import 'package:flutter/material.dart';

import '../core.dart';

Future<bool> exitDialog({required BuildContext context, required Size size}) {
  return showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: false,
    barrierLabel: '',
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => Container(),
    transitionBuilder: (context, animation1, animation2, widget) {
      return SizedBox(
        width: size.width,
        child: Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: AlertDialog(
              backgroundColor: Colors.white.withOpacity(0.8),
              title: const Text(
                'exit app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'are you sure to exit app?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppButton(
                        title: 'No',
                        width: size.width / 4,
                        onClick: () => Navigator.pop(context),
                      ),
                      AppButton(
                        title: 'Yes',
                        width: size.width / 4,
                        onClick: () => exit(0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) => value as bool);
}
