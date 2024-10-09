// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltylinx/main.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';

class ApplyCreditForm extends StatefulWidget {
  final Map<String, dynamic> merchants;
  const ApplyCreditForm({super.key, required this.merchants});

  @override
  State<ApplyCreditForm> createState() => _ApplyCreditFormState();
}

const List<String> list = <String>[
  'Employment Income',
  'Business Income',
  'Professional Fees',
  'Rental Income',
  'Investment Income',
  'Pension and Retirement Income',
  'Other Sources',
];
const List<String> moths = <String>[
  '1 month',
  '2 months',
  '3 months',
  '4 months',
  '5 months',
  '6 months',
];

const List<double> credit = <double>[
  2000.00,
  3000.00,
  5000.00,
];

final _incomeSoureController = TextEditingController();
final _monthlyIncomeController = TextEditingController();
final _termController = TextEditingController();
final _creditController = TextEditingController();
bool isIncome = false;
bool isTerm = false;
bool isCredit = false;
String dropdownValue = list.first;
String? store;
String? id;
double? creditTotal;
String? apiUrlRequestCredit;

class _ApplyCreditFormState extends State<ApplyCreditForm> {
  final _formKey = GlobalKey<FormState>();
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'en-PH', symbol: '');

  @override
  void initState() {
    id = widget.merchants['_id'];
    store = widget.merchants['storeName'];
    isIncome = false;
    isTerm = false;
    creditTotal;
    apiUrlRequestCredit =
        'https://loyalty-linxapi.vercel.app/api/user/$id/request-credit';
    super.initState();
  }

  Future<void> requestCredit(String token, String incomeSource,
      String monthlyIncome, double creditAmount, String term) async {
    showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    var url = Uri.parse(apiUrlRequestCredit!);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'incomeSoure': incomeSource,
        'incomeSoureAmount': monthlyIncome,
        'creditAmount': creditAmount,
        'term': term,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(
          title: "Success",
          message: message,
          onPress: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => BottomNavBarExample(
                          userData: userData1,
                        )),
                (route) => false);
          });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(
          title: "Failed",
          message: message,
          onPress: () {
            Navigator.pop(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Text(
                "Application Form",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              title(context, "Store"),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  errorStyle: const TextStyle(fontSize: 10),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                initialValue: store,
                readOnly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              title(context, "Source of income"),
              const SizedBox(
                height: 10,
              ),
              DropdownMenu<String>(
                controller: _incomeSoureController,
                width: MediaQuery.of(context).size.width / 1.09,
                helperText:
                    isIncome == true ? "Please select soure of income" : null,
                inputDecorationTheme: InputDecorationTheme(
                  helperStyle: const TextStyle(color: Colors.red),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        width: 1,
                        color: isIncome == true
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
                initialSelection: null,
                onSelected: (String? value) {
                  setState(() {
                    isIncome = false;
                    dropdownValue = value!;
                    _incomeSoureController.text = value;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              title(context, "Montly Income"),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onChanged: (value) {
                  String stringValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  int intValue = int.parse(stringValue);
                  String formattedValue =
                      _currencyFormat.format(intValue / 100);
                  _monthlyIncomeController.value =
                      _monthlyIncomeController.value.copyWith(
                          text: formattedValue,
                          selection: TextSelection.collapsed(
                              offset: formattedValue.length));
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _monthlyIncomeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter monthly income';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "0.00",
                  errorStyle: const TextStyle(color: Colors.red),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              title(context, "Credit Amount"),
              const SizedBox(
                height: 10,
              ),
              DropdownMenu<double>(
                controller: _creditController,
                width: MediaQuery.of(context).size.width / 1.09,
                helperText:
                    isTerm == true ? "Please select credit amount" : null,
                inputDecorationTheme: InputDecorationTheme(
                  helperStyle: const TextStyle(color: Colors.red),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        width: 1,
                        color: isTerm == true
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
                initialSelection: null,
                onSelected: (double? value) {
                  setState(() {
                    isCredit = false;
                    creditTotal = value;
                    // dropdownValue = value!;
                    // _termController.text = value;
                  });
                },
                dropdownMenuEntries:
                    credit.map<DropdownMenuEntry<double>>((double value) {
                  return DropdownMenuEntry<double>(
                      value: value, label: value.toString());
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              title(context, "Term"),
              const SizedBox(
                height: 10,
              ),
              DropdownMenu<String>(
                controller: _termController,
                width: MediaQuery.of(context).size.width / 1.09,
                helperText: isTerm == true ? "Please select term" : null,
                inputDecorationTheme: InputDecorationTheme(
                  helperStyle: const TextStyle(color: Colors.red),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        width: 1,
                        color: isTerm == true
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
                initialSelection: null,
                onSelected: (String? value) {
                  setState(() {
                    isTerm = false;
                    dropdownValue = value!;
                    _termController.text = value;
                  });
                },
                dropdownMenuEntries:
                    moths.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
                menuStyle: MenuStyle(
                    side: MaterialStatePropertyAll(BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.inverseSurface))),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade900,
                  padding: const EdgeInsets.all(14.0),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  elevation: 5,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _incomeSoureController.text.isNotEmpty &&
                      _termController.text.isNotEmpty &&
                      _creditController.text.isNotEmpty) {
                    requestCredit(
                        tokenMain!,
                        _incomeSoureController.text.toString(),
                        _monthlyIncomeController.text.toString(),
                        creditTotal!,
                        _termController.text.toString());
                  } else {
                    setState(() {
                      isIncome = true;
                      isTerm = true;
                      isCredit = true;
                    });
                  }
                },
                child: const SizedBox(
                  height: 30,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    _incomeSoureController.clear();
    _monthlyIncomeController.clear();
    _termController.clear();
    _creditController.clear();

    super.dispose();
  }

  Row title(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  showMessage(
      {required String title,
      required String message,
      required Function onPress}) {
    showCupertinoDialog(
        context: context,
        builder: (contex) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                  child: const Text("ok"),
                  onPressed: () {
                    onPress();
                  }),
            ],
          );
        });
  }
}

class CurrencyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    String newText =
        NumberFormat.currency(symbol: '').format(double.parse(newValue.text));
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      ),
    );
  }
}
