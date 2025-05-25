import 'dart:math';
import 'package:flutter/material.dart';

class Confetti extends StatefulWidget {
  final int pieces;
  final Duration duration;
  final AnimationController? controller;
  const Confetti({super.key, this.pieces = 20, this.duration = const Duration(seconds: 2), this.controller});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ConfettiPiece> _confetti;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        AnimationController(vsync: this, duration: widget.duration);
    if (widget.controller == null) {
      _controller.forward();
    }
    final rand = Random();
    _confetti = List.generate(widget.pieces, (_) => _ConfettiPiece(rand));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _ConfettiPainter(_confetti, _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiPiece {
  final double startX;
  final double speed;
  final double amplitude;
  final double size;
  final Color color;
  final double rotation;
  final double rotationSpeed;

  _ConfettiPiece(Random rand)
      : startX = rand.nextDouble(),
        speed = 0.5 + rand.nextDouble() * 0.5,
        amplitude = rand.nextDouble() * 20 + 10,
        size = rand.nextDouble() * 4 + 4,
        color = Colors.primaries[rand.nextInt(Colors.primaries.length)],
        rotation = rand.nextDouble() * pi,
        rotationSpeed = rand.nextDouble() * 2 - 1;
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> confetti;
  final double progress;
  _ConfettiPainter(this.confetti, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final t = Curves.easeOut.transform(progress);
    for (final c in confetti) {
      final y = size.height * t * c.speed;
      final x = c.startX * size.width + sin(y / 20 + c.rotation) * c.amplitude;
      final paint = Paint()..color = c.color.withOpacity(1 - progress);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * c.rotationSpeed);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: c.size, height: c.size),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
