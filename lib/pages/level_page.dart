// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:puzzle_kids/pages/up_page.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({Key? key}) : super(key: key);

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
                      image: AssetImage('assets/buttons/easy_button.png'),
                      fit: BoxFit.cover
                    )
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(
                        builder: (BuildContext context) => const TableroPage(),
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
                      image: AssetImage('assets/buttons/medium_button.png'),
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
            const SizedBox(height: 50.0,),
            Center(
              child: ClipRect(
                child: Container(
                  width: 300.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/buttons/hard_button.png'),
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