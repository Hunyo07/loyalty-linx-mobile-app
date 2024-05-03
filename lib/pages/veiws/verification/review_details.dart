// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/profile.dart';
import 'package:loyaltylinx/pages/veiws/verification/additional_form.dart';
import 'package:http/http.dart' as http;
import 'package:loyaltylinx/pages/veiws/verification/authorization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviewDetails extends StatefulWidget {
  final String address;
  final String gender;
  final String province;
  final String municipal;
  final String postalCode;
  final String birthDate;
  final String typeId;
  final File? idPhoto;
  final File? facePhoto;
  const PreviewDetails(
      {super.key,
      required this.address,
      required this.gender,
      required this.province,
      required this.municipal,
      required this.postalCode,
      required this.birthDate,
      required this.typeId,
      required this.idPhoto,
      required this.facePhoto});

  @override
  State<PreviewDetails> createState() => PreviewDetailsState();
}

String? urlIdPhoto;
String? urlFacePhoto;

class PreviewDetailsState extends State<PreviewDetails> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> uploadFileFacePhoto(File imageFile, String token) async {
    // Define the endpoint URL for uploading the image
    Uri url = Uri.parse('https://loyaltylinx.cyclic.app/api/upload/selfie');

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add the image file to the request
    var fileStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile =
        http.MultipartFile('image', fileStream, length, filename: 'image.jpg');
    request.files.add(multipartFile);

    // Set the bearer token in the authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Send the request
    var response = await http.Response.fromStream(await request.send());

    // Handle the response
    if (response.statusCode == 200) {
      // Successful upload
      final json = jsonDecode(response.body);
      final data = (json)['imageUrl'].toString();
      debugPrint(data);
      uploadFileIdPhoto(
        widget.idPhoto!,
        data,
        token,
      );
    } else {
      // Handle error
      debugPrint('Failed to upload image: ${response.statusCode}');
      showMessage(title: "Failed to upload image", message: response.body);
    }
  }

  Future<void> uploadFileIdPhoto(
    File imageFile,
    String facePhoto,
    String token,
  ) async {
    // Define the endpoint URL for uploading the image
    Uri url = Uri.parse('https://loyaltylinx.cyclic.app/api/upload/valid-id');

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add the image file to the request
    var fileStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile =
        http.MultipartFile('image', fileStream, length, filename: 'image.jpg');
    request.files.add(multipartFile);

    // Set the bearer token in the authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Send the request
    var response = await http.Response.fromStream(await request.send());

    // Handle the response
    if (response.statusCode == 200) {
      // Successful upload
      final json = jsonDecode(response.body);
      final data = (json)['imageUrl'].toString();
      debugPrint(data);
      handleVerify(
        token,
        facePhoto,
        data,
      );
    } else {
      // Handle error
      debugPrint('Failed to upload image: ${response.statusCode}');
      showMessage(title: "Failed to upload image", message: response.body);
    }
  }

  Future<void> deleteUserDataOnly(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_data');
    getProfile(userToken!, context);
  }

  Future<void> getUserDataOnly() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('user_token');
    final userData = prefs.getString('user_data');
    if (userData != null) {
      userData0 = [jsonDecode(userData)];
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ForReview(userData: userData0!)));
    } else {
      debugPrint('User data not found');
    }
    setState(() {});
  }

  Future<void> saveUserDataOnly(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
    getUserDataOnly();
  }

  Future<void> handleVerify(token, facePhoto, idPhoto) async {
    accountVerify(
        token,
        widget.birthDate,
        widget.gender,
        widget.address,
        widget.municipal,
        widget.province,
        widget.postalCode,
        userCode,
        idPhoto!,
        facePhoto,
        context);
  }

  Future<void> getProfile(String token, context) async {
    final response = await http.get(
      Uri.parse('https://loyaltylinx.cyclic.app/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      saveUserDataOnly(json['userProfile']);
    } else {}
  }

  Future accountVerify(
      String token,
      String birthDate,
      String gender,
      String address,
      String city,
      String province,
      String postalCode,
      String verificationCode,
      String validId,
      String selfie,
      context) async {
    var url = Uri.parse(
        'https://loyaltylinx.cyclic.app/api/user/account-verification');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'birthdate': birthDate,
        'gender': gender,
        'address': address,
        'city': city,
        'province': province,
        'country': "Philippines",
        'postalCode': postalCode,
        'verificationCode': verificationCode,
        'validId': validId,
        'selfiePicture': selfie,
      }),
    );
    if (response.statusCode == 200) {
      deleteUserDataOnly(context);
      // getProfile(userToken!, context);
    } else {
      final json = jsonDecode(response.body);
      Navigator.of(context, rootNavigator: true).pop();
      final message = json['message'];
      await showMessage(title: "Failed to verify", message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Review you'r details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Row(
                    children: [
                      Text(
                        'Personal information'.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: previewInput(
                              "${userData1[0]['firstName']}", 'Firstname')),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: previewInput(
                              "${userData1[0]['lastName']}", 'Lastname')),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: previewInput(widget.gender, 'Gender')),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: previewInput(widget.birthDate, 'Birthdate')),
                    ],
                  ),
                  previewInput(widget.typeId, 'ID type'),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Current address'.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  previewInput(widget.address, "Address"),
                  const SizedBox(
                    height: 10,
                  ),
                  previewInput(widget.province, "Province"),
                  const SizedBox(
                    height: 10,
                  ),
                  previewInput(widget.municipal, "Municipality"),
                  const SizedBox(
                    height: 10,
                  ),
                  previewInput(widget.postalCode, "Zip Code"),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const ForReview()));
                            // print(widget.facePhotoUrl);
                            // print(widget.address);
                            // print(widget.birthDate);
                            // print(widget.facePhoto);
                            // print(widget.gender);
                            // print(widget.idPhoto);
                            // print(widget.municipal);
                            // print(widget.postalCode);
                            // print(widget.province);
                            // print(widget.typeId);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.amber.shade900,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            "Wrong info?",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                                barrierColor:
                                    Theme.of(context).colorScheme.background,
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                });
                            uploadFileFacePhoto(widget.facePhoto!, userToken!);
                            // uploadFileIdPhoto(widget.idPhoto!, userToken!);
                            // handleVerify(userToken!);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: Colors.amber.shade900,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text(
                            "Verify!",
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  showMessage({required String title, required String message}) {
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
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Column previewInput(String initialValue, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500),
        ),
        TextFormField(
          readOnly: true,
          initialValue: initialValue,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: const InputDecoration(border: InputBorder.none),
        ),
      ],
    );
  }
}

class ForReview extends StatefulWidget {
  final List<Object> userData;
  const ForReview({super.key, required this.userData});

  @override
  State<ForReview> createState() => _ForReviewState();
}

class _ForReviewState extends State<ForReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Verification"),
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
                  MaterialPageRoute(
                      builder: (_) =>
                          BottomNavBarExample(userData: widget.userData)),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(100)),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade600.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.asset(
                      'assets/images/roundedarrow.png',
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We're verifying your account!",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Please expect an Email or sms within 24 hours on the status of your verification.",
                    softWrap: true,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
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
