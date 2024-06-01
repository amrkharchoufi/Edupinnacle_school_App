import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edupinacle/staff/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _registrationEnabled = false;
  Color _appColor = Colors.blue; // Initial app color
  bool isLoaded = true;

  void _updateRegistrationStatus(bool newValue) {
    FirebaseFirestore.instance.collection('App').doc('myapp').update({
      'inscription': newValue
          ? 'true'
          : 'false', // Convert bool to string 'true' or 'false'
    }).then((_) {
      // Update local state after successful update
      setState(() {
        _registrationEnabled = newValue;
      });
    }).catchError((error) {
      // Handle error if update fails
      print('Failed to update registration status: $error');
    });
  }

  void _fetchRegistrationStatus() async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('App').doc('myapp').get();
    String? inscription = snapshot.get('inscription') as String?;
    int colorValue = snapshot.get('primaryColor') as int;
    setState(() {
      _registrationEnabled = inscription == 'true'; // Update local state
      _appColor = Color(colorValue); // Update app color
    });
  } catch (error) {
    // Handle error if fetching fails
    print('Failed to fetch registration status or app color: $error');
  } finally {
    // Set isLoaded to false regardless of success or failure
    setState(() {
      isLoaded = false;
    });
  }
}

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _appColor,
              onColorChanged: (color) {
                setState(() {
                  _appColor = color;
                });
              },
              // ignore: deprecated_member_use
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('App')
                    .doc('myapp')
                    .update({
                  'primaryColor': _appColor.value, // Save color as an integer value
                }).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print('Failed to update app color: $error');
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRegistrationStatus(); // Fetch initial registration status and app color
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor:  AppColors.primaryColor,
      ),
      body: isLoaded
      ? const Center(child: CircularProgressIndicator())
      :SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'INSCRIPTION',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const Divider(
                thickness: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Open Registration :',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _registrationEnabled,
                    onChanged: (newValue) {
                      // Call function to update registration status
                      _updateRegistrationStatus(newValue);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'App Settings',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const Divider(
                thickness: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'App color :',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _pickColor,
                    child: const Text('Pick Color'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: _appColor, // Button text color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
