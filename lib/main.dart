import 'package:flutter/material.dart';
import 'currency_logic.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _amountController = TextEditingController();
  String? _fromCurrency;
  String? _toCurrency;
  double? _convertedAmount;
  List<String> _currencies = [];
  late CurrencyLogic _currencyLogic;

  @override
  void initState() {
    super.initState();
    _currencyLogic = CurrencyLogic();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final currencies = await _currencyLogic.fetchCurrencyList(context);
    final eurRates = await _currencyLogic.fetchEurRates(context);

    if (currencies != null && eurRates != null) {
      setState(() {
        _currencies = currencies;
      });
    }
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (_fromCurrency == null || _toCurrency == null || amount <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and enter a valid amount.')),
      );
      return;
    }

    final result = _currencyLogic.convertCurrency(
      amount,
      _fromCurrency!,
      _toCurrency!,
    );

    if (result != null) {
      setState(() {
        _convertedAmount = result;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to convert currency. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currencies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/currency-converter.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsetsDirectional.symmetric(
                      horizontal: 20, vertical: 80),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(220, 255, 255, 255),
                      border: Border.all(
                        color: const Color.fromARGB(220, 255, 255, 255),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Currency Converter",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Your Amount',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width:
                                        160, // Fixed width for the 'From Currency' dropdown
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade200,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: _fromCurrency,
                                            hint: const Text('From Currency'),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            underline: const SizedBox(),
                                            items: _currencies
                                                .map((currency) =>
                                                    DropdownMenuItem(
                                                      value: currency,
                                                      child: Text(currency
                                                          .toUpperCase()),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _fromCurrency = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width:
                                        160, // Fixed width for the 'To Currency' dropdown
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: _toCurrency,
                                            hint: const Text('To Currency'),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            underline: const SizedBox(),
                                            items: _currencies
                                                .map((currency) =>
                                                    DropdownMenuItem(
                                                      value: currency,
                                                      child: Text(currency
                                                          .toUpperCase()),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _toCurrency = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade500,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Center(
                                  child: Text("Convert",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black)),
                                ),
                              ),
                              onTap: _convertCurrency,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            if (_convertedAmount != null)
                              Column(
                                children: [
                                  Text('Converted Amount is:',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black)),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Center(
                                      child: Text('$_convertedAmount',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                    ),
                                  )
                                ],
                              )
                          ],
                        ),
                        Text("Seamless Currency Conversions, Anytime!",
                            style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ]));
  }
}
