import 'package:flutter/material.dart';


class UFUIcon extends StatelessWidget {
  const UFUIcon(
    this.icon,{
      super.key,
      this.size,
      this.color,
      this.textDirection
    });

 final IconData icon;
 final double? size;
 final Color? color;
 final TextDirection? textDirection;


  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color,
      textDirection: textDirection,
    );
  }
}
