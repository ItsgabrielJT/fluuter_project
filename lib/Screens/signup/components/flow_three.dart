import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluuter_project/components/my_button.dart';
import 'package:fluuter_project/controller/flow_controller.dart';
import 'package:fluuter_project/controller/sign_up_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluuter_project/models/file_model.dart';


class SignUpThree extends StatefulWidget {
  const SignUpThree({super.key});

  @override
  State<SignUpThree> createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {
  var user = FirebaseAuth.instance.currentUser!.uid;
  SignUpController signUpController =
      Get.put(SignUpController(), permanent: false);
  Future signUserUp() async {
    // create user

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpController.email.toString(),
        password: signUpController.password.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  String basename(String path) => basename(path);

  Future uploadImageFile() async {
    FilePickerResult? image = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (image != null) {
      Uint8List? fileBytes = image.files.first.bytes;
      String fileName = image.files.first.name;
      signUpController
          .setImageFile(FileModel(filename: fileName, fileBytes: fileBytes!));
    }
  }

  Future uploadPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String pdfName = result.files.first.name;
      signUpController
          .setResumeFile(FileModel(filename: pdfName, fileBytes: fileBytes!));
    }
  }

  FlowController flowController = Get.put(FlowController());

  @override
  Widget build(BuildContext context) {
    SignUpController signUpController =
        Get.put(SignUpController(), permanent: false);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Column(
          children: [
            Row(
              children: [
                
                const SizedBox(
                  width: 35,
                ),
                Text(
                  "Un paso mas",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#4f4f4f"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (signUpController.userType == "Topografo") ...[
                    Text(
                      "Año de registro",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: HexColor("#8d8d8d"),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      onChanged: (value) {
                        signUpController.setAdmissionYear(value);
                      },
                      onSubmitted: (value) {
                        signUpController.setAdmissionYear(value);
                      },
                      keyboardType: TextInputType.number,
                      cursorColor: HexColor("#4f4f4f"),
                      decoration: InputDecoration(
                        hintText: "2024",
                        fillColor: HexColor("#f0f3f1"),
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 15,
                          color: HexColor("#8d8d8d"),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                    ),
                  ] else
                    ...[],
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Foto de perfil",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: HexColor("#8d8d8d"),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      textStyle: MaterialStateProperty.all<TextStyle?>(
                        GoogleFonts.poppins(
                          fontSize: 15,
                          color: HexColor("#3e8e72"),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.fromLTRB(90, 15, 90, 15)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(const Color.fromRGBO(216, 239,229, 100)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                    ),
                    onPressed: () async {
                      uploadImageFile();
                      setState(() {
                        int i = 1 + 1;
                      });
                    },
                    child: const Text("Sube una imagen"),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  GetBuilder<SignUpController>(builder: (context) {
                    return Text(
                      signUpController.imageFile != null
                          ? signUpController.imageFile!.filename
                          : "Archivo no selecionado",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: HexColor("#4f4f4f"),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 5,
                  ),
                  
                  
                  const SizedBox(
                    height: 5,
                  ),
                  MyButton(
                    onPressed: () {
                      signUpController.postSignUpDetails();
                    },
                    buttonText: 'Finalizar',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
