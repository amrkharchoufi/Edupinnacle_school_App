import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Welcome extends StatelessWidget {
  static bool status=true;
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(children: [
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
                const Text("WELCOME TO EDUPINACLE",
                    style: TextStyle(fontFamily: "myfont", fontSize: 17)),
                const SizedBox(
                  height: 40,
                ),
                SvgPicture.asset("assets/icons/chat.svg"),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.purple),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 5))),
                    child: const Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if(status==true)
                SizedBox(
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.red[100]),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.grey[800]),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 5))),
                    child: const Text(
                      "PREINSCRIPTION",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
