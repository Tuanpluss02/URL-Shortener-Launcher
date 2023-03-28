import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:url_shortener_flutter/controllers/bool_var.dart';
import 'package:url_shortener_flutter/utils/submit_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final shortNameController = TextEditingController();
  final BoolVar isSubmitting = Get.put(BoolVar());
  final BoolVar isSuccess = Get.put(BoolVar());
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  Artboard? bearArtboard;
  SMIBool? isChecking, isHandsUp;
  SMITrigger? trigSuccess, numLook, trigFail;
  StateMachineController? stateMachineController;

  @override
  void dispose() {
    super.dispose();
    passwordFocus.removeListener(_onPasswordFocusChange);
    passwordFocus.dispose();
    usernameFocus.removeListener(_onNameFocusChange);
    usernameFocus.dispose();
  }

  void _onNameFocusChange() {
    if (usernameFocus.hasFocus) {
      isChecking!.value = true;
    } else {
      isChecking!.value = false;
    }
    setState(() {
      isChecking!.value = isChecking!.value;
    });
  }

  void _onPasswordFocusChange() {
    if (passwordFocus.hasFocus) {
      isHandsUp!.value = true;
    } else {
      isHandsUp!.value = false;
    }
    setState(() {
      isHandsUp!.value = isHandsUp!.value;
    });
  }

  @override
  void initState() {
    usernameFocus.addListener(_onNameFocusChange);
    passwordFocus.addListener(_onPasswordFocusChange);
    super.initState();
    rootBundle.load('rive/login_bear.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        stateMachineController =
            StateMachineController.fromArtboard(artboard, "Login Machine");
        if (stateMachineController != null) {
          artboard.addController(stateMachineController!);
          var inputListener = stateMachineController!.inputs as List;
          isChecking = inputListener.first as SMIBool;
          isHandsUp = inputListener[1] as SMIBool;
          trigSuccess = inputListener[2] as SMITrigger;
          trigFail = inputListener.last as SMITrigger;
          // for (var e in stateMachineController!.inputs) {
          //   debugPrint(e.runtimeType.toString());
          //   debugPrint("name ${e.name} End");
          // }
          // try {
          //   onHoverDetect = stateMachineController!.inputs.first as SMIBool;
          // } on Exception catch (exception) {
          //   debugPrint(exception.toString());
          // } catch (error) {
          //   debugPrint(error.toString());
          // }
        }

        setState(() => bearArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Stack(
      children: [
        Image.asset("assets/background.jpg",
            width: size.width, height: size.height, fit: BoxFit.cover),
        loginForm(
          size,
          formKey,
          context,
          bearArtboard,
          usernameController,
          shortNameController,
          isSuccess,
          isSubmitting,
        ),
      ],
    ));
  }

  Widget loginForm(
      Size size,
      GlobalKey<FormState> formKey,
      BuildContext context,
      Artboard? bearArtboard,
      TextEditingController usernameController,
      TextEditingController shortNameController,
      BoolVar isSuccess,
      BoolVar isSubmitting) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.35, vertical: size.height * 0.1),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            // color: Colors.white.withOpacity(0.1),
            margin: const EdgeInsets.all(20),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Login',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'RobotReavers',
                        )),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        height: 200,
                        width: 300,
                        child: Rive(
                          artboard: bearArtboard!,
                          // alignment: Alignment.center,
                        ),
                      ),
                    ),
                    TextFormField(
                      focusNode: usernameFocus,
                      controller: usernameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54, // Set the color you want here
                        ),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      focusNode: passwordFocus,
                      controller: shortNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black54, width: 2.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black45),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black54, // Set the color you want here
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                      // onSaved: (newValue) {
                      //   shortUrl.value = apiDomain + newValue!;
                      // },
                    ),
                    const SizedBox(height: 20),
                    SubmitButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          isSubmitting.val = true;
                          isSuccess.val = await _submitForm(
                              usernameController, shortNameController);
                        }
                      },
                      isSuccess: isSuccess,
                      isSubmitting: isSubmitting,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submitForm(
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) async {}
}
