import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/src/extensions/extensions.dart';

class CupertinoTextInputDialog extends StatefulWidget {
  const CupertinoTextInputDialog({
    @required this.textFields,
    this.title,
    this.message,
    this.okLabel,
    this.cancelLabel,
    this.isDestructiveAction = false,
    this.style = AdaptiveStyle.adaptive,
    this.useRootNavigator = true,
    this.okColor,
    this.cancelColor,
  });
  @override
  _CupertinoTextInputDialogState createState() =>
      _CupertinoTextInputDialogState();

  final List<DialogTextField> textFields;
  final String title;
  final String message;
  final String okLabel;
  final String cancelLabel;
  final bool isDestructiveAction;
  final AdaptiveStyle style;
  final bool useRootNavigator;
  final Color okColor;
  final Color cancelColor;
}

class _CupertinoTextInputDialogState extends State<CupertinoTextInputDialog> {
  List<TextEditingController> _textControllers;
  String _validationMessage;
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();

    _textControllers = widget.textFields
        .map((tf) => TextEditingController(text: tf.initialText))
        .toList();

    for (final c in _textControllers) {
      c.addListener(() {
        if (_autovalidate) {
          _validate();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _textControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(
      context,
      rootNavigator: widget.useRootNavigator,
    );
    void pop() => navigator.pop(
          _textControllers.map((c) => c.text).toList(),
        );
    void cancel() => navigator.pop();
    final titleText = widget.title == null ? null : Text(widget.title);
    final okText = Text(
      widget.okLabel ?? MaterialLocalizations.of(context).okButtonLabel,
      style: TextStyle(
        color: widget.okColor,
      ),
    );
    BoxDecoration _borderDecoration({
      @required bool isTopRounded,
      @required bool isBottomRounded,
    }) {
      const radius = 6.0;
      const borderSide = BorderSide(
        color: CupertinoDynamicColor.withBrightness(
          color: Color(0x33000000),
          darkColor: Color(0x33FFFFFF),
        ),
        style: BorderStyle.solid,
        width: 0,
      );
      return BoxDecoration(
        color: const CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.white,
          darkColor: CupertinoColors.black,
        ),
        border: const Border(
          top: borderSide,
          bottom: borderSide,
          left: borderSide,
          right: borderSide,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isTopRounded ? radius : 0),
          bottom: Radius.circular(isBottomRounded ? radius : 0),
        ),
      );
    }

    return CupertinoAlertDialog(
      title: titleText,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.message != null) Text(widget.message),
          const SizedBox(height: 22),
          ..._textControllers.mapWithIndex(
            (c, i) {
              final field = widget.textFields[i];
              return CupertinoTextField(
                controller: c,
                autofocus: i == 0,
                placeholder: field.hintText,
                obscureText: field.obscureText,
                decoration: _borderDecoration(
                  isTopRounded: i == 0,
                  isBottomRounded: i == _textControllers.length - 1,
                ),
              );
            },
          ),
          if (_validationMessage != null)
            Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.only(
                top: 4,
                left: 4,
              ),
              child: Text(
                _validationMessage,
                style: TextStyle(
                  color: CupertinoColors.systemRed.resolveFrom(context),
                  height: 1.2,
                ),
                textAlign: TextAlign.start,
              ),
            ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            widget.cancelLabel ??
                MaterialLocalizations.of(context)
                    .cancelButtonLabel
                    .capitalizedForce,
            style: TextStyle(color: widget.cancelColor),
          ),
          onPressed: cancel,
          isDefaultAction: true,
        ),
        CupertinoDialogAction(
          child: okText,
          onPressed: () {
            if (_validate()) {
              pop();
            }
          },
        ),
      ],
    );
  }

  bool _validate() {
    _autovalidate = true;
    final validations = widget.textFields.mapWithIndex((tf, i) {
      final validator = tf.validator;
      return validator == null ? null : validator(_textControllers[i].text);
    }).where((result) => result != null);
    setState(() {
      _validationMessage = validations.join('\n');
    });
    return validations.isEmpty;
  }
}
