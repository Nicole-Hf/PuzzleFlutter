// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:puzzle_kids/pages/level_page.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image.png"),
              fit: BoxFit.cover,
            )
          )
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRect(
                child: Container(
                  width: 300.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/buttons/crear.png'),
                      fit: BoxFit.cover
                    )
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(
                        builder: (BuildContext context) => const LevelPage(),
                      ));
                    },
                    child: Container(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0,),
            Center(
              child: ClipRect(
                child: Container(
                  width: 300.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/buttons/join_button.png'),
                      fit: BoxFit.cover
                    )
                  ),
                  child: TextButton(
                    onPressed: () {
                      debugPrint('Button cliked');
                    },
                    child: Container(),
                  ),
                ),
              ),
            ),
          ],
        )
      ])
    );
  }
}