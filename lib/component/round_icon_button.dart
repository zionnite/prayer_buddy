import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.iconSize,
    this.widthSize,
    this.heightSize,
  });

  final IconData icon;
  final Function()? onPressed;
  final Color? color;
  final double? iconSize;
  final double? widthSize;
  final double? heightSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: RawMaterialButton(
        elevation: 20.0,
        child: Icon(
          icon,
          color: Colors.white,
          size: (iconSize != null) ? iconSize : 15,
        ),
        onPressed: onPressed,
        constraints: BoxConstraints.tightFor(
          width: (widthSize != null) ? widthSize : 20.0,
          height: (heightSize != null) ? heightSize : 33.0,
        ),
        shape: CircleBorder(),
        fillColor: (color != null) ? color : const Color(0xFF4C4F5E),
      ),
    );
  }
}
