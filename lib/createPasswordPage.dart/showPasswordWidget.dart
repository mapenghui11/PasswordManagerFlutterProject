import 'package:flutter/material.dart';
import '../managePasswordPage/savePasswordInfo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class showPassword extends StatefulWidget {
  final List<String> multipleSelected;
  const showPassword({super.key, required this.multipleSelected});

  @override
  State<showPassword> createState() => _showPasswordState();
}

class _showPasswordState extends State<showPassword> {
  String generatePwd = '';

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 240,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
                offset: Offset(6, 6), color: Colors.black12, blurRadius: 10)
          ]),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CreatePwdAndShow(
            multipleSelected: widget.multipleSelected,
            pwdText: (String value) {
              setState(() {
                generatePwd = value;
              });
            },
          ),
          SaveOrEditPassword(
            generatePWD: generatePwd,
          )
        ],
      ),
    ));
  }
}

class CreatePwdAndShow extends StatefulWidget {
  final List<String> multipleSelected;
  final ValueChanged<String>? pwdText;
  const CreatePwdAndShow(
      {super.key, required this.multipleSelected, required this.pwdText});

  @override
  State<CreatePwdAndShow> createState() => _CreatePwdAndShowState();
}

class _CreatePwdAndShowState extends State<CreatePwdAndShow> {
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);
  late TextEditingController _controller = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.pwdText?.call(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        SizedBox(
          width: 260,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.multipleSelected.isNotEmpty
                ? () async {
                    var url = Uri.http('192.168.1.12:8000', 'creat_password/');
                    var response = await http.post(url,
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          'SelectedPwdRules': widget.multipleSelected,
                        }));
                    if (response.statusCode == 200) {
                      var responseBodyMap = json.decode(response.body);
                      var generatePwd = responseBodyMap['generate_pwd'];
                      setState(() {
                        _controller.text = generatePwd;
                      });
                    }
                  }
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'At least choose one password rule.',
                          style: TextStyle(
                              fontSize: 14,
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
                        margin: const EdgeInsets.fromLTRB(60, 0, 60, 230),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
            style: ButtonStyle(
                textStyle:
                    MaterialStateProperty.all(const TextStyle(fontSize: 17)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 249, 224, 224)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)))),
            child: const Text(
              'Create Password',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ),
// ###################################################################################################
// ###################################################################################################
// ###################################################################################################
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 54,
          margin: const EdgeInsets.all(18),
          child: TextField(
            readOnly: _controller.text.isEmpty ? true : false,
            controller: _controller,
            cursorColor: Colors.black54,
            cursorHeight: 28,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
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
              setState(() {
                widget.pwdText?.call(value);
              });
            },
          ),
        )
      ],
    ));
  }
}

class SaveOrEditPassword extends StatefulWidget {
  final String generatePWD;

  const SaveOrEditPassword({super.key, required this.generatePWD});

  @override
  State<SaveOrEditPassword> createState() => _SaveOrEditPasswordState();
}

class _SaveOrEditPasswordState extends State<SaveOrEditPassword> {
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SizedBox(
        width: 90,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SetPasswordInfoPage(
                  pwdToSumbit: widget.generatePWD,
                ),
              ),
            );


          },
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(themeColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)))),
          child: const Text('Save'),
        ),
      ),
      SizedBox(
        width: 150,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.all(10)),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(themeColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)))),
          child: const Text('Create again'),
        ),
      )
    ]);
  }
}
