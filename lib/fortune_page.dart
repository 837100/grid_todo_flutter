import 'dart:math';

import 'package:flutter/material.dart';

class RouletteWheel extends StatefulWidget {
  final List<String> items;
  final List<Color> colors;

  const RouletteWheel({super.key, required this.items, required this.colors});

  @override
  State<RouletteWheel> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  double _angle = 0;
  int _selectedItem = 0;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
          _selectedItem = _calculateSelectedItem(_angle);
          _showResultDialog();
        });
      }
    });
  }

  int _calculateSelectedItem(double angle) {
    double normalizedAngle = angle % (2 * pi);
    double sectionAngle = (2 * pi) / widget.items.length;
    int selectedIndex = (normalizedAngle / sectionAngle).floor();

    return (widget.items.length - selectedIndex - 3) % widget.items.length;
  }

  void _spin() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      double targetAngle = _angle +
          (2 * pi * (5 + _random.nextInt(5))) +
          (_random.nextDouble() * pi);

      _angle = targetAngle;

      _animation = Tween<double>(
        begin: 0,
        end: targetAngle,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCirc,
      ));

      _controller.reset();
      _controller.forward();
    });
  }

  void _showResultDialog() {
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('결과'),
          content: Text('오늘은 ${widget.items[_selectedItem]}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              //룰렛 휠
              Transform.rotate(
                angle: _isSpinning ? _animation.value : _angle,
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: RoulettePainter(
                    items: widget.items,
                    colors: widget.colors,
                  ),
                ),
              ),
              // 중앙 원
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              // 화살표 표시
              Positioned(
                top: 0,
                child: CustomPaint(
                  size: const Size(20, 40),
                  painter: ArrowPainter(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _isSpinning ? null : _spin,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: Text(_isSpinning ? '돌아가는 중...' : '룰렛 돌리기'),
        ),
        if (!_isSpinning && _controller.status == AnimationStatus.completed)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              '결과: ${widget.items[_selectedItem]}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path();
    // 삼각형 그리기 - 위쪽 꼭지점부터 시작

    path.moveTo(size.width / 2, 0); // 상단 중앙
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoulettePainter extends CustomPainter {
  final List<String> items;
  final List<Color> colors;

  RoulettePainter({required this.items, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 각 섹션의 각도 계산
    final sectionAngle = 2 * pi / items.length;

    // 각 섹션 그리기
    for (int i = 0; i < items.length; i++) {
      final paint = Paint()..color = colors[i % colors.length];

      // 섹션 그리기
      canvas.drawArc(
        rect,
        i * sectionAngle,
        sectionAngle,
        true,
        paint,
      );

      // 텍스트 그리기

      String originalText = items[i];
      int breakPoint = (originalText.length / 2).floor();
      String text = originalText.substring(0, breakPoint) +
          '\n' +
          originalText.substring(breakPoint);
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: 2,
      );
      textPainter.layout();

      // 텍스트 위치 게산 (섹션 중앙)
      final textAngle = i * sectionAngle + (sectionAngle / 2);
      final textRadius = radius * 0.7; // 가장자리에서 약간 안쪽으로
      final textX = center.dx + textRadius * cos(textAngle);
      final textY = center.dy + textRadius * sin(textAngle);

      // 텍스트 회전 및 위치 조정
      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle + pi / 2); // 텍스트를 섹션에 맞게 회전
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FortunePage extends StatelessWidget {
  const FortunePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      '창의력이 샘솟는 날',
      '정리 하는 날',
      '소비 하는 날',
      '행운이 따르는 날',
      '도전을 하는 날',
      '휴식 하는 날',
      '자기계발 하는 날',
      '인연을 만나는 날',
    ];

    final List<Color> colors = [
      Colors.blue,
      Colors.greenAccent,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
    ];

    return MaterialApp(
      title: '오늘은 어떤 주제로 살아갈까?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('오늘은 어떤 주제로 살아갈까?'),
        ),
        body: Center(
          child: RouletteWheel(items: items, colors: colors),
        ),
      ),
    );
  }
}
