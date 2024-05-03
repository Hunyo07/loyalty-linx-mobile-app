// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:loyaltylinx/pages/veiws/verification/overlay_face.dart';
import 'package:loyaltylinx/pages/veiws/verification/review_details.dart';

class FaceRecognition extends StatefulWidget {
  final String birthDate;
  final String gender;
  final String province;
  final String municipality;
  final String postalCode;
  final String address;
  final String imagePath;
  final String idType;
  final File? idPhoto;
  const FaceRecognition(
      {super.key,
      required this.birthDate,
      required this.gender,
      required this.province,
      required this.municipality,
      required this.postalCode,
      required this.address,
      required this.imagePath,
      required this.idType,
      required this.idPhoto});

  @override
  State<FaceRecognition> createState() => _MyWidgetState();
}

String? birthDate;
String? gender;
String? province;
String? municipal;
String? postalCode;
String? imagePath;
String? address;
String? idType;
File? idPHoto;

class _MyWidgetState extends State<FaceRecognition> {
  void showCameraModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.3,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return const ClipRRect(
                  // borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(30),
                  //     topRight: Radius.circular(30)),
                  child: CameraFace());
            });
      },
    );
  }

  @override
  void initState() {
    setState(() {
      address = widget.address;
      birthDate = widget.birthDate;
      province = widget.province;
      municipal = widget.municipality;
      postalCode = widget.postalCode;
      imagePath = widget.imagePath;
      gender = widget.gender;
      idType = widget.idType;
      idPHoto = widget.idPhoto;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Face identity"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Text(
                'Ready for taking photo selfie with your ID',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsetsDirectional.all(20),
                decoration: const BoxDecoration(),
                child: Image.asset(
                  'assets/images/photo_with_id.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ensure all details on the ID are visible, including your name, photo, and relevant information.',
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Hold your ID next to your face, making sure both are visible in the frame.and keep a neutral expression and avoid covering any details on the ID.',
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Make sure the background is simple and not too cluttered. A plain wall or a tidy room works well.',
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
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
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.amber.shade900,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text(
                      "Take Selfie Photo",
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraFace extends StatefulWidget {
  const CameraFace({
    super.key,
  });

  @override
  State<CameraFace> createState() => _CameraFaceState();
}

final photos = <File>[];

File? _imageFile;

class _CameraFaceState extends State<CameraFace> {
  late CameraController _controller;
  late Future<void> _initializeCameraFuture;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _initializeCamera();
  }

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

      final image = img.decodeImage(imageFile.readAsBytesSync());

      final croppedImage = img.copyCrop(
        image!,
        x: 0,
        y: 0,
        width: image.width,
        height: image.height,
      );

      final mirroredImage =
          _controller.description.lensDirection == CameraLensDirection.front
              ? img.flipHorizontal(croppedImage)
              : croppedImage;

      final compressedImage = img.encodeJpg(mirroredImage, quality: 70);

      final croppedImageFile =
          File(imageFile.path.replaceFirst('.jpg', '_cropped_id.jpg'));
      croppedImageFile.writeAsBytesSync(compressedImage);

      photos.add(croppedImageFile);

      setState(() {
        _imageFile = croppedImageFile;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ImagePreview()));
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.last;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    await _controller.initialize();
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

  void _switchCamera() async {
    final cameras = await availableCameras();
    final currentCamera = _controller.description.lensDirection;
    final newCamera = cameras.firstWhere(
      (camera) => camera.lensDirection != currentCamera,
      orElse: () => cameras.first,
    );

    await _controller.dispose();
    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeCameraFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
                title: const Text("Face identity"),
                backgroundColor: Theme.of(context).colorScheme.background,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            body: Stack(
              children: [
                CameraPreview(_controller),
                CustomPaint(
                  painter: OverlayPainterFace(
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
                              "",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent),
                                  onPressed: _toggleFlash,
                                  child: Icon(
                                    _isFlashOn
                                        ? Icons.flash_on
                                        : Icons.flash_off,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                SizedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.fromBorderSide(
                                            BorderSide(
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: _switchCamera,
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent),
                                  child: Icon(
                                    Icons.switch_camera,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
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

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  // Future<void> uploadFile(File imageFile, String token) async {
  //   // Define the endpoint URL for uploading the image
  //   Uri url = Uri.parse('https://loyaltylinx.cyclic.app/api/upload/valid-id');

  //   // Create a multipart request
  //   var request = http.MultipartRequest('POST', url);

  //   // Add the image file to the request
  //   var fileStream = http.ByteStream(imageFile.openRead());
  //   var length = await imageFile.length();
  //   var multipartFile =
  //       http.MultipartFile('image', fileStream, length, filename: 'image.jpg');
  //   request.files.add(multipartFile);

  //   // Set the bearer token in the authorization header
  //   request.headers['Authorization'] = 'Bearer $token';

  //   // Send the request
  //   var response = await http.Response.fromStream(await request.send());

  //   // Handle the response
  //   if (response.statusCode == 200) {
  //     // Successful upload
  //     final json = jsonDecode(response.body);
  //     final urlFaceWithId = (json)['imageUrl'].toString();
  //   } else {
  //     // Handle error
  //     debugPrint('Failed to upload image: ${response.statusCode}');
  //   }
  // }

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
                      onPressed: () {
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
                        // double sizeInKB = _imageFile!.lengthSync() / 1024;
                        // debugPrint("Size of _imageFile: $sizeInKB KB");
                        Navigator.pushAndRemoveUntil(
                            context,
                            routeTransition(PreviewDetails(
                                facePhoto: _imageFile,
                                idPhoto: idPHoto!,
                                address: address.toString(),
                                gender: gender.toString(),
                                province: province.toString(),
                                municipal: municipal.toString(),
                                postalCode: postalCode.toString(),
                                typeId: idType.toString(),
                                birthDate: birthDate.toString())),
                            (route) => false);
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
