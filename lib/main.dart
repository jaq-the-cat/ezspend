import 'package:ezspend/widgets/load_future.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'input_page.dart';
import 'data/global.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ezspend',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepOrange,
          secondary:  Colors.deepOrange,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: Scaffold(body: 
        loadFuture(
          future: Global.init(),
          loading: Center(child: LoadingAnimationWidget.waveDots(color: Theme.of(context).colorScheme.primary, size: 64)),
          builder: (context, data) {
            if (data != null) {
              return const InputPage();
            }
            return const Center(child: Text("Something went wrong :("));
          }
        )
      ),
    );
  }
}
