import 'package:flutter/material.dart';
import 'drawer_content.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

const TextStyle appName = TextStyle(
  color: Color(0xFF58B9A1),
  fontSize: 36.0,
  fontStyle: FontStyle.italic,
  fontFamily: 'MontserratBoth',
);

const TextStyle textName = TextStyle(
  color: Colors.black54,
  fontSize: 24.0,
  fontFamily: 'MontserratBold',
);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF58B9A1),
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
                          backgroundColor: const Color(0xFF58B9A1),
                          padding: const EdgeInsets.all(24)
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
                          backgroundColor: const Color(0xFF58B9A1),
                          padding: const EdgeInsets.all(24)
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
                          backgroundColor: const Color(0xFF58B9A1),
                          padding: const EdgeInsets.all(24)
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
    );
  }
}
