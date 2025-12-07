import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:nds_gui_kit/canvas/image_cache.dart';
import 'package:nds_gui_kit/canvas/nds_canvas.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kPseudoKey = 'nds_pseudo';
const String _kDefaultPseudo = 'Hello';

/// Top screen canvas implementation
class TopScreenCanvas extends StatefulWidget {
  const TopScreenCanvas({super.key});

  @override
  State<TopScreenCanvas> createState() => _TopScreenCanvasState();
}

class _TopScreenCanvasState extends State<TopScreenCanvas> {
  late TopScreenPainter _painter;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _painter = TopScreenPainter();
    _loadResources();
  }

  Future<void> _loadResources() async {
    await _painter.initialize();
    if (mounted) {
      setState(() => _isLoaded = true);
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const SizedBox.shrink();
    }

    return NDSCanvas(
      painter: _painter,
      onTap: (pos) => _painter.handleTap(context, pos),
    );
  }
}

/// Painter for the top screen
class TopScreenPainter extends NDSCanvasPainter {
  Timer? _timer;
  final Battery _battery = Battery();

  // Cached images
  ui.Image? _bgTile;
  ui.Image? _topBarBg;
  ui.Image? _topBarDivider;
  ui.Image? _clockImage;
  ui.Image? _calendarImage;
  ui.Image? _batteryImage;

  // State
  DateTime _currentTime = DateTime.now();
  int _batteryLevel = 100;
  String _pseudo = _kDefaultPseudo;

  // Layout constants
  static const double topBarHeight = 16;
  static const double clockX = 15;
  static const double clockY = 47;
  static const double clockRadius = 48;
  static const double calendarX = 127;
  static const double calendarY = 32;

  Future<void> initialize() async {
    final cache = NDSImageCache.instance;

    // Load all images
    _bgTile = await cache.loadImage('assets/images/bg_tile_top.png');
    _topBarBg = await cache.loadImage('assets/images/top_bar_bg_1.png');
    _topBarDivider = await cache.loadImage('assets/images/top_bar_divider.png');
    _clockImage = await cache.loadImage('assets/images/clock.png');
    _calendarImage = await cache.loadImage('assets/images/calendar.png');
    _batteryImage = await cache.loadImage('assets/images/battery.png');

    // Load pseudo
    final prefs = await SharedPreferences.getInstance();
    _pseudo = prefs.getString(_kPseudoKey) ?? _kDefaultPseudo;

    // Get initial battery level
    _batteryLevel = await _battery.batteryLevel;

    // Listen to battery changes
    _battery.onBatteryStateChanged.listen((_) async {
      _batteryLevel = await _battery.batteryLevel;
      notifyListeners();
    });

    // Start timer for clock updates
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentTime = DateTime.now();
      notifyListeners();
    });

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void handleTap(BuildContext context, Offset position) {
    // Check if pseudo area was tapped (top-left area)
    if (position.dx < 80 && position.dy < topBarHeight) {
      _showEditPseudoDialog(context);
    }
  }

  void _showEditPseudoDialog(BuildContext context) async {
    final controller = TextEditingController(text: _pseudo);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Edit Pseudo', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your pseudo',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPseudoKey, result);
      _pseudo = result;
      notifyListeners();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas);

    // Draw top bar
    _drawTopBar(canvas);

    // Draw clock
    _drawClock(canvas);

    // Draw calendar
    _drawCalendar(canvas);
  }

  void _drawBackground(Canvas canvas) {
    if (_bgTile == null) return;

    // Tile the background starting slightly offset
    drawImageTiled(
      canvas,
      _bgTile!,
      Rect.fromLTWH(0, 0, kNDSWidth + 18, kNDSHeight.toDouble()),
    );
  }

  void _drawTopBar(Canvas canvas) {
    if (_topBarBg == null) return;

    // Draw top bar background tiled
    drawImageTiled(
      canvas,
      _topBarBg!,
      Rect.fromLTWH(0, 0, kNDSWidth.toDouble(), topBarHeight),
    );

    // Draw pseudo
    drawText(canvas, _pseudo, const Offset(4, 3));

    // Calculate positions for right-aligned items
    final timeStr =
        '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}';
    final dateStr =
        '${_currentTime.day.toString().padLeft(2, '0')}/${_currentTime.month.toString().padLeft(2, '0')}';
    double rightX = kNDSWidth - 4;

    // Draw battery (rightmost)
    _drawBatteryIndicator(canvas, rightX);
    rightX -= 34;

    // Draw divider
    if (_topBarDivider != null) {
      drawImage(canvas, _topBarDivider!, Offset(rightX, 0));
      rightX -= _topBarDivider!.width + 2;
    }

    // Draw date
    drawText(canvas, dateStr, Offset(rightX, 3), textAlign: TextAlign.right);
    rightX -= 24;

    // Draw divider
    if (_topBarDivider != null) {
      drawImage(canvas, _topBarDivider!, Offset(rightX, 0));
      rightX -= _topBarDivider!.width + 2;
    }

    // Draw time
    drawText(canvas, timeStr, Offset(rightX, 3), textAlign: TextAlign.right);
  }

  void _drawBatteryIndicator(Canvas canvas, double rightX) {
    final batteryStr = '$_batteryLevel%';

    // Calculate battery color
    final normalizedLevel = _batteryLevel / 100.0;
    Color batteryColor;
    if (normalizedLevel <= 0.2) {
      final t = normalizedLevel / 0.2;
      batteryColor = Color.lerp(Colors.red, Colors.yellow, t)!;
    } else {
      final t = (normalizedLevel - 0.2) / 0.8;
      batteryColor = Color.lerp(Colors.yellow, Colors.green, t)!;
    }

    // Draw battery text
    drawText(
      canvas,
      batteryStr,
      Offset(rightX - 11, 3),
      textAlign: TextAlign.right,
    );

    // Draw battery icon and fill
    if (_batteryImage != null) {
      final batteryX = rightX - 10;
      final batteryY = 2.0;

      // Draw battery fill
      final fillWidth = 11 * _batteryLevel / 100;
      drawRect(
        canvas,
        Rect.fromLTWH(batteryX, batteryY + 3, fillWidth, 5),
        batteryColor,
      );

      drawImage(canvas, _batteryImage!, Offset(batteryX, batteryY));
    }
  }

  void _drawClock(Canvas canvas) {
    if (_clockImage == null) return;

    // Draw clock background
    drawImage(canvas, _clockImage!, const Offset(clockX, clockY));

    // Calculate clock center
    final centerX = clockX + _clockImage!.width / 2;
    final centerY = clockY + _clockImage!.height / 2;

    final seconds = _currentTime.second.toDouble();
    final minutes = _currentTime.minute.toDouble();
    final hours = _currentTime.hour.toDouble();

    // Angles (offset by -π/2 to start at 12 o'clock)
    final secondsAngle = (seconds / 60) * 2 * pi - pi / 2;
    final minutesAngle = ((minutes + seconds / 60) / 60) * 2 * pi - pi / 2;
    final hoursAngle = (((hours % 12) + minutes / 60) / 12) * 2 * pi - pi / 2;

    // Draw hour hand
    _drawClockHand(canvas, centerX, centerY, hoursAngle, 28, Colors.grey[600]!);

    // Draw minute hand
    _drawClockHand(
      canvas,
      centerX,
      centerY,
      minutesAngle,
      35,
      Colors.grey[700]!,
    );

    // Draw second hand
    _drawClockHand(canvas, centerX, centerY, secondsAngle, 40, Colors.red);

    // Draw center dot
    drawRect(
      canvas,
      Rect.fromCenter(center: Offset(centerX, centerY), width: 5, height: 5),
      Colors.grey[700]!,
    );
  }

  void _drawClockHand(
    Canvas canvas,
    double cx,
    double cy,
    double angle,
    double length,
    Color color,
  ) {
    final endX = cx + cos(angle) * length;
    final endY = cy + sin(angle) * length;
    drawLine(canvas, Offset(cx, cy), Offset(endX, endY), color, strokeWidth: 2);
  }

  void _drawCalendar(Canvas canvas) {
    if (_calendarImage == null) return;

    // Draw calendar background
    drawImage(canvas, _calendarImage!, const Offset(calendarX, calendarY));

    final year = _currentTime.year;
    final month = _currentTime.month;
    final today = _currentTime.day;

    // Draw month/year header
    final headerText = '${month.toString().padLeft(2, '0')} / $year';
    drawText(
      canvas,
      headerText,
      Offset(calendarX + _calendarImage!.width / 2, calendarY + 3.5),
      color: Colors.grey[800]!,
      textAlign: TextAlign.center,
    );

    // Draw weekday header
    final weekdays = ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'];
    const cellWidth = 16.0;
    const cellHeight = 16.0;
    const headerHeight = 14.5;
    const weekdayHeight = 16.0;

    for (int i = 0; i < 7; i++) {
      drawText(
        canvas,
        weekdays[i],
        Offset(
          calendarX + 2 + i * cellWidth + cellWidth / 2,
          calendarY + headerHeight + 5,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Draw days grid
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    int startWeekday = firstDayOfMonth.weekday % 7;

    int dayCounter = 1;
    final totalCells = startWeekday + daysInMonth;
    final numWeeks = (totalCells / 7).ceil();

    for (int week = 0; week < numWeeks; week++) {
      for (int weekday = 0; weekday < 7; weekday++) {
        final cellIndex = week * 7 + weekday;

        if (cellIndex >= startWeekday && dayCounter <= daysInMonth) {
          Color textColor;
          if (weekday == 0) {
            textColor = const Color(0xFFE00080);
          } else if (weekday == 6) {
            textColor = const Color(0xFF0000FF);
          } else {
            textColor = const Color(0xFF404040);
          }

          final cellX = calendarX + 2 + weekday * cellWidth + cellWidth / 2;
          final cellY =
              calendarY + headerHeight + weekdayHeight + 2 + week * cellHeight;

          if (dayCounter == today) {
            // Draw highlight box for today
            final boxRect = Rect.fromCenter(
              center: Offset(cellX, cellY + cellHeight / 2),
              width: 11,
              height: 11,
            );
            drawRect(canvas, boxRect, const Color.fromARGB(64, 0, 0, 255));
            drawRectBorder(canvas, boxRect, const Color(0xFF0000FF));
          }

          drawText(
            canvas,
            dayCounter.toString(),
            Offset(cellX, cellY + 3.5),
            color: textColor,
            textAlign: TextAlign.center,
          );

          dayCounter++;
        }
      }
    }
  }
}
