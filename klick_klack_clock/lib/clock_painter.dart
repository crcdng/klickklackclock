import 'dart:ui';
import 'package:flutter/material.dart';
import 'colors.dart';

class ClockPainter extends CustomPainter {
  int hours, minutes, seconds;
  String condition, temperature, temperatureRange;
  final Paint hourPaint = Paint()..style = PaintingStyle.fill;
  final Paint minutePaint = Paint()..style = PaintingStyle.fill;
  final Paint secondPaint = Paint()..style = PaintingStyle.fill;
  final Paint conditionPaint = Paint()..style = PaintingStyle.fill;
  final Paint temperaturePaint = Paint()..style = PaintingStyle.fill;

  ClockPainter(this.hours, this.minutes, this.seconds, this.condition,
      this.temperature, this.temperatureRange);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final grid =
        width / 125; // given a 5:3 ratio, base everything on a 125 x 75 grid
    final horizontalPad = 3 * grid;
    final verticalPad = 2 * grid;
    final hourColumn = 2;
    final hourRow = 2;
    final minuteColumn = 8;
    final minuteRow = 2;
    final conditionLength = 4;
    final conditionColumn = 2;
    final conditionRow = 9;
    final temperatureLength = 10;
    final temperatureColumn = 8;
    final temperatureRow = 9;
    final spacing = grid;
    final elementSize = 5 * grid;
    var x, y;

    // hours
    for (var h = 0; h <= hours; h++) {
      if (h == 0) {
        continue;
      }
      hourPaint.color =
          Color.fromARGB(9 + h * 9, color1['r'], color1['g'], color1['b']);
      paintElement(
          canvas,
          horizontalPad +
              (hourColumn + ((h - 1) % 4)) * (elementSize + spacing),
          verticalPad + (hourRow + ((h - 1) ~/ 4)) * (elementSize + spacing),
          elementSize,
          elementSize,
          hourPaint);
    }

    // minutes
    for (var m = 0; m <= minutes; m++) {
      if (m == 0) {
        continue;
      }
      minutePaint.color =
          Color.fromARGB(45 + m * 3, color5['r'], color5['g'], color5['b']);
      paintElement(
          canvas,
          horizontalPad +
              (minuteColumn + ((m - 1) % 10)) * (elementSize + spacing),
          verticalPad + (minuteRow + ((m - 1) ~/ 10)) * (elementSize + spacing),
          elementSize,
          elementSize,
          minutePaint);
    }

    // seconds
    for (var s = 0; s <= seconds; s++) {
      if (s == 0) {
        continue;
      }
      secondPaint.color =
          Color.fromARGB(45 + s * 3, color2['r'], color2['g'], color2['b']);
      if (s >= 1 && s <= 20) {
        x = horizontalPad + (s - 1) * (elementSize + spacing);
        y = verticalPad;
      } else if (s >= 21 && s <= 30) {
        x = horizontalPad + 19 * (elementSize + spacing);
        y = verticalPad + ((s - 1) % 19) * (elementSize + spacing);
      } else if (s >= 31 && s <= 50) {
        x = horizontalPad + (19 - ((s - 1) % 30)) * (elementSize + spacing);
        y = verticalPad + 11 * (elementSize + spacing);
      } else if (s >= 51 && s <= 60) {
        x = horizontalPad;
        y = verticalPad + (10 - ((s - 1) % 50)) * (elementSize + spacing);
      }
      paintElement(canvas, x, y, elementSize, elementSize, secondPaint);
    }

    // condition
    switch (condition) {
      case 'cloudy':
        conditionPaint.color = Color.fromARGB(128, 128, 128, 128);
        break;
      case 'windy':
        conditionPaint.color = Color.fromARGB(128, 128, 128, 200);
        break;
      case 'foggy':
        conditionPaint.color = Color.fromARGB(128, 167, 167, 167);
        break;
      case 'rainy':
        conditionPaint.color = Color.fromARGB(128, 47, 33, 200);
        break;
      case 'snowy':
        conditionPaint.color = Color.fromARGB(128, 200, 200, 212);
        break;
      case 'sunny':
        conditionPaint.color = Color.fromARGB(128, 255, 239, 13);
        break;
      case 'thunderstorm': // red alert
        conditionPaint.color = Color.fromARGB(200, 255, 12, 27);
        break;
      default:
        conditionPaint.color = Color.fromARGB(255, 255, 255, 255);
    }

    for (var c = 0; c < conditionLength; c++) {
      paintElement(
          canvas,
          horizontalPad + (conditionColumn + c) * (elementSize + spacing),
          verticalPad + conditionRow * (elementSize + spacing),
          elementSize,
          elementSize,
          conditionPaint);
    }

    // temperature
    // TODO in production: robust parsing (RegEx)
    var temp =
        double.tryParse(temperature.substring(0, temperature.length - 2)) ??
            0.0;
    var low = double.tryParse(temperatureRange.substring(1, 5)) ?? 0.0;
    var high = double.tryParse(temperatureRange.substring(8, 12)) ?? 1.0;
    var index = (((temp - low) / (high - low)) * 10).toInt();
    var isCelsius =
        temperature.substring(temperature.length - 1, temperature.length) ==
            'C';

    if (!isCelsius) {
      temp = (temp - 32.0) / 1.8;
    } // to Celsius
    var rgbTemp = ((temp + 20) * 3).toInt();

    for (var t = 0; t < temperatureLength; t++) {
      temperaturePaint.color = Color.fromARGB(t == index ? 178 : 88, rgbTemp,
          11, 255 - rgbTemp); // warmer -> more red
      paintElement(
          canvas,
          horizontalPad + (temperatureColumn + t) * (elementSize + spacing),
          verticalPad + temperatureRow * (elementSize + spacing),
          elementSize,
          elementSize,
          temperaturePaint);
    }
  }

  void paintElement(
      Canvas canvas, double x, double y, double w, double h, Paint p) {
    canvas.drawRRect(
        RRect.fromLTRBR(x, y, x + w, y + h, Radius.circular(8)), p);
  }

  @override
  bool shouldRepaint(ClockPainter oldDelegate) {
    // repaint if any of the time based values has changed
    return (oldDelegate.hours != hours ||
        oldDelegate.minutes != minutes ||
        oldDelegate.seconds != seconds);
  }
}
