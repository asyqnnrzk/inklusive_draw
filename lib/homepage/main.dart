import 'package:flutter/material.dart';
import 'drawer_content.dart';

// main a.k.a homepage

void main() {
  runApp(const InklusiveDraw());
}

const TextStyle appName = TextStyle(
  color: Color(0xFFEC8696),
  fontSize: 36.0,
  fontStyle: FontStyle.italic,
  fontFamily: 'MontserratBoth',
);

const TextStyle textName = TextStyle(
  color: Colors.black54,
  fontSize: 24.0,
  fontFamily: 'MontserratBold',
);

class InklusiveDraw extends StatelessWidget {
  const InklusiveDraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFEC8696),
        ),
        drawer: const DrawerContent(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'InklusiveDraw',
                style: appName
              ),
              const SizedBox(height: 36.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                          primary: const Color(0xFFEC8696)
                        ),
                        child: const Icon(
                          Icons.brush,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Text(
                        "My Gallery",
                        style: textName
                      ),
                    ],
                  ),
                  const SizedBox(height: 36.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                          primary: const Color(0xFFEC8696)
                        ),
                        child: const Icon(
                          Icons.draw,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Text(
                        "Exercise",
                        style: textName
                      ),
                    ],
                  ),
                  const SizedBox(height: 36.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(24),
                          primary: const Color(0xFFEC8696)
                        ),
                        child: const Icon(
                          Icons.group,
                          size: 24.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Text(
                        "Community",
                        style: textName
                      ),
                    ],
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
