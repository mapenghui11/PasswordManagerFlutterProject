import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetPasswordInfoPage extends StatefulWidget {
  final String pwdToSumbit;
  const SetPasswordInfoPage({super.key, required this.pwdToSumbit});

  @override
  State<SetPasswordInfoPage> createState() => _SetPasswordInfoPageState();
}

class _SetPasswordInfoPageState extends State<SetPasswordInfoPage> {
  int items = 0;

  String name = '';
  String pwdUrl = '';
  String note = '';
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Text(
            'Enter and save the information.',
            style: TextStyle(fontSize: 17),
          ),
          backgroundColor: themeColor,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const PromptText(
                  promptText: 'Add a name to your password :',
                  margin: 75,
                ),
                InputPWDInfo(
                  kbType: TextInputType.name,
                  pwdInfo: (String value) {
                    name = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const PromptText(
                  promptText: 'Which web or app is this password for?',
                  margin: 10,
                ),
                InputPWDInfo(
                  kbType: TextInputType.url,
                  pwdInfo: (String value) {
                    pwdUrl = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const PromptText(
                  promptText: 'Your Password : ',
                  margin: 180,
                ),
                InputPWD(
                  generate_pwd: widget.pwdToSumbit,
                ),
                const SizedBox(
                  height: 20,
                ),
                const PromptText(
                  promptText: 'Note :',
                  margin: 250,
                ),
                InputPWDInfo(
                  kbType: TextInputType.text,
                  pwdInfo: (String value) {
                    note = value;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 260,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      var url =
                          Uri.http('192.168.1.12:8000', 'sumbit_pwdInfo/');
                      var response = await http.post(url,
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode({
                            'name': name,
                            'password': widget.pwdToSumbit,
                            'url': pwdUrl,
                            'note': note
                          }));
                      if (response.statusCode == 200) {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Submitted successfully',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54),
                            ),
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor:
                                const Color.fromARGB(255, 249, 224, 224),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.fromLTRB(104, 0, 104, 230),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                      ;
                    },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 17)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 249, 224, 224)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)))),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class PromptText extends StatefulWidget {
  final double margin;
  final String promptText;
  const PromptText({super.key, required this.promptText, required this.margin});

  @override
  State<PromptText> createState() => _PromptTextState();
}

class _PromptTextState extends State<PromptText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: widget.margin),
      child: Text(
        widget.promptText,
        style: const TextStyle(
            fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class InputPWDInfo extends StatefulWidget {
  final TextInputType kbType;
  final ValueChanged<String>? pwdInfo;
  const InputPWDInfo({super.key, required this.kbType, required this.pwdInfo});

  @override
  State<InputPWDInfo> createState() => _InputPWDInfoState();
}

class _InputPWDInfoState extends State<InputPWDInfo> {
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextField(
        cursorColor: Colors.black54,
        cursorHeight: 28,
        keyboardType: widget.kbType,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themeColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        onChanged: (value) {
          widget.pwdInfo?.call(value);
        },
      ),
    );
  }
}

class InputPWD extends StatefulWidget {
  final String generate_pwd;
  const InputPWD({super.key, required this.generate_pwd});

  @override
  State<InputPWD> createState() => _InputPWDState();
}

class _InputPWDState extends State<InputPWD> {
  bool _isObscured = true;
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.generate_pwd);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextField(
        controller: _controller,
        obscureText: _isObscured,
        cursorColor: Colors.black54,
        cursorHeight: 28,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w300,
          fontSize: 18,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: themeColor,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themeColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        onChanged: (value) {},
      ),
    );
  }
}
