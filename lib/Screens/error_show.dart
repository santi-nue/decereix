import 'package:flutter/material.dart';

class ErrorShow extends StatelessWidget {
  final String errorText;
  const ErrorShow({
    Key key,
    @required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text('Error: $errorText'),
        ),
      ),
    );
  }
}
