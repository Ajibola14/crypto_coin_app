import 'dart:async';
import 'dart:convert';
import 'package:coingecko_api/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'coin_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Find',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: const HSLColor.fromAHSL(1, 210, 0.5, 0.8).toColor()),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamController<List<CryptoCurrency>> _streamController;
  List<CryptoCurrency> allCoins = [];
  List<CryptoCurrency> filteredCoins = [];
  @override
  void initState() {
    _streamController = StreamController.broadcast();
    getCoinsApi();
    _streamController.stream.listen((event) {
      setState(() {
        filteredCoins = event;
      });
    });
    Timer.periodic(const Duration(seconds: 45), (timer) {
      getCoinsApi();
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  _runFilter(String value) {
    List<CryptoCurrency> results = [];
    if (value.isEmpty) {
      results = allCoins;
    } else {
      results = allCoins
          .where(
              (coin) => coin.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredCoins = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorscheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorscheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Coin Find",
          style: TextStyle(color: colorscheme.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                style: TextStyle(color: colorscheme.onSecondary),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorscheme.onSecondary,
                  ),
                  hintText: "Search",
                  contentPadding: const EdgeInsets.all(10),
                  hintStyle: const TextStyle(color: Colors.black38),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: filteredCoins.length,
                        itemBuilder: (context, index) {
                          final coin = filteredCoins[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: ShapeDecoration(
                                shape: const StadiumBorder(),
                                shadows: [
                                  BoxShadow(
                                      color: colorscheme.onSecondary,
                                      offset: const Offset(-1, 2),
                                      blurRadius: 4)
                                ],
                                color: colorscheme.primaryContainer),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CoinDetailsPage(coin: coin),
                                ));
                              },
                              leading: Hero(
                                tag: coin.name,
                                child: Image.network(
                                  coin.image,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              title: Text(coin.name),
                              trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      coin.currentPrice.toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (coin.priceChangePercentage24h
                                          .toString()),
                                      style: TextStyle(
                                        fontSize: 16,
                                          color: getColor(
                                              coin.priceChangePercentage24h)),
                                    ),
                                  ]),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(fontSize: 40, color: Colors.black),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey,
                            period: const Duration(seconds: 1),
                            highlightColor:
                                colorscheme.onPrimaryContainer.withOpacity(1),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: ShapeDecoration(
                                  shape: const StadiumBorder(),
                                  color: colorscheme.primary),
                              height: 80,
                              width: double.infinity,
                            ));
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getCoinsApi() async {
    const url =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&locale=en";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      List coins = jsonDecode(body);
      List<CryptoCurrency> mappedCoins =
          coins.map((e) => CryptoCurrency.fromJson(e)).toList();
      allCoins = mappedCoins;
      _streamController.add(mappedCoins);
    } else {}
  }
}

Color getColor(num? priceChangePercentage24h) {
  final roundedValue = priceChangePercentage24h!.round();
  if (roundedValue > 0) {
    return Colors.green;
  } else if (roundedValue < 0) {
    return Colors.red;
  } else {
    return Colors.grey;
  }
}
