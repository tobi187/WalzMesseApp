import 'package:flutter/material.dart';
import 'package:game_template/src/game_internals/editor_state.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class EditorScreen extends StatelessWidget {
  EditorScreen({super.key});

  final _logger = Logger("EditorScreen");

  final texts = [
    CodeItem(type: CodeType.loop, text: "wiederhole x mal"),
    CodeItem(type: CodeType.walk, text: "lauf ein Schritt"),
    CodeItem(type: CodeType.turnLeft, text: "drehe links"),
    CodeItem(type: CodeType.turnRight, text: "drehe rechts")
  ];

  ListTile renderCodeBlock(CodeItem item) {
    final block = switch (item.type) {
      CodeType.loop => RightCodeBlock(data: item),
      _ => RightCodeBlock(data: item)
    };

    return ListTile(
      title: block,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditorState(),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ListView(
              children: texts
                  .map((el) => LeftCodeBlock(item: el))
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
              child: Consumer<EditorState>(
                builder: (context, state, child) => ReorderableListView(
                  header: DragTarget<CodeItem>(
                    builder: (context, candidateItems, rejectedItems) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(Icons.add_box, size: 50),
                        ),
                      );
                    },
                    onAccept: (item) {
                      state.addItem(item, 0);
                    },
                  ),
                  onReorder: ((oldIndex, newIndex) {}),
                  children:
                      state.items.map(renderCodeBlock).toList(growable: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Adder extends StatelessWidget {
  const Adder({super.key, required this.callback});
  final void Function(String item)? callback;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, candidateItems, rejectedItems) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(Icons.add_box),
          ),
        );
      },
      onAccept: callback,
    );
  }
}

class RightCodeBlock extends StatelessWidget {
  const RightCodeBlock({super.key, required this.data});
  final CodeItem data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 20.0 * data.indent),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(data.text ?? "Fail"),
        )
      ],
    );
  }
}

class LeftCodeBlock extends StatelessWidget {
  const LeftCodeBlock({super.key, required this.item});
  final CodeItem item;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<CodeItem>(
      maxSimultaneousDrags: 1,
      data: item,
      feedback: Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(30),
        ),
        width: 380,
        height: 80,
        child: Center(
          child: Text(
            item.text ?? "Fail",
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
            item.text ?? "Fail",
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
