import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stemflow/services/edit_profile_service.dart';
import 'package:stemflow/team_side%20screens/profile_team_side.dart';
import 'package:stemflow/widgets/custom_toast.dart';

import '../Services/session_manager.dart';
import '../Widgets/backcircle.dart';
import '../Widgets/background.dart';


class EditProfileScreenTeamSide extends StatefulWidget {
  const EditProfileScreenTeamSide({super.key});

  @override
  State<EditProfileScreenTeamSide> createState() => _EditProfileScreenTeamSideState();
}

class _EditProfileScreenTeamSideState extends State<EditProfileScreenTeamSide> {
  final TextEditingController nameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  String currentProfilePic = "";
  String userId = "";
  bool isLoading = true;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      print("=== LOAD EDIT PROFILE DATA START ===");

      final id = await SessionManager.instance.getUserId();
      final username = await SessionManager.instance.getUsername();
      final fullName = await SessionManager.instance.getFullName();
      final profilePic = await SessionManager.instance.getProfilePic();

      print("User ID: $id");
      print("Username: $username");
      print("Full Name: $fullName");
      print("Profile Pic: $profilePic");

      userId = id;
      nameController.text = fullName.isNotEmpty
          ? fullName
          : (username.isNotEmpty ? username : "");
      currentProfilePic = profilePic;

      setState(() {
        isLoading = false;
      });

      print("=== LOAD EDIT PROFILE DATA SUCCESS ===");
      print("Final Name In Field: ${nameController.text}");
    } catch (e) {
      print("=== LOAD EDIT PROFILE DATA ERROR ===");
      print("Error: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      print("=== PICK IMAGE START ===");
      print("Source: $source");

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        print("Picked Image Path: ${image.path}");

        setState(() {
          selectedImage = File(image.path);
        });
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("=== PICK IMAGE ERROR ===");
      print("Error: $e");
    }
  }

  Future<void> handlePickImage(ImageSource source) async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 250));
    await pickImage(source);
  }

  Future<String> convertImageToBase64(File imageFile) async {
    try {
      print("=== CONVERT IMAGE TO BASE64 START ===");
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      String mimeType = "image/png";
      final path = imageFile.path.toLowerCase();

      if (path.endsWith(".jpg") || path.endsWith(".jpeg")) {
        mimeType = "image/jpeg";
      } else if (path.endsWith(".png")) {
        mimeType = "image/png";
      }

      final result = "data:$mimeType;base64,$base64String";

      print("=== CONVERT IMAGE TO BASE64 SUCCESS ===");
      print("Base64 Length: ${result.length}");

      return result;
    } catch (e) {
      print("=== CONVERT IMAGE TO BASE64 ERROR ===");
      print("Error: $e");
      rethrow;
    }
  }

  Future<void> updateProfile() async {
    final fullName = nameController.text.trim();

    print("=== UPDATE PROFILE BUTTON CLICKED ===");
    print("User ID: $userId");
    print("Full Name: $fullName");
    print("Selected Image: ${selectedImage?.path}");
    print("Current Profile Pic: $currentProfilePic");

    if (userId.isEmpty) {
      CustomToast.show(
        context: context,
        message: "User session not found",
        type: ToastType.error,
      );
      return;
    }

    if (fullName.isEmpty) {
      CustomToast.show(
        context: context,
        message: "Please enter full name",
        type: ToastType.error,
      );
      return;
    }

    String profilePicToSend = currentProfilePic;

    if (selectedImage != null) {
      profilePicToSend = await convertImageToBase64(selectedImage!);
    }

    if (profilePicToSend.isEmpty) {
      CustomToast.show(
        context: context,
        message: "Please select profile image",
        type: ToastType.error,
      );
      return;
    }

    setState(() {
      isUpdating = true;
    });

    final result = await EditProfileService.updateProfile(
      userId: userId,
      fullName: fullName,
      profilePicBase64: profilePicToSend,
    );

    print("=== FINAL EDIT PROFILE RESULT ===");
    print(result.toString());

    if (result["success"] == true) {
      await SessionManager.instance.updateProfileSession(
        fullName: fullName,
        profilePic: profilePicToSend,
      );

      setState(() {
        isUpdating = false;
      });

      CustomToast.show(
        context: context,
        message: result["message"] ?? "Profile updated successfully",
        type: ToastType.success,
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
              (route) => false,
        );
      });
    } else {
      setState(() {
        isUpdating = false;
      });

      CustomToast.show(
        context: context,
        message: result["message"] ?? "Profile update failed",
        type: ToastType.error,
      );
    }
  }

  void showImagePickerSheet(Size mq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF103E46),
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
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(mq.width * 0.03),
                  ),
                ),
                SizedBox(height: mq.height * 0.025),
                Text(
                  "Choose Profile Photo",
                  style: TextStyle(
                    fontSize: mq.width * 0.045,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
                            color: const Color(0xff2F8F94).withOpacity(0.14),
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
                                  color: Colors.white,
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
                            color: const Color(0xff2F8F94).withOpacity(0.14),
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
                                  color: Colors.white,
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

  Widget buildProfileImagePicker(Size mq) {
    ImageProvider? imageProvider;

    if (selectedImage != null) {
      imageProvider = FileImage(selectedImage!);
    } else if (currentProfilePic.isNotEmpty &&
        currentProfilePic.startsWith("http")) {
      imageProvider = NetworkImage(currentProfilePic);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
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
            image: imageProvider != null
                ? DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: imageProvider == null
              ? Center(
            child: Icon(
              Icons.person,
              size: mq.width * 0.12,
              color: Colors.white.withOpacity(0.7),
            ),
          )
              : null,
        ),
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
        style: const TextStyle(
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Bg(
        child: SafeArea(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xff287D80),
            ),
          )
              : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: mq.width * 0.07),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                mq.height - MediaQuery.of(context).padding.top,
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
                    hintText: "Enter full name",
                  ),
                  SizedBox(height: mq.height * 0.035),
                  GestureDetector(
                    onTap: isUpdating ? null : updateProfile,
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff287D80),
                        borderRadius:
                        BorderRadius.circular(mq.width * 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: mq.width * 0.02,
                            offset: Offset(0, mq.height * 0.004),
                          ),
                        ],
                      ),
                      child: isUpdating
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                          : Text(
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
}