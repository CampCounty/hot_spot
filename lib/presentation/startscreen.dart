import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/hintergründe/bg_startscreen.png',
                ),
              ),
            ),
          ),

          // Overlay image
          Positioned(
            top: 130,
            left: 100,
            child: Container(
              child: Image.asset(
                'assets/images/grafiken/chick cupcakes_3D.png',
                fit: BoxFit.cover,
              ),
              height: 400,
              width: 400,
            ),
          ),
          Positioned(
            top: 400,
            left: 30,
            child: Image.asset('assets/images/details/T2.png'),
          ),
          Positioned(
            bottom: 40,
            left: 100,
            child: Container(
              width: 230, // Fixed width
              height: 150, // Fixed height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                color: Color.fromARGB(
                    163, 244, 244, 244), // Background color with transparency
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Shadow color
                    blurRadius: 10.0, // Blur radius
                    offset: Offset(0.0, 10.0), // Shadow offset
                    spreadRadius: 5.0, // Spread radius
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Text hier',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
