import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Utils.dart';
import 'form_header_widget.dart';
import 'package:email_validator/email_validator.dart';
import '../../utilities/constants.dart';

class ForgotPasswordMail extends StatefulWidget {
  const ForgotPasswordMail({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordMailScreen createState() => _ForgotPasswordMailScreen();
}


class _ForgotPasswordMailScreen extends State<ForgotPasswordMail> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> verifyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try{
      await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Password Reset Email Sent', context);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message ?? 'An error occurred', context);
      Navigator.of(context).pop();  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              const SizedBox(height: tDefaultSize*4),
              const FormHeaderWidget(
                image: tForgetPasswordImage,
                title: tForgetPasswordTitle1,
                subTitle: tForgetPasswordSubTitle1,
                crossAxisAlignment:  CrossAxisAlignment.center,
                heightBetween: 30,
                textAlign:  TextAlign.center,
              ),
              const SizedBox(height: tFromHeight),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      cursorColor: Colors.white,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        label: Text(tEmail),
                        hintText: tEmail,
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                      ),
                      validator: (email) => 
                        email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 16, 90, 168)),
                        ),
                        onPressed: verifyEmail,
                        child: const Text(
                          tNext,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        )
                      )
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}