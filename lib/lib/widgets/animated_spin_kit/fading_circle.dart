// MIT License
//Copyright (c) 2018 Jeremiah Ogbomo
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'package:flutter/widgets.dart';

import 'delay_tween.dart';

class FadingCircle extends StatefulWidget {
  const FadingCircle({
    super.key,
    this.color,
    this.size = 50.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color');

  final Color? color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  FadingCircleState createState() => FadingCircleState();
}

class FadingCircleState extends State<FadingCircle>
    with SingleTickerProviderStateMixin {
  final List<double> delays = [
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1
  ];
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: Stack(
        children: List.generate(delays.length, (index) {
          final position = widget.size * .5;
          return Positioned.fill(
            left: position,
            top: position,
            child: Transform(
              transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
              child: Align(
                alignment: Alignment.center,
                child: ScaleTransition(
                  scale:
                      DelayTween(begin: 0.0, end: 1.0, delay: delays[index])
                          .animate(controller),
                  child: SizedBox.fromSize(
                      size: Size.square(widget.size * 0.15),
                      child: itemBuilder(index)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder!(context, index)
        : DecoratedBox(
            decoration:
                BoxDecoration(color: widget.color, shape: BoxShape.circle));
  }
}
