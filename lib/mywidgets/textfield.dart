import 'package:flutter/material.dart';

class Myinput extends StatefulWidget {
  final String label;
  final Widget? preficon;
  final Widget? suficon;
  final bool obscure;
  final TextEditingController mycontrol;
  final TextInputType type;
  const Myinput(
      {super.key,
      required this.label,
      this.preficon,
      this.suficon,
      required this.type,
      required this.obscure,
      required this.mycontrol});

  @override
  State<Myinput> createState() => _MyinputState();
}

class _MyinputState extends State<Myinput> {
  bool obb = false;
  @override
  void initState() {
    obb = widget.obscure;
    super.initState();
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
      width: 280,
      child: TextFormField(
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
            fillColor: Colors.purple[50],
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
