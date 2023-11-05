import 'package:cached_network_image/cached_network_image.dart';
import 'package:coingecko_api/models/coin.dart';
import 'package:coingecko_api/models/utils/num_row.dart';
import 'package:coingecko_api/models/utils/string_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinDetailsPage extends StatelessWidget {
  CoinDetailsPage({super.key, required this.coin});
  CryptoCurrency coin;
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    formattedDate(String date) {
      DateTime parseDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
      var outputDate = outputFormat.format(inputDate);
      return outputDate;
    }

    String athdate = formattedDate(coin.athDate);
    String atldate = formattedDate(coin.atlDate);

    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: colorScheme.primary,
            ),
          ),
          centerTitle: true,
          backgroundColor: colorScheme.background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: coin.name,
                child: CachedNetworkImage(
                  imageUrl: coin.image,
                  errorWidget: (context, url, error) => const Icon(Icons.circle),
                  height: 40,
                  width: 40,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                coin.name.toUpperCase(),
                style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )),
      backgroundColor: colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coin.symbol.toUpperCase(),
              style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            NumberRow(
              variable: coin.currentPrice,
              title: "Current Price",
            ),
            NumberRow(
              variable: coin.marketCap,
              title: "Market Cap",
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Market Cap Rank",
                  style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "No ${coin.marketCapRank}",
                  style: TextStyle(color: colorScheme.secondary, fontSize: 16),
                ),
              ],
            ),
            NumberRow(
              variable: coin.fullyDilutedValuation,
              title: "Fully Diluted Valuation",
            ),
            NumberRow(
              variable: coin.totalVolume,
              title: "Total Volume",
            ),
            Divider(
              color: colorScheme.onBackground,
            ),
            NumberRow(
              title: "High 24h",
              variable: coin.high24h,
            ),
            NumberRow(
              title: "Low 24h",
              variable: coin.low24h,
            ),
            NumberRow(
              title: "Price Change 24h",
              variable: coin.priceChange24h,
            ),
            StringRow(
              title: "Price Change % 24h",
              variable: coin.priceChangePercentage24h!.toStringAsFixed(4),
            ),
            NumberRow(
              variable: coin.marketCapChange24h,
              title: "Market Cap Change 24h",
            ),
            StringRow(
              variable: coin.marketCapChangePercentage24h!.toStringAsFixed(4),
              title: "Market Cap Change % 24h",
            ),
            Divider(
              color: colorScheme.onBackground,
            ),
            NumberRow(
                variable: coin.circulatingSupply, title: "Circulating Supply"),
            NumberRow(variable: coin.totalSupply, title: "Total Supply"),
            NumberRow(variable: coin.maxSupply, title: "Circulating Supply"),
            Divider(
              color: colorScheme.onBackground,
            ),
            NumberRow(
              variable: coin.ath,
              title: "Ath",
            ),
            StringRow(
              variable: coin.athChangePercentage!.toStringAsFixed(4),
              title: "Ath Change %",
            ),
            StringRow(variable: athdate, title: "Ath Date"),
            NumberRow(variable: coin.atl, title: "Atl"),
            StringRow(
              variable: coin.atlChangePercentage!.toStringAsFixed(4),
              title: "Atl change %",
            ),
            StringRow(variable: atldate, title: "Atl Date"),
            StringRow(
              title: "Roi",
              variable: coin.roi != null
                  ? "${coin.roi?.percent}%/${coin.roi?.currency}"
                  : " - ",
            )
          ],
        ),
      ),
    );
  }
}
