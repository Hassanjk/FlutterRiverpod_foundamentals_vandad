import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

// we now want to start using the Stream Provider
// create me a list of names

const names = [
  "Hassan",
  "Ahmed",
  "Ali",
  "Mohamed",
  "Omar",
  "Khalid",
  "Youssef",
  "Ibrahim",
];

final tickerProvider = StreamProvider(
      (ref) => Stream.periodic(
    const Duration(seconds: 1),
        (i) => i + 1,
  ),
);

final namesProvider = StreamProvider(
      (ref) => ref.watch(tickerProvider.stream).map(
        (count) => names.getRange(0, count),
  ),
);

class App extends ConsumerWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // calculate widget to show
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    // calculate widget to show
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: names.when(
        data: (names) => ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(names.elementAt(index)),
            );
          },
        ),
        error: (e, s) => Text('$e'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
