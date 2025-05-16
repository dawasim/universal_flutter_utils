import 'package:flutter/material.dart';


class UFUIcon extends StatelessWidget {
  const UFUIcon(
    this.icon,{
      super.key,
      this.size,
      this.color,
      this.textDirection,
      this.weight,
    });

 final IconData icon;
 final double? size;
 final Color? color;
 final TextDirection? textDirection;
 final double? weight;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
      textDirection: textDirection,
      weight: weight,
    );
  }
}
