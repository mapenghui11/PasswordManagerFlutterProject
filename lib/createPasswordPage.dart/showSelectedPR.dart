import 'package:flutter/material.dart';

class ShowSelectedPR extends StatefulWidget {
  final List<String> multipleSelected;
  const ShowSelectedPR({super.key, required this.multipleSelected});

  @override
  State<ShowSelectedPR> createState() => _ShowSelectedPRState();
}

class _ShowSelectedPRState extends State<ShowSelectedPR> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 240,
        width: 300,
        child: ListView.builder(
            itemCount: widget.multipleSelected.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -4),
                  title: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 17, color: Color.fromARGB(255, 230, 205, 205)),
                      const SizedBox(
                        width: 14,
                      ),
                      Text(
                        widget.multipleSelected[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ));
            }));
  }
}
