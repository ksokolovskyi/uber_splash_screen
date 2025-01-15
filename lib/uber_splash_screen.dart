import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

const _foregroundColor = Color(0xFFFFFDFF);
const _backgroundColor = Color(0xFF020002);

const _animationDuration = 1250;

const _backgroundProgressStart = 980;
const _backgroundProgressEnd = 1150;

const _backgroundOpacityStart = _backgroundProgressStart;
const _backgroundOpacityEnd = _animationDuration;

const _foregroundProgressStart = 366;
const _foregroundProgressEnd = 850;

const _foregroundOffsetStart = 350;
const _foregroundOffsetEnd = 915;

const _foregroundLinesLengthStart = 335;
const _foregroundLinesLengthEnd = 715;

const _foregroundLinesGapStart = 915;
const _foregroundLinesGapEnd = 1185;

class UberSplashScreen extends StatelessWidget {
  const UberSplashScreen({
    required this.controller,
    super.key,
  });

  final AnimationController controller;

  static AnimationController createController(TickerProvider vsync) {
    return AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: _animationDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _Background(controller: controller),
        _Foreground(controller: controller),
      ],
    );
  }
}

class _Background extends StatefulWidget {
  const _Background({required this.controller});

  final AnimationController controller;

  @override
  State<_Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<_Background> {
  static const _curve = Cubic(.26, .05, .78, .61);

  late final _progress = Tween<double>(begin: 0, end: 1)
      .chain(
        CurveTween(
          curve: const Interval(
            _backgroundProgressStart / _animationDuration,
            _backgroundProgressEnd / _animationDuration,
            curve: _curve,
          ),
        ),
      )
      .animate(widget.controller);

  late final _opacity = Tween<double>(begin: 1, end: 0)
      .chain(
        CurveTween(
          curve: const Interval(
            _backgroundOpacityStart / _animationDuration,
            _backgroundOpacityEnd / _animationDuration,
            curve: _curve,
          ),
        ),
      )
      .animate(widget.controller);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BackgroundPainter(
        color: _backgroundColor,
        progress: _progress,
        opacity: _opacity,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  _BackgroundPainter({
    required this.color,
    required this.opacity,
    required this.progress,
  }) : super(
          repaint: Listenable.merge([opacity, progress]),
        );

  final Color color;

  final Animation<double> opacity;

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity.value == 0) {
      return;
    }

    final screenRect = Offset.zero & size;

    final fadingRectWidthProgress = 0.23 + 0.77 * progress.value;
    final fadingRectWidth = fadingRectWidthProgress * screenRect.width;

    final fadingRect = Rect.fromCenter(
      center: screenRect.center,
      width: fadingRectWidth,
      height: screenRect.height,
    );

    final paint = Paint()..color = color.withOpacity(opacity.value);

    canvas.drawRect(fadingRect, paint);

    if (progress.value == 1) {
      return;
    }

    paint.color = color;

    canvas
      ..drawRect(
        Rect.fromLTRB(
          screenRect.left,
          screenRect.top,
          fadingRect.left + 0.5,
          screenRect.bottom,
        ),
        paint,
      )
      ..drawRect(
        Rect.fromLTRB(
          fadingRect.right - 0.5,
          screenRect.top,
          screenRect.right,
          screenRect.bottom,
        ),
        paint,
      );
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) {
    return color != oldDelegate.color ||
        progress != oldDelegate.progress ||
        opacity != oldDelegate.opacity;
  }
}

class _Foreground extends StatefulWidget {
  const _Foreground({required this.controller});

  final AnimationController controller;

  @override
  State<_Foreground> createState() => __ForegroundState();
}

class __ForegroundState extends State<_Foreground> {
  late final _opacity = TweenSequence<double>(
    [
      TweenSequenceItem(
        tween: Tween(begin: 0.515, end: 0),
        weight: 18 / 75,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0),
        weight: 3 / 75,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1),
        weight: 54 / 75,
      ),
    ],
  ).animate(widget.controller);

  late final _progress = Tween<double>(begin: 0, end: 1)
      .chain(
        CurveTween(
          curve: const Interval(
            _foregroundProgressStart / _animationDuration,
            _foregroundProgressEnd / _animationDuration,
            curve: Cubic(0.72, 0, 0.59, 0.52),
          ),
        ),
      )
      .animate(widget.controller);

  late final _offset = Tween<double>(begin: 0, end: 1)
      .chain(
        CurveTween(
          curve: const Interval(
            _foregroundOffsetStart / _animationDuration,
            _foregroundOffsetEnd / _animationDuration,
            curve: Curves.easeIn,
          ),
        ),
      )
      .animate(widget.controller);

  late final _linesLength = Tween<double>(begin: 0, end: 1)
      .chain(
        CurveTween(
          curve: const Interval(
            _foregroundLinesLengthStart / _animationDuration,
            _foregroundLinesLengthEnd / _animationDuration,
            curve: Curves.easeInOut,
          ),
        ),
      )
      .animate(widget.controller);

  late final _linesGap = Tween<double>(begin: 0, end: 1)
      .chain(
        CurveTween(
          curve: const Interval(
            _foregroundLinesGapStart / _animationDuration,
            _foregroundLinesGapEnd / _animationDuration,
            curve: Cubic(0.77, -0.1, 0.66, 0.73),
          ),
        ),
      )
      .animate(widget.controller);

  late final _uPainter = _ULetterPainter(
    color: _foregroundColor,
    maskColor: _backgroundColor,
    opacity: _opacity,
    progress: _progress,
  );

  late final _bPainter = _BLetterPainter(
    color: _foregroundColor,
    maskColor: _backgroundColor,
    opacity: _opacity,
    progress: _progress,
  );

  late final _ePainter = _ELetterPainter(
    color: _foregroundColor,
    maskColor: _backgroundColor,
    opacity: _opacity,
    progress: _progress,
  );

  late final _rPainter = _RLetterPainter(
    color: _foregroundColor,
    maskColor: _backgroundColor,
    opacity: _opacity,
    progress: _progress,
  );

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _ForegroundLayoutDelegate(
        offset: _offset,
        linesLength: _linesLength,
        linesGap: _linesGap,
      ),
      children: [
        LayoutId(
          id: _ForegroundPart.u,
          child: CustomPaint(painter: _uPainter),
        ),
        LayoutId(
          id: _ForegroundPart.b,
          child: CustomPaint(painter: _bPainter),
        ),
        LayoutId(
          id: _ForegroundPart.e,
          child: CustomPaint(painter: _ePainter),
        ),
        LayoutId(
          id: _ForegroundPart.r,
          child: CustomPaint(painter: _rPainter),
        ),
        LayoutId(
          id: _ForegroundPart.leftLine,
          child: const ColoredBox(color: _foregroundColor),
        ),
        LayoutId(
          id: _ForegroundPart.rightLine,
          child: const ColoredBox(color: _foregroundColor),
        ),
      ],
    );
  }
}

enum _ForegroundPart {
  u,
  b,
  e,
  r,
  leftLine,
  rightLine,
}

class _ForegroundLayoutDelegate extends MultiChildLayoutDelegate {
  _ForegroundLayoutDelegate({
    required this.offset,
    required this.linesLength,
    required this.linesGap,
  }) : super(
          relayout: Listenable.merge([
            offset,
            linesLength,
            linesGap,
          ]),
        );

  final Animation<double> offset;

  final Animation<double> linesLength;

  final Animation<double> linesGap;

  @override
  void performLayout(Size size) {
    const logoSize = Size(155, 54);
    const maxOffset = 32.7;

    final uSize = layoutChild(
      _ForegroundPart.u,
      const BoxConstraints.tightFor(width: 41.84, height: 54),
    );
    final bSize = layoutChild(
      _ForegroundPart.b,
      const BoxConstraints.tightFor(width: 41.55, height: 54),
    );
    final eSize = layoutChild(
      _ForegroundPart.e,
      const BoxConstraints.tightFor(width: 39.05, height: 54),
    );
    final rSize = layoutChild(
      _ForegroundPart.r,
      const BoxConstraints.tightFor(width: 19.42, height: 54),
    );

    final screenRect = Offset.zero & size;
    final logoRect = screenRect.center.translate(
          -logoSize.width / 2,
          -logoSize.height / 2,
        ) &
        logoSize;

    var uRect = logoRect.topLeft & uSize;

    if (offset.value > 0) {
      uRect = uRect.translate(maxOffset * offset.value, 0);
    }

    const ubGap = 5.88;

    final bRect = uRect.topRight.translate(ubGap, 0) & bSize;
    final eRect = bRect.topRight.translate(3.02, 0) & eSize;
    final rRect = eRect.topRight.translate(4.23, 0) & rSize;

    positionChild(_ForegroundPart.u, uRect.topLeft);
    positionChild(_ForegroundPart.b, bRect.topLeft);
    positionChild(_ForegroundPart.e, eRect.topLeft);
    positionChild(_ForegroundPart.r, rRect.topLeft);

    if (linesLength.value == 0 || linesGap.value == 1) {
      layoutChild(
        _ForegroundPart.leftLine,
        const BoxConstraints.tightFor(width: 0, height: 0),
      );
      layoutChild(
        _ForegroundPart.rightLine,
        const BoxConstraints.tightFor(width: 0, height: 0),
      );

      return;
    }

    const initialLineSize = Size(8.5, 54);
    const maxLineWidth = 50;
    final maxLineHeight = screenRect.height;

    final gap = math.max(0, (screenRect.width - ubGap) * linesGap.value);

    final lineSize = Size(
      initialLineSize.width +
          (maxLineWidth - initialLineSize.width) * linesGap.value,
      initialLineSize.height +
          (maxLineHeight - initialLineSize.height) * linesLength.value,
    );

    layoutChild(_ForegroundPart.leftLine, BoxConstraints.tight(lineSize));
    layoutChild(_ForegroundPart.rightLine, BoxConstraints.tight(lineSize));

    final leftLineRect = uRect.centerRight.translate(
          -lineSize.width - gap / 2,
          -lineSize.height / 2,
        ) &
        lineSize;

    positionChild(_ForegroundPart.leftLine, leftLineRect.topLeft);
    positionChild(
      _ForegroundPart.rightLine,
      leftLineRect.topRight.translate(ubGap + gap, 0),
    );
  }

  @override
  bool shouldRelayout(_ForegroundLayoutDelegate oldDelegate) {
    return offset != oldDelegate.offset ||
        linesLength != oldDelegate.linesLength ||
        linesGap != oldDelegate.linesGap;
  }
}

abstract class _LetterPainter extends CustomPainter {
  _LetterPainter({
    required this.color,
    required this.maskColor,
    required this.opacity,
    required this.progress,
  }) : super(repaint: Listenable.merge([opacity, progress]));

  final Color color;

  final Color maskColor;

  final Animation<double> opacity;

  final Animation<double> progress;

  Path? _letterPath;

  List<PathMetric>? _maskPathMetrics;

  Path buildLetterPath();

  Path buildMaskPath();

  @override
  void paint(Canvas canvas, Size size) {
    var letterPath = _letterPath;
    var maskPathMetrics = _maskPathMetrics;

    if (letterPath == null || maskPathMetrics == null) {
      letterPath = buildLetterPath();
      _letterPath = letterPath;

      maskPathMetrics = buildMaskPath().computeMetrics().toList();
      _maskPathMetrics = maskPathMetrics;
    }

    if (progress.value == 1) {
      return;
    }

    canvas.drawPath(
      letterPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color.withOpacity(opacity.value),
    );

    if (progress.value == 0) {
      return;
    }

    for (final metric in maskPathMetrics) {
      final maskPath = metric.extractPath(
        0,
        metric.length * progress.value,
      );

      canvas.drawPath(
        maskPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.5
          ..color = maskColor,
      );
    }
  }

  @override
  bool shouldRepaint(_LetterPainter oldDelegate) {
    return color != oldDelegate.color ||
        maskColor != oldDelegate.maskColor ||
        opacity != oldDelegate.opacity ||
        progress != oldDelegate.progress;
  }
}

class _ULetterPainter extends _LetterPainter {
  _ULetterPainter({
    required super.color,
    required super.maskColor,
    required super.opacity,
    required super.progress,
  });

  @override
  Path buildLetterPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/u.svg file.
    return Path()
      ..moveTo(20.924, 46.871)
      ..cubicTo(28.25, 46.871, 33.914, 41.182, 33.914, 32.764)
      ..lineTo(33.914, 0)
      ..lineTo(41.844, 0)
      ..lineTo(41.844, 53.09)
      ..lineTo(33.99, 53.09)
      ..lineTo(33.99, 48.16)
      ..cubicTo(30.44, 51.876, 25.532, 54, 20.017, 54)
      ..cubicTo(8.687, 54, 0, 45.733, 0, 33.224)
      ..lineTo(0, 0.01)
      ..lineTo(7.93, 0.01)
      ..lineTo(7.93, 32.765)
      ..cubicTo(7.93, 41.335, 13.519, 46.872, 20.922, 46.872)
      ..close();
  }

  @override
  Path buildMaskPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/u_mask.svg file.
    return Path()
      ..moveTo(3.99927, 0)
      ..cubicTo(3.99927, 0, 3.99927, 23.8866, 3.99927, 32.9433)
      ..cubicTo(3.99927, 42, 9.49855, 50.5, 20.9993, 50.5)
      ..cubicTo(30, 50.5, 36, 43.5, 37.9993, 31.9433);
  }
}

class _BLetterPainter extends _LetterPainter {
  _BLetterPainter({
    required super.color,
    required super.maskColor,
    required super.opacity,
    required super.progress,
  });

  @override
  Path buildLetterPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/b.svg file.
    return Path()
      ..moveTo(0.011, 0)
      ..lineTo(7.64, 0)
      ..lineTo(7.64, 19.34)
      ..arcToPoint(
        const Offset(13.894, 15.067),
        radius: const Radius.elliptical(19, 19),
      )
      ..arcToPoint(
        const Offset(21.311, 13.575),
        radius: const Radius.elliptical(19, 19),
      )
      ..cubicTo(32.641, 13.575, 41.553, 22.6, 41.553, 33.825)
      ..cubicTo(41.553, 44.975, 32.641, 53.998, 21.31, 53.998)
      ..arcToPoint(
        const Offset(13.855, 52.51),
        radius: const Radius.elliptical(19.2, 19.2),
      )
      ..arcToPoint(
        const Offset(7.558, 48.235),
        radius: const Radius.elliptical(19.2, 19.2),
      )
      ..lineTo(7.558, 53.087)
      ..lineTo(0, 53.087)
      ..close()
      ..moveTo(20.783, 47.25)
      ..cubicTo(28.035, 47.25, 34.002, 41.257, 34.002, 33.825)
      ..cubicTo(34.002, 26.316, 28.035, 20.401, 20.782, 20.401)
      ..cubicTo(13.455, 20.401, 7.488, 26.316, 7.488, 33.825)
      ..cubicTo(7.488, 41.257, 13.38, 47.25, 20.783, 47.25)
      ..close();
  }

  @override
  Path buildMaskPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/b_mask.svg file.
    return Path()
      ..moveTo(4.00187, 34.1016)
      ..cubicTo(3.86175, 24.7138, 11.613, 17.1016, 21.0019, 17.1016)
      ..cubicTo(30.3907, 17.1016, 38.142, 24.7138, 38.0019, 34.1016)
      ..cubicTo(37.8638, 43.3523, 30.2537, 50.6016, 21.0019, 50.6016)
      ..cubicTo(11.7501, 50.6016, 4.13994, 43.3523, 4.00187, 34.1016)
      ..close();
  }
}

class _ELetterPainter extends _LetterPainter {
  _ELetterPainter({
    required super.color,
    required super.maskColor,
    required super.opacity,
    required super.progress,
  });

  @override
  Path buildLetterPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/e.svg file.
    return Path()
      ..moveTo(19.79, 14)
      ..cubicTo(30.892, 14, 39.05, 22.57, 39.05, 34.099)
      ..lineTo(39.05, 36.602)
      ..lineTo(7.708, 36.602)
      ..cubicTo(8.766, 42.896, 13.977, 47.599, 20.469, 47.599)
      ..cubicTo(24.929, 47.599, 28.704, 45.778, 31.573, 41.909)
      ..lineTo(34.331, 43.958)
      ..lineTo(37.088, 46.005)
      ..cubicTo(33.235, 51.163, 27.494, 54.272, 20.469, 54.272)
      ..cubicTo(8.913, 54.272, 0, 45.626, 0, 34.099)
      ..cubicTo(0, 23.177, 8.535, 14, 19.79, 14)
      ..moveTo(7.855, 30.534)
      ..lineTo(31.346, 30.534)
      ..cubicTo(30.063, 24.618, 25.304, 20.674, 19.639, 20.674)
      ..cubicTo(13.975, 20.674, 9.216, 24.618, 7.855, 30.534)
      ..close();
  }

  @override
  Path buildMaskPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/e_mask.svg file.
    return Path()
      ..moveTo(8.22021, 33.5)
      ..lineTo(35.5, 33.5)
      ..cubicTo(35.5, 33.5, 35.5, 17.5024, 19.7897, 17.5)
      ..cubicTo(8.8433, 17.4984, 4.0745, 25.1525, 4.00059, 34.0986)
      ..cubicTo(3.92445, 43.3141, 11.2546, 50.9031, 20.4699, 51)
      ..cubicTo(29, 51.0849, 34.5, 43.5, 34.5, 43.5);
  }
}

class _RLetterPainter extends _LetterPainter {
  _RLetterPainter({
    required super.color,
    required super.maskColor,
    required super.opacity,
    required super.progress,
  });

  @override
  Path buildLetterPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/r.svg file.
    return Path()
      ..moveTo(16.24, 21.235)
      ..cubicTo(11.255, 21.235, 7.629, 25.103, 7.629, 31.095)
      ..lineTo(7.629, 53.089)
      ..lineTo(0, 53.089)
      ..lineTo(0, 14.409)
      ..lineTo(7.558, 14.409)
      ..lineTo(7.558, 19.191)
      ..cubicTo(9.446, 16.081, 12.544, 14.109, 16.773, 14.109)
      ..lineTo(19.416, 14.109)
      ..lineTo(19.416, 21.239)
      ..close();
  }

  @override
  Path buildMaskPath() {
    // Generated using the Flutter Shape Maker from
    // assets/images/letters/r_mask.svg file.
    return Path()
      ..moveTo(3.81006, 14.1094)
      ..lineTo(3.81006, 53.4094)
      ..moveTo(19.8, 17.6252)
      ..cubicTo(13.7, 17.6094, 5.3999, 18.6108, 3.8999, 30.6096);
  }
}
