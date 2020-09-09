import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_dialog/src/text_input_dialog/cupertino_text_input_dialog.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'material_text_input_dialog.dart';

Future<List<String>> showTextInputDialog({
  @required BuildContext context,
  @required List<DialogTextField> textFields,
  String title,
  String message,
  String okLabel,
  String cancelLabel,
  bool isDestructiveAction = false,
  bool barrierDismissible = true,
  AdaptiveStyle style = AdaptiveStyle.adaptive,
  bool useRootNavigator = true,
  VerticalDirection actionsOverflowDirection = VerticalDirection.up,
  Color okColor = Colors.blueAccent,
  Color cancelColor = Colors.redAccent,
}) {
  final theme = Theme.of(context);
  return style.isCupertinoStyle(theme)
      ? showCupertinoDialog(
          context: context,
          useRootNavigator: useRootNavigator,
          builder: (context) => CupertinoTextInputDialog(
            textFields: textFields,
            title: title,
            message: message,
            okLabel: okLabel,
            cancelLabel: cancelLabel,
            isDestructiveAction: isDestructiveAction,
            style: style,
            useRootNavigator: useRootNavigator,
            okColor: okColor,
            cancelColor: cancelColor,
          ),
        )
      : showModal(
          context: context,
          useRootNavigator: useRootNavigator,
          configuration: FadeScaleTransitionConfiguration(
            barrierDismissible: barrierDismissible,
          ),
          builder: (context) => MaterialTextInputDialog(
            textFields: textFields,
            title: title,
            message: message,
            okLabel: okLabel,
            cancelLabel: cancelLabel,
            isDestructiveAction: isDestructiveAction,
            style: style,
            actionsOverflowDirection: actionsOverflowDirection,
            useRootNavigator: useRootNavigator,
          ),
        );
}

// TODO(mono): Add more options
@immutable
class DialogTextField {
  const DialogTextField({
    this.initialText,
    this.hintText,
    this.obscureText = false,
    this.validator,
  });
  final String initialText;
  final String hintText;
  final bool obscureText;
  final FormFieldValidator<String> validator;
}
