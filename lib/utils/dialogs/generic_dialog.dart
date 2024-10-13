import 'dart:ui';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
  Map<String, Color?>? optionsColor,
  bool blurBackground = false,
}) {
  final options = optionsBuilder();

  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Stack(
            children: [
              if (blurBackground)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: options.keys.map((optionTitle) {
                  final T value = options[optionTitle];
                  final Color? textButtonColor = optionsColor != null
                      ? optionsColor[optionTitle]
                      : Colors.white;
                  return TextButton(
                    onPressed: () {
                      if (value != null) {
                        Navigator.of(context).pop(value);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(optionTitle,
                        style: TextStyle(
                          color: textButtonColor,
                        )),
                  );
                }).toList(),
              ),
            ],
          );
        },
      );
    },
  );
}
