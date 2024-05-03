import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LinkCard extends StatefulWidget {
  const LinkCard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LinkCardState createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: 
      SafeArea(child: 
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Row(children: [Text("Card Number")]),
              const SizedBox(height: 12.0),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CardNumberFormatter(),
                  LengthLimitingTextInputFormatter(19)
                ],
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: .5,
                            color: Theme.of(context).colorScheme.primary)),
                    suffixIcon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.credit_card)),
                    border: const OutlineInputBorder(),
                    hintText: 'XXXX-XXXX-XXXX-XXXX',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber.shade700),
                    )),
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade900,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
                child: const Text(
                  'Link Card',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/2040/2040835.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              const Text(
                "or",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(8.0),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    onPressed: () {},
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * .05,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Image.network(
                                  "http://pngimg.com/uploads/google/google_PNG19635.png",
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Continue with Google",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ]))),
              )
            ],
          ),
        ),
      ),
    ));
  }

  TextFormField registerForm(laberlText, iconPref, colorIcon, hintText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: laberlText,
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        enabledBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        prefixIcon: iconPref,
        prefixIconColor: colorIcon,
        fillColor: Colors.white,
        filled: true,
        focusedBorder:
            UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
      ),
      // controller: _bdateController,
    );
  }

  // ignore: non_constant_identifier_names

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "Link Card",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => {Navigator.pop(context)},
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "LOGIN",
                style: TextStyle(fontSize: 16),
              ),
            ))
      ],
      elevation: 0,
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var inputText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write('-');
      }
    }

    var string = bufferString.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
