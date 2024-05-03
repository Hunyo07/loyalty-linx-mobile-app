// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:loyaltylinx/pages/auth/link_card.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/profile/address.dart';
import 'package:loyaltylinx/pages/veiws/profile/change_password.dart';
import 'package:loyaltylinx/pages/veiws/profile/email.dart';
import 'package:loyaltylinx/pages/veiws/profile/faqs.dart';
import 'package:loyaltylinx/pages/veiws/profile/help.dart';
import 'package:loyaltylinx/pages/veiws/profile/link_bank.dart';
import 'package:loyaltylinx/pages/veiws/profile/utils.dart';
import 'package:loyaltylinx/pages/veiws/verification/authorization.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userToken;

Future<void> deleteUserData(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  userToken = null;
  Future.delayed(const Duration(seconds: 5));
  Navigator.of(context).pushAndRemoveUntil(
      routeTransition(const LoginPage()), (Route<dynamic> route) => false);
}

Future<void> getUserToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('user_token');

  if (token != null) {
    final json = jsonDecode(token);
    userToken = (json)['token'].toString();
    print('User token found');
  } else {
    print('User token not found');
  }
}

Uint8List? image;

class ProfilePage extends StatefulWidget {
  final List<Object> userData;
  const ProfilePage({super.key, required this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final userData0 = userData1;
    // final isVerified = "${userData1[0]['verification']['isVerified']}";
    final verificationStatus = "${userData1[0]['verification']['status']}";
    getUserToken();
    return Scaffold(
      body: _buildBody(
          context, userData0, verificationStatus, verificationStatus),
    );
  }
}

bool verifiedData = false;

Widget _buildBody(context, userData0, status, verificationStatus) {
  // var userData = userData0[0]['verifacation']['isVerified'];

  showMessage({required String title, required String message}) {
    showCupertinoDialog(
        context: context,
        builder: (contex) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text("Confirm"),
                onPressed: () async {
                  showDialog(
                      barrierColor: Theme.of(context).colorScheme.background,
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return const Center(child: CircularProgressIndicator());
                      });
                  deleteUserData(context);
                },
              ),
            ],
          );
        });
  }

  String? profilePhoto;
  String? code;

  Future<void> uploadFileFacePhoto(File imageFile, String token) async {
    // Define the endpoint URL for uploading the image
    Uri url =
        Uri.parse('https://loyaltylinx.cyclic.app/api/upload/profile-picture');

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
      profilePhoto = data;
    } else {
      // Handle error
      debugPrint('Failed to upload image: ${response.statusCode}');
      showMessage(title: "Failed to upload image", message: response.body);
    }
  }

  Future<void> refreshCode(String apiRefreshCode, String token, context) async {
    var url = Uri.parse(apiRefreshCode);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // final message = json['message'];
      code = json['secretCode'];
      Navigator.push(
          context,
          routeTransition(Authorization(
            code: code!,
          )));
    } else {
      final json = jsonDecode(response.body);
      final message = json['message'];
      await showMessage(title: "Failed to login", message: message);
    }
  }

  Future<void> cropImage(BuildContext context, File imageFile) async {
    // final cropper = ImageCropper();

    final croppedFile = await ImageCropper()
        .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Theme.of(context).colorScheme.background,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
    ]);
    if (croppedFile != null) {
      // Handle the cropped image file, for example, display it or upload it.
      print(croppedFile.path);
      uploadFileFacePhoto(File(croppedFile.path), userToken!);
    }
  }

  Future<void> pickImages(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      cropImage(context, File(pickedFile.path));
    }
  }

  void showSelectModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.17,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Scaffold(
                    body: Column(
                      children: [
                        ProfileButton(
                            title: "Choose from gallery",
                            icon: const Icon(Icons.browse_gallery_outlined),
                            onTap: () {
                              pickImages(context, ImageSource.gallery);
                            }),
                        ProfileButton(
                            title: "Take photo",
                            icon: const Icon(Icons.camera_alt_outlined),
                            onTap: () {
                              pickImages(
                                context,
                                ImageSource.camera,
                              );
                            })
                      ],
                    ),
                  ));
            });
      },
    );
  }

  return SingleChildScrollView(
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            CircleAvatar(
              radius: 64,
              backgroundImage: profilePhoto != null
                  ? const NetworkImage(
                      'http://res.cloudinary.com/duhaupnxy/image/upload/v1714721888/LoyaltyLinx/ProfilePicture/asaspz2jfs1ipulmj5ie.jpg')
                  : NetworkImage(profile),
            ),
            Positioned(
              bottom: -6,
              right: -1,
              child: IconButton(
                  iconSize: 18,
                  style: ButtonStyle(
                      minimumSize:
                          const MaterialStatePropertyAll(Size(10 * 2, 10 * 2)),
                      maximumSize:
                          const MaterialStatePropertyAll(Size(18 * 2, 18 * 2)),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.grey.shade300)),
                  splashRadius: 1,
                  onPressed: () {
                    showSelectModal(context);
                  },
                  icon: const Icon(
                    Icons.add_a_photo_rounded,
                    color: Colors.black,
                  )),
            )
          ]),
          const SizedBox(
            height: 8,
          ),
          Text(
            ("${userData0[0]['firstName']} ${userData0[0]['lastName']}"),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Top Sales Man ",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Account",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                SizedBox(
                    child: status == "new"
                        ? verifyButton(
                            context,
                            "Verify now!",
                            () {
                              refreshCode(
                                  'https://loyaltylinx.cyclic.app/api/user/refresh-code',
                                  userToken!,
                                  context);
                            },
                          )
                        : status == "pending"
                            ? verifyButton(
                                context,
                                "Verifying",
                                () {},
                              )
                            : verifyButton(
                                context,
                                "Verified!",
                                () {},
                              ))
              ],
            ),
          ),

          tiles(context, [
            ProfileButton(
              icon: const Icon(Icons.phone_android_outlined),
              title: "Phone number",
              onTap: () async {
                print(userData1[0]['verification']['status']);
              },
            ),
            divider(context),
            ProfileButton(
              icon: const Icon(Icons.email_outlined),
              title: "Email",
              onTap: () async {
                Navigator.push(
                    context,
                    routeTransition(Email(
                      email: userData1[0]['email'],
                    )));
              },
            ),
            divider(context),
            ProfileButton(
              icon: const Icon(Icons.pin_drop_outlined),
              title: "Address",
              onTap: () async {
                Navigator.push(context, routeTransition(const Address()));
              },
            ),
            divider(context),
            ProfileButton(
              icon: const Icon(Icons.credit_card),
              title: "Linked card",
              onTap: () async {
                // Navigator.push(context, routeTransition(const LinkCard()));
              },
            ),
          ]),
          // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: Row(
          //     children: [
          //       Text(
          //         "Settings",
          //         style: TextStyle(
          //             color: Theme.of(context).colorScheme.primary,
          //             fontSize: 22,
          //             fontWeight: FontWeight.w600),
          //       ),
          //     ],
          //   ),
          // ),
          divider(context),
          tiles(context, [
            ProfileButton(
              icon: const Icon(Icons.change_circle_outlined),
              title: "Change password",
              onTap: () {
                Navigator.push(
                    context,
                    routeTransition(
                      const NewPasswordForm(),
                    ));
              },
            ),
            divider(context),
            ProfileButton(
              icon: const Icon(Icons.link),
              title: "Link Bank Or Credit cards",
              onTap: () {
                Navigator.push(context, routeTransition(const LinkBank()));
                print("card");
              },
            ),
            divider(context),
            ProfileButton(
              icon: const Icon(Icons.question_answer_outlined),
              title: "FAQ's",
              onTap: () {
                Navigator.push(context, routeTransition(const Faqs()));
                print("card");
              },
            ),
            divider(context),
            ProfileButton(
              icon: const Icon(Icons.help_outline_outlined),
              title: "Help",
              onTap: () {
                Navigator.push(context, routeTransition(const HelpPage()));
                print("card");
              },
            ),
          ]),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () async {
              showMessage(
                  title: "Sign Out", message: "Would you like to sign out?");
            },
            child: Ink(
              width: MediaQuery.of(context).size.width / 1,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15)),
              child: const Center(
                  child: Text(
                "Sign out",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    ),
  );
}

ElevatedButton verifyButton(context, String title, onPress) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          side: const BorderSide(width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: Theme.of(context).colorScheme.background),
      onPressed: onPress,
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ));
}

class CropImage extends StatefulWidget {
  const CropImage({super.key});

  @override
  State<CropImage> createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Column(
        children: [Text("data")],
      )),
    );
  }
}

Container divider(context) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    height: 2,
    child: Divider(
      color: Colors.grey.shade500,
    ),
  );
}

SizedBox tiles(context, children) {
  return SizedBox(
      width: MediaQuery.of(context).size.width / 1,
      // decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.primaryContainer),
      child: Column(children: children));
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Icon icon;
  final Function onTap;
  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
        onTap: () {
          onTap();
        }, //add function here to navigate to the specific page
        child: Ink(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: MediaQuery.of(context).size.height / 12,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: icon,
                ),
                Text(
                  title,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                )
              ],
            ),
          ),
        ));
  }
}

// PageRouteBuilder<dynamic> routeTransition(screenView) {
//   return PageRouteBuilder(
//     transitionDuration: const Duration(milliseconds: 300),
//     pageBuilder: (context, animation, secondaryAnimation) => screenView,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(1, 0),
//           end: Offset.zero,
//         ).animate(animation),
//         child: child,
//         // opacity: animation,
//         // child: ScaleTransition(
//         //   scale: Tween<double>(begin: 0.8, end: 1.0).animate(
//         //       CurvedAnimation(parent: animation, curve: Curves.easeIn)),
//         //   child: child,
//         // )
//       );
//     },
//   );
// }

PageRouteBuilder<dynamic> routeTransition(screenView) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => screenView,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ));
    },
  );
}

void selectImage() async {
  try {
    Uint8List img = await pickImage(ImageSource.camera);
    if (img.isEmpty) {
      return;
    } else {
      image = img;
    }
  } on PlatformException catch (e) {
    print("failed tp ickr $e");
  }
}
