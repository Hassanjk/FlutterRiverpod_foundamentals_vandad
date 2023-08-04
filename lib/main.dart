import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

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

// extension Optionalextension<T extends num> on T? {
//   T? operator +(T? other) {
//     final shadow = this ?? other;
//     if (shadow != null) {
//       return shadow + (other ?? 0) as T;
//     } else {
//       return null;
//     }
//   }
// }

// void testIt() {
//   const int int1 = 1;
//   const int? int2 = null;

//   final result = int1 + int2;
//   print(result);
// }

// state notifier allow to have state variable and notify when it changes

class Counter extends StateNotifier<int?> {
  Counter() : super(null);
  void increment() => state = (state ?? 0) + 1;

  int? get value => state;
}

final counterProvider =
StateNotifierProvider<Counter, int?>((ref) => Counter());

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // calculate widget to show
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final value = ref.watch(counterProvider);
            return Text('Home Page ${value ?? ''}');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () {
              // increment the counter
              ref.read(counterProvider.notifier).increment();
            },
            child: const Text('Click me'),
          ),
        ],
      ),
    );
  }
}
