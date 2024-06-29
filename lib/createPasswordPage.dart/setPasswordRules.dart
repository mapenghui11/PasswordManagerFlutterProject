import 'package:flutter/material.dart';
import 'package:choice/choice.dart';

class PromptedAnchor extends StatefulWidget {
  final Function(List<String>) onMultipleSelectedChanged;

  const PromptedAnchor({super.key, required this.onMultipleSelectedChanged});

  @override
  State<PromptedAnchor> createState() => _PromptedAnchorState();
}

class _PromptedAnchorState extends State<PromptedAnchor> {
  List<String> choices = [
    'Include Caps',
    'Include number',
    'Include lowercase',
    'Include special characters',
    'Exceeds 8 characters',
    '12-character limit'
  ];

  List<String> multipleSelected = [];

  Color themeColor = const Color.fromARGB(255, 249, 224, 224);

  void setMultipleSelected(List<String> value) {
    setState(() {
      multipleSelected = value;
      widget.onMultipleSelectedChanged.call(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: themeColor,
        clipBehavior: Clip.antiAlias,
        child: PromptedChoice<String>.multiple(
          clearable: true,
          value: multipleSelected,
          onChanged: setMultipleSelected,
          itemCount: choices.length,
          itemBuilder: (state, i) {
            return CheckboxListTile(
              tileColor: const Color.fromARGB(255, 255, 240, 240),
              contentPadding: const EdgeInsets.fromLTRB(20, 4, 30, 4),
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: const BorderSide(
                color: Color.fromARGB(255, 230, 205, 205),
              ),
              activeColor: themeColor,
              value: state.selected(choices[i]),
              onChanged: state.onSelected(choices[i]),
              title: ChoiceText(
                choices[i],
                highlight: state.search?.value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
            );
          },
          anchorBuilder: ChoiceAnchor.createUntitled(
            placeholder: 'Set Password Rules',
            valueTruncate: 0,
            trailing: const Icon(
              Icons.expand_more,
              color: Colors.grey,
            ),
          ),
          promptDelegate: ChoicePrompt.delegatePopupDialog(
              barrierColor: Colors.transparent, maxHeightFactor: 0.44),
        ),
      ),
    );
  }
}
