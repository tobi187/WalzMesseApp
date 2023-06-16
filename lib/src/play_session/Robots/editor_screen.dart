import 'package:flutter/material.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  static const texts = [
    "wiederhole x mal",
    "lauf ein Schritt",
    "drehe links",
    "drehe rechts"
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: ListView(
            children: texts
                .map((e) => CodeBlock(
                      text: e,
                    ))
                .toList(growable: false),
          ),
        ),
        Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.tealAccent.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.separated(
                  itemBuilder: (context, index) => Container(),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                  itemCount: 0),
            ))
      ],
    );
  }
}

class CodeItem extends StatelessWidget {
  const CodeItem({super.key, required this.indent});
  final int indent;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(),
    );
  }
}

class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      maxSimultaneousDrags: 1,
      feedback: Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(30),
        ),
        width: 380,
        height: 80,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none),
          ),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
