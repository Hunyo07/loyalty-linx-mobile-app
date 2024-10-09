// ignore_for_file: avoid_print, use_build_context_synchronously, void_checks, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyaltylinx/main.dart';
// import 'package:loyaltylinx/pages/auth/link_card.dart';
import 'package:loyaltylinx/pages/auth/login.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/profile/email.dart';
import 'package:loyaltylinx/pages/veiws/profile/settings.dart';
import 'package:loyaltylinx/pages/veiws/verification/otp_send_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import 'package:unicons/unicons.dart';

Uint8List? image;
bool verifiedData = false;
String? code;
String status = '';

Future<void> deleteUserData(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  userData1 = [];
  userData0 = [];
  tokenMain = '';
  Future.delayed(const Duration(seconds: 5));
  Navigator.of(context).pushAndRemoveUntil(
      routeTransition(const LoginPage(
        mobileNo: "",
      )),
      (Route<dynamic> route) => false);
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ScrollController scrollController = ScrollController();
  Future<void> uploadProfile(
      String apiUploadProfile, String token, String path, context) async {
    var url = Uri.parse(apiUploadProfile);
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"imagePath": path}));

    if (response.statusCode == 200) {
      getProfile(tokenMain!);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      final json = jsonDecode(response.body);
      final message = json['message'];
      print(json);
      showMessage(title: "Failed to upload photo", message: message);
    }
  }

  Future<void> uploadFileFacePhoto(File imageFile, String token) async {
    // Define the endpoint URL for uploading the image
    Uri url = Uri.parse(
        'https://loyalty-linxapi.vercel.app/api/upload/profile-picture');

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
      uploadProfile(
          'https://loyalty-linxapi.vercel.app/api/user/upload-profile-picture',
          tokenMain!,
          data,
          context);
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
      code = json['secretCode'];
      Navigator.pushReplacement(
          context, routeTransition(ApplyCreditOtp(userCode: code!)));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      final json = jsonDecode(response.body);

      print(json);
    }
  }

  Future<void> cropImage(BuildContext context, File imageFile) async {
    // final croppedFile = await ImageCropper()
    //     .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
    //   CropAspectRatioPreset.square,
    // ], uiSettings: [
    //   AndroidUiSettings(
    //     toolbarTitle: 'Crop Image',
    //     toolbarColor: Theme.of(context).colorScheme.background,
    //     toolbarWidgetColor: Colors.white,
    //     initAspectRatio: CropAspectRatioPreset.original,
    //     lockAspectRatio: true,
    //   ),
    //   IOSUiSettings(
    //     minimumAspectRatio: 1.0,
    //   )
    // ]);
    // if (croppedFile != null) {
    //   File imageFiles = File(croppedFile.path);
    //   final image = img.decodeImage(imageFiles.readAsBytesSync());
    //   img.Image resizedImage = img.copyResize(image!, width: 800);
    //   List<int> compressedImage = img.encodeJpg(resizedImage, quality: 30);
    //   final croppedImageFile =
    //       File(imageFiles.path.replaceFirst('.jpg', '_cropped_photo.jpg'));
    //   croppedImageFile.writeAsBytesSync(compressedImage);

    //   if (croppedImageFile != null) {
    //     uploadFileFacePhoto(croppedImageFile, tokenMain!);
    //   }
    //   double sizeInKB = croppedImageFile.lengthSync() / 1024;
    //   debugPrint("Size of _imageFile: $sizeInKB KB");
    // } else {
    //   Navigator.of(context, rootNavigator: true).pop();
    // }
  }

  Future<void> pickImages(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      showDialog(
          barrierColor: Theme.of(context).colorScheme.background,
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      cropImage(context, File(pickedFile.path));
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('https://loyalty-linxapi.vercel.app/api/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = json['userProfile'];
      if (userData != null) {
        if (userData['profilePicture'] != null) {
          setState(() {
            profile = userData['profilePicture'];
            userData0 = [userData];
          });
          print(userData1);
        }
      }
    } else {}
  }

  void refreshPage() {
    getProfile(tokenMain!);
    setState(() {
      //asdadadasds
    });
  }

  @override
  void initState() {
    status = "${userData1[0]['verification']['status']}";
    super.initState();
  }

  void onPressVerify() {
    if (status == 'new') {
      showDialog(
        barrierColor: Theme.of(context).colorScheme.background,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      refreshCode('https://loyalty-linxapi.vercel.app/api/user/refresh-code',
          tokenMain!, context);
    } else {
      showMessageVerify(
        message: "Your verification request is still on process",
      );
    }
  }

  ElevatedButton verifyButton(context, String title, onPress) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            side: BorderSide(
                width: 1, color: Theme.of(context).colorScheme.inverseSurface),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer),
        onPressed: onPress,
        child: Row(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(
              width: 6,
            ),
            status == 'approved' ? const Icon(Icons.verified) : const Text("")
          ],
        ));
  }

  final Map<String, String> titleVerify = {
    "approved": 'Verified',
    "pending": 'On process...',
    "new": 'Verify now'
  };
  void showPickImageModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.168,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Material(
                    child: Column(
                      children: [
                        CameraPickButton(
                            title: "Camera",
                            icon: const Icon(Icons.camera_alt_rounded),
                            onTap: () {
                              pickImages(context, ImageSource.camera);
                            }),
                        CameraPickButton(
                            title: "Gallery",
                            icon: const Icon(Icons.browse_gallery),
                            onTap: () {
                              pickImages(context, ImageSource.gallery);
                            })
                      ],
                    ),
                  ));
            });
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        return refreshPage();
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              color: const Color.fromARGB(255, 248, 204, 129),
              width: double.infinity,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {
                        showPickImageModal(context);
                      },
                      icon: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile!),
                      )),
                ],
              ),
            ),
          ])),
          SliverPersistentHeader(
            pinned: true,
            delegate: MyHeaderDelegate(),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              child: verifyButton(context, titleVerify[status]!,
                                  () {
                            status == 'new'
                                ? onPressVerify()
                                : status == 'pending'
                                    ? showMessageVerify(
                                        message:
                                            "Your verification request is still on process")
                                    : showMessageVerify(
                                        message: "You are verified!");
                          })
                              // status == "new"
                              //     ? verifyButton(
                              //         context,
                              //         "Verify now",
                              //         () {
                              //           showDialog(
                              //               barrierColor: Theme.of(context)
                              //                   .colorScheme
                              //                   .background,
                              //               barrierDismissible: false,
                              //               context: context,
                              //               builder: (context) {
                              //                 return const Center(
                              //                     child:
                              //                         CircularProgressIndicator());
                              //               });
                              //           refreshCode(
                              //               'https://loyalty-linxapi.vercel.app/api/user/refresh-code',
                              //               tokenMain!,
                              //               context);
                              //         },
                              //       )
                              //     : status == "pending"
                              //         ? verifyButton(
                              //             context,
                              //             "On process...",
                              //             () {
                              //               showMessageVerify(
                              //                   message:
                              //                       "Your verification request is still on process");
                              //             },
                              //           )
                              //         : verifyButton(
                              //             context,
                              //             "Verified",
                              //             () {},
                              //           )
                              ),
                        ],
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  tiles(context, [
                    ProfileButton(
                      icon: const Icon(UniconsLine.user),
                      title: "Profile",
                      onTap: () async {
                        print(tokenMain);
                      },
                    ),
                    ProfileButton(
                      icon: const Icon(CupertinoIcons.heart),
                      title: "Favorites",
                      onTap: () async {
                        Navigator.push(
                            context,
                            routeTransition(Email(
                              email: userData1[0]['email'],
                            )));
                      },
                    ),
                    ProfileButton(
                      icon: const Icon(UniconsLine.cog),
                      title: "Settings",
                      onTap: () async {
                        Navigator.push(
                            context, routeTransition(const Settings()));
                      },
                    ),
                    ProfileButton(
                      icon: const Icon(UniconsLine.comment_question),
                      title: "FAQ'S",
                      onTap: () async {
                        print(userData1[0]['qrCode']);
                      },
                    ),
                    ProfileButton(
                      icon: const Icon(CupertinoIcons.question),
                      title: "Help",
                      onTap: () async {
                        print(userData1[0]['qrCode']);
                      },
                    ),
                    ProfileButton(
                      icon: Icon(login),
                      title: "Log out",
                      onTap: () async {
                        showMessageSignOut(
                            title: "Sign Out",
                            message: "Would you like to sign out?");
                      },
                    ),
                  ]),
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  )
                ],
              ),
            ),
          ])),
        ],
      ),
    ));
  }

  IconData login = const IconData(0xe3b3, fontFamily: 'MaterialIcons');

  showMessage({required String title, required String message}) {
    showCupertinoDialog(
        context: context,
        builder: (contex) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  showMessageVerify({required String message}) {
    showCupertinoDialog(
        context: context,
        builder: (contex) {
          return CupertinoAlertDialog(
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  showMessageSignOut({required String title, required String message}) {
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
                  Navigator.pop(context);
                  deleteUserData(context);
                },
              ),
            ],
          );
        });
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              child: ColoredBox(color: Color.fromARGB(255, 248, 204, 129))),
          AnimatedContainer(
            duration: const Duration(milliseconds: 5),
            alignment: Alignment.lerp(
              Alignment.bottomCenter,
              Alignment.bottomCenter,
              progress,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ("${userData1[0]['firstName']} ${userData1[0]['lastName']}"),
                  style: TextStyle.lerp(
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                    Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.black,
                        ),
                    progress,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
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

Container tiles(context, children) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      width: MediaQuery.of(context).size.width / 1,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onTap();
          }, //add function here to navigate to the specific page
          child: Ink(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
                border: Border.fromBorderSide(BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.secondary)),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primaryContainer),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height / 12,
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        title,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

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

class CameraPickButton extends StatelessWidget {
  const CameraPickButton({
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
