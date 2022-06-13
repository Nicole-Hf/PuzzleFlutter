// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:puzzle_kids/pages/second_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/homepage_image.PNG"),
              fit: BoxFit.cover,
            )
          )
        ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 100),
          child: ClipOval(
            child: Container(
              color: Colors.white,
              child: Container(
                width: 210.0,
                height: 210.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/buttons/play_button.png"),
                    fit: BoxFit.cover
                  )
                ),
                child: FlatButton(
                  padding: const EdgeInsets.all(0.0),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(
                      builder: (BuildContext context) => const SecondPage(),
                    ));
                  },
                  child: const Center(),
                ),
              ),
            ),
          ),
        )   
      ])
    );
  }
}