import 'package:flutter/material.dart';
import 'package:password_manager/createPasswordPage.dart/showSelectedPR.dart';
import 'showPasswordWidget.dart';
import 'setPasswordRules.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  List<String> multipleSelected = [];
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Center(
          child: Text(
            'Create new password',
            style: TextStyle(fontSize: 20),
          ),
        ),
          backgroundColor: themeColor,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            PromptedAnchor(
              onMultipleSelectedChanged: (value) {
                setState(() {
                  multipleSelected = value;
                });
              },
            ),
            const SizedBox(height: 40,),
            showPassword(
              multipleSelected: multipleSelected,
            ),
            const SizedBox(height: 30,),
            ShowSelectedPR(
              multipleSelected: multipleSelected,
            ),
          ],
        ));
  }
}
