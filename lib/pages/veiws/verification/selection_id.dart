// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:loyaltylinx/pages/veiws/navbottom.dart';
import 'package:loyaltylinx/pages/veiws/verification/facerecognition.dart';
import 'package:loyaltylinx/pages/veiws/verification/overlay.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectionId extends StatefulWidget {
  final String birthDate;
  final String gender;
  final String province;
  final String municipality;
  final String postalCode;
  final String address;
  const SelectionId(
      {super.key,
      required this.birthDate,
      required this.gender,
      required this.province,
      required this.municipality,
      required this.postalCode,
      required this.address});

  @override
  State<SelectionId> createState() => _SelectionIdState();
}

const apiUrlId = 'https://loyalty-linxapi.vercel.app/api/upload/valid-id';
String? birthDate;
String? gender;
String? province;
String? municipal;
String? postalCode;
String? address;
String? imagePath;
String? selecteID;
bool _isFlashOn = false;

class _SelectionIdState extends State<SelectionId> {
  late CameraController controller;

  // getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   final userData1 = prefs.getString('user_data');
  //   if (userData1 != null) {
  //     userData = [jsonDecode(userData1)['userProfile']];
  //     debugPrint(userData.runtimeType.toString());
  //   } else {
  //     debugPrint('User data not found');
  //   }
  // }

  @override
  void initState() {
    // getUserData();
    setState(() {
      birthDate = widget.birthDate;
      gender = widget.gender;
      postalCode = widget.postalCode;
      address = widget.address;
      municipal = widget.municipality;
      province = widget.province;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Selection Id'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BottomNavBarExample(userData: userData1)),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text("Recommended ID",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Text("Please select you id to use for verification"),
            const SizedBox(
              height: 60,
            ),
            ProfileButton(
              icon: const Icon(Icons.add_card),
              title: "DRIVERS LICENSE",
              onTap: () {
                setState(() {
                  selecteID = "Drivers License";
                });
                showGuide(context, "DRIVERS LICENSE");
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ProfileButton(
              icon: const Icon(Icons.add_card),
              title: "UMID",
              onTap: () {
                setState(() {
                  selecteID = "UMID";
                });
                showGuide(context, 'UMID');
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ProfileButton(
              icon: const Icon(Icons.add_card),
              title: "PASSPORT",
              onTap: () {
                setState(() {
                  selecteID = "PASSPORT";
                });
                showGuide(context, "PASSPORT");
              },
            ),
            // divider(context),
            const SizedBox(
              height: 15,
            ),
            ProfileButton(
              icon: const Icon(Icons.add_card),
              title: "NATIONALS ID",
              onTap: () {
                setState(() {
                  selecteID = "Nationals ID";
                });
                showGuide(context, "NATIONAL ID");
              },
            ),
          ],
        ),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
          onTap: () {
            onTap();
          }, //add function here to navigate to the specific page
          child: Ink(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primaryContainer,
              border: Border.fromBorderSide(BorderSide(
                  width: 1.5, color: Theme.of(context).colorScheme.secondary)),
            ),
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
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                  )
                ],
              ),
            ),
          )),
    );
  }
}

void showGuide(BuildContext context, title) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: IdSelected(
                  title: title,
                ));
          });
    },
  );
}

void showCameraModal(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.3,
          maxChildSize: 1,
          builder: (BuildContext context, ScrollController scrollController) {
            return const ClipRRect(child: CameraView());
          });
    },
  );
}

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  void deleteImage() async {
    Navigator.pop(context);
    Future.delayed(const Duration(seconds: 3));
    if (_imageFile != null) {
      _imageFile!.delete();
      setState(() {
        _imageFile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
              child: _imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.scaleDown,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      onPressed: () => deleteImage(),
                      child: const Icon(
                        Icons.replay_circle_filled_sharp,
                        size: 40,
                      ),
                    ),
                    const Text("Retake")
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.amber.shade900,
                      elevation: 0,
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
                        // uploadFile(_imageFile!, userToken!);
                        double sizeInKB = _imageFile!.lengthSync() / 1024;
                        debugPrint("Size of _imageFile: $sizeInKB KB");
                        Navigator.pushReplacement(
                          context,
                          routeTransition(FaceRecognition(
                            idPhoto: _imageFile,
                            birthDate: birthDate.toString(),
                            gender: gender.toString(),
                            province: province.toString(),
                            municipality: municipal.toString(),
                            postalCode: postalCode.toString(),
                            address: address.toString(),
                            imagePath: _imageFile!.path.toString(),
                            idType: selecteID.toString(),
                          )),
                        );
                      },
                      child: const Icon(
                        Icons.check_circle,
                        size: 40,
                      ),
                    ),
                    const Text("Proceed")
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

final photos = <File>[];

File? _imageFile;
Future<void> _requestPermissions() async {
  final cameraStatus = await Permission.camera.request();
  final storageStatus = await Permission.storage.request();

  if (cameraStatus != PermissionStatus.granted &&
      storageStatus != PermissionStatus.granted) {
    // Handle permission denied
  }
}

class _CameraViewState extends State<CameraView> {
  Future<void> takePhoto() async {
    if (_controller.value.isInitialized) {
      showDialog(
          barrierColor: Theme.of(context).colorScheme.background,
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      final XFile imageSFile = await _controller.takePicture();
      final imageFile = File(imageSFile.path);

      try {
        final image = img.decodeImage(imageFile.readAsBytesSync());

        final croppedImage = img.copyCrop(
          image!,
          x: 20,
          y: 150,
          width: 440,
          height: 280,
        );

        final compressedImage = img.encodeJpg(croppedImage, quality: 70);

        final croppedImageFile =
            File(imageFile.path.replaceFirst('.jpg', '_cropped_id.jpg'));
        croppedImageFile.writeAsBytesSync(compressedImage);

        photos.add(croppedImageFile);

        setState(() {
          _imageFile = croppedImageFile;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ImagePreview()));
      } catch (e) {
        debugPrint('Error decoding image;;;;: $e');
      }
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      if (_isFlashOn) {
        _controller.setFlashMode(FlashMode.torch);
      } else {
        _controller.setFlashMode(FlashMode.off);
      }
    });
  }

  late CameraController _controller;
  late Future<void> _initializeCameraFuture;

  @override
  void initState() {
    _initializeCameraFuture = _initializeCamera();
    super.initState();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    // await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeCameraFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        _toggleFlash();
                      },
                      icon: _isFlashOn == true
                          ? const Icon(Icons.flash_on)
                          : const Icon(Icons.flash_off)),
                )
              ],
            ),
            body: Stack(
              children: [
                CameraPreview(_controller),
                CustomPaint(
                  painter: OverlayPainter(
                      screenHeight: MediaQuery.of(context).size.height,
                      screenWidth: MediaQuery.of(context).size.width),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.background,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Place the front of ID within the frame",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                            SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.fromBorderSide(BorderSide(
                                        width: 5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))),
                                child: IconButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(0)),
                                    ),
                                    onPressed: takePhoto,
                                    icon: Icon(
                                      Icons.circle_sharp,
                                      size: 50,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class IdScannerOverlay extends StatelessWidget {
  const IdScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 2),
              color: Colors.black26,
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    width: 320,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white60, width: 2),
                    ),
                    child: const Text(''),
                  ),
                  const Text(
                    "Scan your ID",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Text(
                    "Place the ID within the frame",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IdSelected extends StatefulWidget {
  final String title;
  const IdSelected({super.key, required this.title});

  @override
  State<IdSelected> createState() => _IdSelectedState();
}

class _IdSelectedState extends State<IdSelected> {
  void openCamera() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraCamera(
                  onFile: (file) {
                    photos.add(file);
                    Navigator.pop(context);
                    setState(() {});
                  },
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.amber.shade900),
                  ),
                ),
              ],
            ),
            Guide(
                '1', 'Lighting', ' Natural light is usually the best option.'),
            const SizedBox(
              height: 10,
            ),
            Guide('2', 'Clean ID', ' Wipe it clean.'),
            const SizedBox(
              height: 10,
            ),
            Guide('3', 'Plain Background', ' Use a neutral surface.'),
            const SizedBox(
              height: 10,
            ),
            Guide('4', 'Flat Placement', ' Lay ID flat.'),
            const SizedBox(
              height: 10,
            ),
            Guide('5', 'Camera Position', ' Keep it parallel.'),
            const SizedBox(
              height: 10,
            ),
            Guide('6', 'Focus and Stability', ' Ensure clarity.'),
            const SizedBox(
              height: 10,
            ),
            Guide('7', 'Capture', '  the photo.'),
            const SizedBox(
              height: 10,
            ),
            Guide('8', 'Review', ' Check for clarity.'),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    showCameraModal(context);
                    _requestPermissions();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.amber.shade900,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    "Take ID photo",
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  FittedBox Guide(number, title, text) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text(
              '$number.',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              ' $title: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '$text',
              style: const TextStyle(fontSize: 14),
            ),
          ],
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
