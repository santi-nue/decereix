import 'package:flutter/material.dart';
class LabeledCheckbox extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final bool value;
  final Color checkColor;
  final Function onChanged;

  const LabeledCheckbox({
    Key key,
    @required this.label,
    @required this.padding,
    @required this.value,
    @required this.onChanged,@required this.checkColor,
  }) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        color: Colors.white54,
        child: Padding(
          padding: padding,
          child: Row(
            children: <Widget>[
              Expanded(child: Text(label)),
              Checkbox(
                fillColor: MaterialStateProperty.resolveWith(getColor),
                checkColor: checkColor,
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
