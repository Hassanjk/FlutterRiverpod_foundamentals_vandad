import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Cities {
  London,
  Lilongwe,
  Blantyre,
  Zomba,
  Mzuzu,
  Mangochi,
  Salima,
}

// given a city they will be a function to produce the weather for us.
typedef WeatherEmoji = String;

Future<String> getWeather(Cities city) async {
  return Future.delayed(
      const Duration(seconds: 2),
          () =>
      {
        Cities.London: '❄️',
        Cities.Lilongwe: '⛈️',
        Cities.Blantyre: '🌞',
        Cities.Zomba: '🌧', //  it's raining here = '🌧',
        Cities.Mangochi: '🌦️', //it's windy here =  '🌬️',
        // it's snowing here = '❄️',
      }[city] ??
          'Pepani Tilibe data ya ${city.name} pa list yathu'); // the key we tryna extract is the Cities.
}

const unknownWealther = 'sankhani dzina la city kuti mudziwe nyego 🙂';
// stateProvider keeps the value that can be changed
final currentCityProvider = StateProvider<Cities?>((ref) => null);
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (city != null) {
    return getWeather(city);
  }

  return Future.value(unknownWealther);
});

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

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // calculate widget to show
    final weatherAsyncValue = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malawi Weather'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: weatherAsyncValue.when(
                data: (weatherEmoji) =>
                    Text(weatherEmoji, style: const TextStyle(fontSize: 50)),
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Cities.values.length,
              itemBuilder: (context, index) {
                final city = Cities.values[index];
                final isCitySelected = city == ref.watch(currentCityProvider);

                return ListTile(
                  title: Text(city.name),
                  // Mark the city as selected if it is selected
                  tileColor: isCitySelected ? Colors.blue : null,
                  trailing: isCitySelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    // update the stateProvider.notifier to return the selected city
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
