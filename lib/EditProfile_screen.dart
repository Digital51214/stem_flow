import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stemflow/BottomNavigation_screen.dart';

import 'Widgets/backcircle.dart';
import 'Widgets/background.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Future<void> handlePickImage(ImageSource source) async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    await pickImage(source);
  }

  void showImagePickerSheet(Size mq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(mq.width * 0.06),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.06,
              vertical: mq.height * 0.025,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: mq.height * 0.005,
                  width: mq.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(mq.width * 0.03),
                  ),
                ),
                SizedBox(height: mq.height * 0.025),
                Text(
                  "Choose Profile Photo",
                  style: TextStyle(
                    fontSize: mq.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: "Mynor",
                  ),
                ),
                SizedBox(height: mq.height * 0.025),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await handlePickImage(ImageSource.gallery);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: mq.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff2F8F94).withOpacity(0.12),
                            borderRadius:
                            BorderRadius.circular(mq.width * 0.04),
                            border: Border.all(
                              color: const Color(0xff2F8F94),
                              width: mq.width * 0.0025,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.photo_library_rounded,
                                size: mq.width * 0.08,
                                color: const Color(0xff2F8F94),
                              ),
                              SizedBox(height: mq.height * 0.01),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                  fontSize: mq.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff2F8F94),
                                  fontFamily: "Mynor",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: mq.width * 0.04),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await handlePickImage(ImageSource.camera);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: mq.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff2F8F94).withOpacity(0.12),
                            borderRadius:
                            BorderRadius.circular(mq.width * 0.04),
                            border: Border.all(
                              color: const Color(0xff2F8F94),
                              width: mq.width * 0.0025,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt_rounded,
                                size: mq.width * 0.08,
                                color: const Color(0xff2F8F94),
                              ),
                              SizedBox(height: mq.height * 0.01),
                              Text(
                                "Camera",
                                style: TextStyle(
                                  fontSize: mq.width * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff2F8F94),
                                  fontFamily: "Mynor",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.height * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Bg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: mq.height - MediaQuery
                    .of(context)
                    .padding
                    .top,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: mq.height * 0.035),

                  Row(
                    children: [
                      BackCircle(
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Container(
                        height: 44,
                        width: 45,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Logo.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: mq.height * 0.08),

                  Center(
                    child: buildProfileImagePicker(mq),
                  ),

                  SizedBox(height: mq.height * 0.06),

                  buildTextField(
                    mq: mq,
                    controller: nameController,
                    hintText: "Rehan R",
                  ),

                  SizedBox(height: mq.height * 0.015),

                  buildTextField(
                    mq: mq,
                    controller: emailController,
                    hintText: "Example@mail.com",
                  ),

                  SizedBox(height: mq.height * 0.035),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WidgetTree()));
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff287D80),
                        borderRadius: BorderRadius.circular(mq.width * 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: mq.width * 0.02,
                            offset: Offset(0, mq.height * 0.004),
                          ),
                        ],
                      ),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mq.width * 0.039,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Mynor",
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: mq.height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildProfileImagePicker(Size mq) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Profile Image Circle
        Container(
          height: mq.width * 0.32,
          width: mq.width * 0.32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: selectedImage != null
                ? DecorationImage(
              image: FileImage(selectedImage!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: selectedImage == null
              ? Center(
            child: Icon(
              Icons.person,
              size: mq.width * 0.12,
              color: Colors.white.withOpacity(0.7),
            ),
          )
              : null,
        ),

        // Camera Icon (Bottom Right)
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              showImagePickerSheet(mq);
            },
            child: Container(
              height: mq.width * 0.085,
              width: mq.width * 0.085,
              decoration: BoxDecoration(
                color: const Color(0xff2F8F94),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: mq.width * 0.045,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required Size mq,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mq.width * 0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.75),
          width: mq.width * 0.0028,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "Mynor",
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: "Mynor",
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.05,
          ),
        ),
      ),
    );
  }
}