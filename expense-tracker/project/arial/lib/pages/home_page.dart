import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Arial'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Icon(
                Icons.chat,
                size: 100.0,
                color: Colors.green,
              ),
              const SizedBox(height: 30.0),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 200),
                child: Text(
                  strutStyle: StrutStyle(fontSize: 4),
                  'Welcome to Arial, Connecting you and the world',
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                  // Add your action when the button is pressed
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//     return Container(
//       alignment: const Alignment(0.0, 0.0),
//       padding: const EdgeInsets.fromLTRB(0, 210, 0, 10),
//       child: const Text(
//         'Welcome to WhatsApp',
//         style: TextStyle(
//           fontSize: 29,
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//     );
//   }
// }
