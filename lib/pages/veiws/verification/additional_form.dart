// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, unrelated_type_equality_checks, unused_element

import 'dart:convert';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/verification/selection_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? city;
String? district;

class AddForm extends StatefulWidget {
  const AddForm({
    super.key,
  });

  @override
  _AddFormState createState() => _AddFormState();
}

final _cityTextEditingController = TextEditingController();
final _provinceTextEditingController = TextEditingController();
final _monthController = TextEditingController();
final _dayController = TextEditingController();
final _yearController = TextEditingController();
final _addressController = TextEditingController();
final _genderController = TextEditingController();
final _postalController = TextEditingController();

Future<List<SelectedListItem>> fetchData() async {
  final response =
      await http.get(Uri.parse('https://psgc.cloud/api/provinces'));
  if (response.statusCode == 200) {
    final jsonBody = jsonDecode(response.body);
    final List<dynamic> jsonList = jsonBody;
    return jsonList.map((json) {
      final selectedListItem =
          SelectedListItem(name: '', value: '', isSelected: true);
      selectedListItem.name = json['name'];
      selectedListItem.value = json['code'];
      return selectedListItem;
    }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

bool isGender = false;

Future<List<SelectedListItem>> fetchDataCity(String provinceCode) async {
  if (provinceCode != null) {
    final response = await http.get(Uri.parse(
        'https://psgc.cloud/api/provinces/$provinceCode/cities-municipalities'));
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonBody;
      return jsonList.map((json) {
        final selectedListItem =
            SelectedListItem(name: '', value: '', isSelected: true);
        selectedListItem.name = json['name'];
        selectedListItem.value = json['code'];
        return selectedListItem;
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  } else {
    return [];
  }
}

Object? token;
List<Object>? userData0;

getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString('user_token');
  final userData = prefs.getString('user_data');
  if (userData != null) {
    userData0 = [jsonDecode(userData)];
  } else {
    debugPrint('User data not found');
  }
}

const List<String> list = <String>[
  'Male',
  'Female',
];

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

  final Future<List<SelectedListItem>> _listOfProvinceFuture = fetchData();
  Future<List<SelectedListItem>>? _listOfCitiesFuture;
  String dropdownValue = list.first;

  String? selectedProvince;
  String? selectedCity;
  @override
  void initState() {
    getUserData();
    fetchData();
    super.initState();
    _provinceTextEditingController.addListener(() {
      if (selectedProvince != _provinceTextEditingController.text) {
        selectedProvince = _provinceTextEditingController.text;
        _cityTextEditingController.clear();
        _listOfCitiesFuture = fetchDataCity(selectedProvince!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () {
              showDialog(
                  barrierColor: Theme.of(context).colorScheme.background,
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  });
              Navigator.pushAndRemoveUntil(
                  context,
                  routeTransition(BottomNavBarExample(userData: userData0!)),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: _mainBody(),
      ),
    );
  }

  Widget _mainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              const Text("Birthdate"),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child:
                        birthDate(context, _monthController, 2, "MM", (value) {
                      if (value == null || value.isEmpty) {
                        return 'invalid month';
                      }
                      final month = int.tryParse(value);
                      if (month == null || month < 1 || month > 12) {
                        return 'invalid month';
                      }
                    }, TextInputType.number),
                  ),
                  const SizedBox(width: 12.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3.5,
                    child: birthDate(context, _dayController, 2, "DD", (value) {
                      if (value == null || value.isEmpty) {
                        return 'invalid day';
                      }
                      final day = int.tryParse(value);
                      if (day == null || day < 1 || day > 31) {
                        return 'invalid day';
                      }
                    }, TextInputType.number),
                  ),
                  const SizedBox(width: 12.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child:
                        birthDate(context, _yearController, 4, "YYYY", (value) {
                      if (value == null || value.isEmpty) {
                        return 'invalid year';
                      }
                      final year = int.tryParse(value);
                      if (year == null ||
                          year < 1900 ||
                          year > DateTime.now().year) {
                        return 'invalid year';
                      }
                    }, TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Text("Gender"),
              const SizedBox(
                height: 5.0,
              ),
              DropdownMenu<String>(
                controller: _genderController,
                width: MediaQuery.of(context).size.width / 1.078,
                hintText: "Gender",
                helperText: isGender == true ? "Please select gender" : null,
                inputDecorationTheme: InputDecorationTheme(
                  helperStyle: const TextStyle(color: Colors.red),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: .5,
                        color: isGender == true
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.amber.shade700,
                    ),
                  ),
                ),
                initialSelection: null,
                onSelected: (String? value) {
                  setState(() {
                    isGender = false;
                    dropdownValue = value!;
                    _genderController.text = value;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Address'),
              const SizedBox(
                height: 5.0,
              ),
              birthDate(context, _addressController, 200, "Address", (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input address';
                }
              }, TextInputType.streetAddress),
              const SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Block, Street, Brgy",
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              AppTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input Province';
                  }
                  return null;
                },
                provinceCode: (p0) {
                  if (p0 == null) {
                  } else {
                    setState(() {
                      _listOfCitiesFuture = fetchDataCity(p0);
                    });
                  }
                },
                bottomSheetTitle: "Province",
                enabled: true,
                textEditingController: _provinceTextEditingController,
                title: "Province",
                hint: "Province",
                isCitySelected: true,
                cities: _listOfProvinceFuture,
              ),
              AppTextField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input municipal';
                  }
                  return null;
                },
                provinceCode: (p0) {
                  if (p0 == null) {
                  } else {
                    selectedCity = p0;
                  }
                },
                bottomSheetTitle: "Municipality",
                enabled: true,
                textEditingController: _cityTextEditingController,
                title: "Municipality",
                hint: "Municipality",
                isCitySelected: true,
                cities: _listOfCitiesFuture,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Zip Code'),
                        const SizedBox(
                          height: 5.0,
                        ),
                        birthDate(context, _postalController, 4, "0000",
                            (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input postal code';
                          }
                        }, TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Country'),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue: "Philippines",
                            decoration: InputDecoration(
                              errorStyle: const TextStyle(fontSize: 10),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: .5,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1.5,
                                  color: Colors.amber.shade700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _genderController.text.isEmpty
                          ? setState(() {
                              isGender = true;
                            })
                          : Navigator.pushAndRemoveUntil(
                              context,
                              routeTransition(SelectionId(
                                  birthDate:
                                      "${_monthController.text}-${_dayController.text}-${_yearController.text}",
                                  gender: _genderController.text,
                                  province: _provinceTextEditingController.text,
                                  municipality: _cityTextEditingController.text,
                                  postalCode: _postalController.text,
                                  address: _addressController.text)),
                              (route) => false);
                    } else {
                      debugPrint('failed');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.amber.shade900,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    "Lets verify!",
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _cityTextEditingController.clear();
    // _provinceTextEditingController.clear();
    // _addressController.clear();
    // _postalController.clear();
    // _genderController.clear();
  }
}

class AppTextField extends StatefulWidget {
  final Function(String) provinceCode;
  final TextEditingController textEditingController;
  final String title;
  final String bottomSheetTitle;
  final String hint;
  final bool isCitySelected;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  final Future<List<SelectedListItem>>? cities;

  const AppTextField({
    required this.textEditingController,
    required this.title,
    required this.hint,
    required this.isCitySelected,
    required this.enabled,
    required this.bottomSheetTitle,
    this.cities,
    super.key,
    required this.provinceCode,
    this.validator,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  void onTextFieldTap() async {
    final cities = await widget.cities;

    DropDownState(
      DropDown(
        isDismissible: true,
        bottomSheetTitle: Text(
          widget.bottomSheetTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        clearButtonChild: const Text(
          'Clear',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: cities ?? [],
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SelectedListItem) {
              list.add(item.name);
              list.add("${item.value}");
            }
          }

          widget.provinceCode(list[1]);
          widget.textEditingController == null
              ? null
              : widget.textEditingController.text = list[0];
        },
        enableMultipleSelection: false,
      ),
      // ignore: use_build_context_synchronously
    ).showModal(context);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title),
        const SizedBox(
          height: 5.0,
        ),
        TextFormField(
          validator: widget.validator,
          onChanged: (value) {},
          readOnly: true,
          enabled: widget.enabled,
          controller: widget.textEditingController,
          cursorColor: Colors.black,
          onTap: widget.isCitySelected
              ? () {
                  FocusScope.of(context).unfocus();
                  onTextFieldTap();
                }
              : null,
          decoration: InputDecoration(
            errorStyle: const TextStyle(fontSize: 10),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            hintText: widget.hint,
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: .5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.amber.shade700,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}

class _AppElevatedButton extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Colors.amber.shade900,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text(
          "Lets verify!",
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    );
  }
}

TextFormField birthDate(BuildContext context, controller, int inputLimit,
    String hintText, Function validator, TextInputType textInputType) {
  return TextFormField(
    textInputAction: TextInputAction.next,
    validator: (value) => validator(value),
    onChanged: (value) {},
    controller: controller,
    inputFormatters: [LengthLimitingTextInputFormatter(inputLimit)],
    keyboardType: textInputType,
    decoration: InputDecoration(
      errorStyle: const TextStyle(fontSize: 10),
      errorBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      hintText: hintText,
      focusedErrorBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: .5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          color: Colors.amber.shade700,
        ),
      ),
    ),
  );
}

PageRouteBuilder<dynamic> routeTransition(screenView) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => screenView,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}
