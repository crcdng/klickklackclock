import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'clock_painter.dart';

class KlickKlackClock extends StatefulWidget {
  const KlickKlackClock(this.model);

  final ClockModel model;

  @override
  _KlickKlackClockState createState() => _KlickKlackClockState();
}

class _KlickKlackClockState extends State<KlickKlackClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(KlickKlackClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _condition = widget.model.weatherString;
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';

      // uncomment to check values in the console
      // print(' $_condition / $_temperature / $_temperatureRange ');
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // uncomment to check values in the console
      // print(
      //     '${DateFormat('HH').format(_dateTime)} : ${DateFormat('mm').format(_dateTime)} : ${DateFormat('ss').format(_dateTime)}');
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
            painter: ClockPainter(
                _dateTime.hour,
                _dateTime.minute,
                _dateTime.second,
                _condition,
                _temperature,
                _temperatureRange)));
  }
}
