import 'dart:async';

import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Myinput extends StatefulWidget {
  final String label;
  final Widget? preficon;
  final Widget? suficon;
  final bool obscure;
  final double? width;
  final TextEditingController mycontrol;
  final TextInputType type;
  const Myinput(
      {super.key,
      required this.label,
      this.preficon,
      this.suficon,
      this.width,
      required this.type,
      required this.obscure,
      required this.mycontrol});

  @override
  State<Myinput> createState() => _MyinputState();
}

class _MyinputState extends State<Myinput> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      print("Timer triggered. Refreshing colors...");
      _initializeColors();
    });
  }

  Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  bool obb = false;
  @override
  void initState() {
    obb = widget.obscure;
    super.initState();
    _startTimer();
  }

  void hidden() {
    setState(() {
      obb = !obb;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      widget.mycontrol.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 280,
      child: TextFormField(
        readOnly: widget.type == TextInputType.datetime,
        keyboardType: widget.type,
        controller: widget.mycontrol,
        obscureText: widget.obscure,
        onTap: () {
          if (widget.type == TextInputType.datetime) {
            _selectDate(context);
          }
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            filled: true,
            fillColor: brightenColor(primaryColor, 0.5),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(27),
                borderSide: BorderSide.none),
            hintText: '${widget.label} :',
            prefixIcon: widget.preficon,
            suffixIcon: widget.suficon),
        validator: (value) {
          if (value!.isEmpty) {
            return "*${widget.label} required";
          }
          return null;
        },
      ),
    );
  }
}
// Make sure you import the intl package

class Myinput1 extends StatefulWidget {
  final String label;
  final double? width;
  final Widget? preficon;
  final Widget? suficon;
  final bool obscure;
  final TextEditingController mycontrol;
  final TextInputType type;
  const Myinput1(
      {super.key,
      required this.label,
      this.preficon,
      this.suficon,
      required this.type,
      required this.obscure,
      required this.mycontrol, this.width});

  @override
  State<Myinput1> createState() => _Myinput1State();
}

class _Myinput1State extends State<Myinput1> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
      print("Timer triggered. Refreshing colors...");
      _initializeColors();
    });
  }

  Color brightenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    HSLColor hslColor = HSLColor.fromColor(color);
    HSLColor brighterHslColor = hslColor.withLightness(
      (hslColor.lightness + amount).clamp(0.0, 1.0),
    );
    return brighterHslColor.toColor();
  }

  Color primaryColor = AppColors.primaryColor;

  bool isLoaded = false;
  Future<void> _initializeColors() async {
    await AppColors.initialize();
    setState(() {
      primaryColor = AppColors.primaryColor;

      isLoaded = true;
    });
  }

  bool obb = false;
  @override
  void initState() {
    obb = widget.obscure;
    super.initState();
    _startTimer();
  }

  void hidden() {
    setState(() {
      obb = !obb;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      setState(() {
        widget.mycontrol.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        keyboardType: widget.type,
        controller: widget.mycontrol,
        obscureText: widget.obscure,
        readOnly: widget.type ==
            TextInputType.datetime, // Make it read-only if it's a date
        onTap: () {
          if (widget.type == TextInputType.datetime) {
            _selectDate(context);
          }
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            filled: true,
            fillColor: brightenColor(primaryColor, 0.5),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(27),
                borderSide: BorderSide.none),
            hintText: '${widget.label} :',
            prefixIcon: widget.preficon,
            suffixIcon: widget.suficon),
        validator: (value) {
          if (value!.isEmpty) {
            return "*${widget.label} required";
          }
          return null;
        },
      ),
    );
  }
}
