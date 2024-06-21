import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool? status;
  bool isLoading = true; // More descriptive variable name

  Future<void> getData() async {
    try {
      DocumentSnapshot result = await FirebaseFirestore.instance.collection('App').doc('myapp').get();
      setState(() {
        status = result.get('inscription');
        print(status);
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Even in case of error, stop loading
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    left: -50,
                    child: Image.asset("assets/images/main_top.png"),
                  ),
                  Positioned(
                    bottom: -20,
                    left: 0,
                    child: Image.asset("assets/images/main_bottom.png"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "WELCOME TO EDUPINACLE",
                          style: TextStyle(fontFamily: "myfont", fontSize: 17),
                        ),
                        const SizedBox(height: 40),
                        SvgPicture.asset("assets/icons/chat.svg"),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 280,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Colors.purple),
                              foregroundColor: WidgetStateProperty.all(Colors.white),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 5),
                              ),
                            ),
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (status == true)
                          SizedBox(
                            width: 280,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/signup");
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(Colors.red[100]),
                                foregroundColor: WidgetStateProperty.all(Colors.grey[800]),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 5),
                                ),
                              ),
                              child: const Text(
                                "PREINSCRIPTION",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
