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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/stoe.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  //padding: EdgeInsets.all(100),
                  margin: EdgeInsetsDirectional.symmetric(
                      horizontal: 20, vertical: 80),
                  //decoration: BoxDecoration(),
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
                              decoration: BoxDecoration(
                                  //color: Colors.blueGrey.shade500,
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Your Amount',
                                  //focusColor: Colors.black,
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
                                SizedBox(
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
                                                    child: Text(
                                                        currency.toUpperCase()),
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
                                SizedBox(
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
                                                    child: Text(
                                                        currency.toUpperCase()),
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
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         height: 55,
                            //         decoration: BoxDecoration(
                            //             color: Colors.teal,
                            //             borderRadius:
                            //                 BorderRadius.circular(12)),
                            //         child: Padding(
                            //           padding: const EdgeInsets.all(12.0),
                            //           child: DropdownButton<String>(
                            //             value: _fromCurrency,
                            //             hint: const Text('From Currency'),
                            //             style: TextStyle(
                            //                 color: Colors.black87,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.w500),
                            //             underline: Container(
                            //               decoration:
                            //                   ShapeDecoration(shape: Border()),
                            //             ),
                            //             items: _currencies
                            //                 .map((currency) => DropdownMenuItem(
                            //                       value: currency,
                            //                       child: Text(
                            //                           currency.toUpperCase()),
                            //                     ))
                            //                 .toList(),
                            //             onChanged: (value) {
                            //               setState(() {
                            //                 _fromCurrency = value;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 1,
                            //     ),
                            //     Expanded(
                            //       child: Container(
                            //         height: 55,
                            //         decoration: BoxDecoration(
                            //             color: Colors.teal,
                            //             borderRadius:
                            //                 BorderRadius.circular(12)),
                            //         child: Padding(
                            //             padding: const EdgeInsets.all(12.0),
                            //             child: DropdownButton<String>(
                            //               value: _toCurrency,
                            //               hint: const Text('To Currency'),
                            //               style: TextStyle(
                            //                   color: Colors.black87,
                            //                   fontSize: 18,
                            //                   fontWeight: FontWeight.w500),
                            //               underline: Container(
                            //                 decoration: ShapeDecoration(
                            //                     shape: Border()),
                            //               ),
                            //               items: _currencies
                            //                   .map((currency) =>
                            //                       DropdownMenuItem(
                            //                         value: currency,
                            //                         child: Text(
                            //                             currency.toUpperCase()),
                            //                       ))
                            //                   .toList(),
                            //               onChanged: (value) {
                            //                 setState(() {
                            //                   _toCurrency = value;
                            //                 });
                            //               },
                            //             )),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            const SizedBox(height: 15),
                            // ElevatedButton(
                            //   onPressed: _convertCurrency,
                            //   child: const Text('Convert'),
                            // ),
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
                              // Padding(
                              //   padding: const EdgeInsets.all(16.0),
                              //   child: Text(
                              //     'Converted Amount: $_convertedAmount',
                              //     style: const TextStyle(fontSize: 20),
                              //   ),
                              // ),
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
                                        //color: Colors.blueGrey.shade500,
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





// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(CurrencyConverterApp());
// }

// class CurrencyConverterApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CurrencyConverter(),
//     );
//   }
// }

// class CurrencyConverter extends StatefulWidget {
//   @override
//   _CurrencyConverterState createState() => _CurrencyConverterState();
// }

// class _CurrencyConverterState extends State<CurrencyConverter> {
//   final TextEditingController _amountController = TextEditingController();
//   String? _fromCurrency;
//   String? _toCurrency;
//   double? _convertedAmount;
//   List<String> _currencies = [];
//   Map<String, dynamic>? _eurRates;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrencyList();
//     _fetchEurRates();
//   }

//   // Fetch the list of currencies
//   Future<void> _fetchCurrencyList() async {
//     final url = Uri.parse(
//         'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json');
//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as Map<String, dynamic>;
//         setState(() {
//           _currencies = data.keys.toList();
//         });
//       } else {
//         _showError('Failed to load currency list.');
//       }
//     } catch (e) {
//       _showError('An error occurred while loading currency list.');
//     }
//   }

//   // Fetch rates with EUR as the base currency
//   Future<void> _fetchEurRates() async {
//     final url = Uri.parse(
//         'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json');
//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         setState(() {
//           _eurRates = json.decode(response.body)['eur'];
//         });
//       } else {
//         _showError('Failed to load EUR rates.');
//       }
//     } catch (e) {
//       _showError('An error occurred while loading EUR rates.');
//     }
//   }

//   // Handle currency conversion
//   void _convertCurrency() {
//     if (_eurRates == null || _fromCurrency == null || _toCurrency == null) {
//       _showError('Please select both currencies and try again.');
//       return;
//     }

//     double amount = double.tryParse(_amountController.text) ?? 0.0;
//     if (amount == 0.0) {
//       _showError('Please enter a valid amount.');
//       return;
//     }

//     double fromRate = (_eurRates![_fromCurrency] ?? 1).toDouble();
//     double toRate = (_eurRates![_toCurrency] ?? 1).toDouble();

//     setState(() {
//       _convertedAmount = (amount / fromRate) * toRate;
//     });
//   }

//   // Display an error message
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Currency Converter')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _currencies.isEmpty || _eurRates == null
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   DropdownButton<String>(
//                     value: _fromCurrency,
//                     hint: Text('From Currency'),
//                     items: _currencies
//                         .map((currency) => DropdownMenuItem(
//                               value: currency,
//                               child: Text(currency.toUpperCase()),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _fromCurrency = value;
//                       });
//                     },
//                   ),
//                   DropdownButton<String>(
//                     value: _toCurrency,
//                     hint: Text('To Currency'),
//                     items: _currencies
//                         .map((currency) => DropdownMenuItem(
//                               value: currency,
//                               child: Text(currency.toUpperCase()),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _toCurrency = value;
//                       });
//                     },
//                   ),
//                   TextField(
//                     controller: _amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Amount',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _convertCurrency,
//                     child: Text('Convert'),
//                   ),
//                   if (_convertedAmount != null)
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         'Converted Amount: $_convertedAmount',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }
// }








// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(CurrencyConverterApp());
// }

// class CurrencyConverterApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CurrencyConverter(),
//     );
//   }
// }

// class CurrencyConverter extends StatefulWidget {
//   @override
//   _CurrencyConverterState createState() => _CurrencyConverterState();
// }

// class _CurrencyConverterState extends State<CurrencyConverter> {
//   final TextEditingController _amountController = TextEditingController();
//   String? _fromCurrency;
//   String? _toCurrency;
//   double? _convertedAmount;
//   List<String> _currencies = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrencyList();
//   }

//   Future<void> _fetchCurrencyList() async {
//     final url = Uri.parse(
//         'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json');
//     try {
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body) as Map<String, dynamic>;
//         setState(() {
//           _currencies = data.keys.toList();
//         });
//       } else {
//         print('Error: ${response.statusCode}, ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load currency list.')),
//         );
//       }
//     } catch (e) {
//       print('Exception: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load currency list.')),
//       );
//     }
//   }

//   Future<void> _convertCurrency() async {
//     if (_fromCurrency == null || _toCurrency == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select both currencies.')),
//       );
//       return;
//     }

//     final url = Uri.parse(
//         'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/$_fromCurrency/$_toCurrency.json');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body) as Map<String, dynamic>;
//       double rate = (data[_toCurrency] ?? 1).toDouble();

//       double amount = double.tryParse(_amountController.text) ?? 0.0;

//       setState(() {
//         _convertedAmount = amount * rate;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to convert currency.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Currency Converter')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _currencies.isEmpty
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   DropdownButton<String>(
//                     value: _fromCurrency,
//                     hint: Text('From Currency'),
//                     items: _currencies
//                         .map((currency) => DropdownMenuItem(
//                               value: currency,
//                               child: Text(currency.toUpperCase()),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _fromCurrency = value;
//                       });
//                     },
//                   ),
//                   DropdownButton<String>(
//                     value: _toCurrency,
//                     hint: Text('To Currency'),
//                     items: _currencies
//                         .map((currency) => DropdownMenuItem(
//                               value: currency,
//                               child: Text(currency.toUpperCase()),
//                             ))
//                         .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _toCurrency = value;
//                       });
//                     },
//                   ),
//                   TextField(
//                     controller: _amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Amount',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _convertCurrency,
//                     child: Text('Convert'),
//                   ),
//                   if (_convertedAmount != null)
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         'Converted Amount: $_convertedAmount',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() {
//   runApp(CurrencyConverterApp());
// }

// class CurrencyConverterApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CurrencyConverter(),
//     );
//   }
// }

// class CurrencyConverter extends StatefulWidget {
//   @override
//   _CurrencyConverterState createState() => _CurrencyConverterState();
// }

// class _CurrencyConverterState extends State<CurrencyConverter> {
//   final TextEditingController _amountController = TextEditingController();
//   String? _fromCurrency;
//   String? _toCurrency;
//   double? _convertedAmount;
//   Map<String, dynamic>? _currencyData;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrencyData();
//   }

//   Future<void> _fetchCurrencyData() async {
//     final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       setState(() {
//         _currencyData = json.decode(response.body);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load currency data.')),
//       );
//     }
//   }

//   void _convertCurrency() {
//     if (_currencyData == null || _fromCurrency == null || _toCurrency == null) {
//       return;
//     }

//     double amount = double.tryParse(_amountController.text) ?? 0.0;
//     double fromRate = (_currencyData!['rates'][_fromCurrency] ?? 1).toDouble();
//     double toRate = (_currencyData!['rates'][_toCurrency] ?? 1).toDouble();

//     setState(() {
//       _convertedAmount = (amount / fromRate) * toRate;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Currency Converter')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _currencyData == null
//             ? Center(child: CircularProgressIndicator())
//             : Column(
//                 children: [
//                   DropdownButton<String>(
//                     value: _fromCurrency,
//                     hint: Text('From Currency'),
//                     items: _currencyData!['rates']
//                         .keys
//                         .map<DropdownMenuItem<String>>((dynamic currency) {
//                       return DropdownMenuItem<String>(
//                         value: currency as String, // Ensure type is String
//                         child: Text(currency),
//                       );
//                     }).toList(), // Convert to List<DropdownMenuItem<String>>
//                     onChanged: (value) {
//                       setState(() {
//                         _fromCurrency = value;
//                       });
//                     },
//                   ),
//                   DropdownButton<String>(
//                     value: _toCurrency,
//                     hint: Text('To Currency'),
//                     items: _currencyData!['rates']
//                         .keys
//                         .map<DropdownMenuItem<String>>((dynamic currency) {
//                       return DropdownMenuItem<String>(
//                         value: currency as String, // Ensure type is String
//                         child: Text(currency),
//                       );
//                     }).toList(), // Convert to List<DropdownMenuItem<String>>
//                     onChanged: (value) {
//                       setState(() {
//                         _toCurrency = value;
//                       });
//                     },
//                   ),
//                   TextField(
//                     controller: _amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       labelText: 'Amount',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _convertCurrency,
//                     child: Text('Convert'),
//                   ),
//                   if (_convertedAmount != null)
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text(
//                         'Converted Amount: $_convertedAmount',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                     ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
