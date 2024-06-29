import 'dart:convert';
import 'package:flutter/material.dart';
import 'createPasswordPage.dart/creatPasswordPage.dart';
import 'managePasswordPage/savePasswordInfo.dart';
import 'package:http/http.dart' as http;

class MyTabBar extends StatefulWidget {
  final int initialIndex;
  const MyTabBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          CreatePasswordPage(),
          SearchPwdInfo(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        fixedColor: themeColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.key), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Password'),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchPwdInfo extends StatefulWidget {
  const SearchPwdInfo({super.key});

  @override
  State<SearchPwdInfo> createState() => _SearchPwdInfoState();
}

class _SearchPwdInfoState extends State<SearchPwdInfo> {
  String searchContext = '';
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Center(
          child: Text(
            'Find your password',
            style: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: themeColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          InputToSearch(
            search: (value) {
              setState(() {
                searchContext = value;
              });
            },
          ),
          GetPwdInfo(
            searchText: searchContext,
          ),
        ],
      ),
    );
  }
}

class InputToSearch extends StatefulWidget {
  final ValueChanged? search;
  const InputToSearch({super.key, required this.search});

  @override
  State<InputToSearch> createState() => _InputToSearchState();
}

class _InputToSearchState extends State<InputToSearch> {
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: TextField(
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
          suffixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 230, 205, 205),
          ),
          label: const Text(
            'Enter your password name',
            style: TextStyle(color: Colors.black26),
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
        onChanged: (value) {
          widget.search?.call(value);
        },
      ),
    );
  }
}

class GetPwdInfo extends StatefulWidget {
  final String searchText;

  const GetPwdInfo({super.key, required this.searchText});

  @override
  State<GetPwdInfo> createState() => _GetPwdInfoState();
}

class _GetPwdInfoState extends State<GetPwdInfo> {
  List results = [];
  int resLength = 0;
  Color themeColor = const Color.fromARGB(255, 249, 224, 224);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 310,
          height: 50,
          child: ElevatedButton(
              onPressed: () async {
                var url =
                    Uri.http('192.168.1.12:8000', 'search_password_info/');
                var response = await http.post(url,
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'search_text': widget.searchText,
                    }));
                if (response.statusCode == 200) {
                  var responseBodyMap = json.decode(response.body);
                  setState(() {
                    results = responseBodyMap['results'];
                    resLength = results.length;
                  });
                }
              },
              style: ButtonStyle(
                  textStyle:
                      MaterialStateProperty.all(const TextStyle(fontSize: 17)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 249, 224, 224)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)))),
              child: const Text('Submit')),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 500,
          width: 320,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(10, 10),
                  color: Colors.black12,
                  blurRadius: 10,
                )
              ]),
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return Container(
                  height: 100,
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(18)),
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(
                      item['name'],
                      style: const TextStyle(fontSize: 19, ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['url'],
                          style: const TextStyle(fontSize: 18, fontWeight:FontWeight.w300),
                        ),
                        Text(
                          item['note'],
                          style: const TextStyle(fontSize: 18, fontWeight:FontWeight.w300),
                        ),
                      ],
                    ),
                    trailing: Text(item['password'],
                        style: const TextStyle(fontSize: 16)),
                    onTap: () {},
                  ));
            },
          ),
        )
      ],
    );
  }
}
