import 'package:flutter/material.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget({Key? key, required this.color, required this.text, required this.onPressed}) : super(key: key);

  final Color color;
  final Text text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: this.color.withValues(alpha: 0.4), blurRadius: 40, offset: Offset(0, 15)),
          BoxShadow(color: this.color.withValues(alpha: 0.4), blurRadius: 13, offset: Offset(0, 3))
        ],
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: MaterialButton(
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        onPressed: this.onPressed,
        padding: EdgeInsets.symmetric(horizontal: 66, vertical: 14),
        color: this.color,
        shape: StadiumBorder(),
        child: this.text,
      ),
    );
  }
}
