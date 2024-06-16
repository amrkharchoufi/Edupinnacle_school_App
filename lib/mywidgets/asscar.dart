// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';

class Assigncard extends StatefulWidget {
  final String module;
  final String dateass;
  final String lastdate;
  final String status;
  final String Title;
  const Assigncard({
    super.key,
    required this.module,
    required this.Title,
    required this.dateass,
    required this.lastdate,
    required this.status,
  });
  State<Assigncard> createState() => _AssigncardState();
}

class _AssigncardState extends State<Assigncard> {
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

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: const Color.fromARGB(255, 244, 218, 248),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: primaryColor, // Border color
            width: 1, // Border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                    color: brightenColor(primaryColor, 0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  widget.module,
                  style: TextStyle(color: primaryColor, fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.Title,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "myfont1"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assign Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Last Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Status"),
                      ]),
                  Column(children: [
                    Text(widget.dateass),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.lastdate),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.status),
                  ])
                ],
              ),
              const SizedBox(height: 20),
              if (widget.status == "Not Submitted")
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(primaryColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                    child: const Text(
                      "To be Submitted",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

class Assignprcard extends StatefulWidget {
  final String module;
  final String dateass;
  final String lastdate;
  final String Title;
  final Function delete;
  final String? link;
  final String? filename;

  const Assignprcard({
    super.key,
    required this.module,
    required this.Title,
    required this.dateass,
    required this.lastdate,
    required this.delete,
    this.link, this.filename,
  });
  State<Assignprcard> createState() => _AssignprcardState();
}

class _AssignprcardState extends State<Assignprcard> {
  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Refresh the colors every 5 seconds
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

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: brightenColor(primaryColor, 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: primaryColor, // Border color
            width: 1, // Border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                        color: brightenColor(primaryColor, 0.4),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      widget.module,
                      style: TextStyle(color: primaryColor, fontSize: 15),
                    ),
                  ),
                  MaterialButton(
                    onPressed:
                        widget.delete != null ? () => widget.delete!() : null,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.Title,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "myfont1"),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Assign Date"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Last Date"),
                        SizedBox(
                          height: 5,
                        ),
                      ]),
                  Column(children: [
                    Text(widget.dateass),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(widget.lastdate),
                    const SizedBox(
                      height: 5,
                    ),
                  ])
                ],
              ),
              const SizedBox(height: 20),
                if (widget.link != null && widget.link!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Link :"),
                  Text(widget.link!),
                  const SizedBox(height: 10),
                ],
              ),
            if (widget.filename != null && widget.filename!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("File Link:"),
                  Text(
                    widget.filename!,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 10),
            ],
          ),
            ])
        ));
  }
}
