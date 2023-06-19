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

  ListTile renderCodeBlock(CodeItem item, int index) {
    final block = switch (item.type) {
      CodeType.loop => LoopBlock(data: item),
      _ => RightCodeBlock(data: item)
    };

    return ListTile(
      key: Key("$index"),
      tileColor: Colors.white,
      selectedColor: Colors.indigo,
      title: block,
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.delete_forever),
      ),
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
                      state.addItem(item, null);
                    },
                  ),
                  onReorder: ((oldIndex, newIndex) {}),
                  children: [
                    for (int i = 0; i < state.length; i++)
                      renderCodeBlock(state.items[i], i),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoopBlock extends StatelessWidget {
  const LoopBlock({super.key, required this.data});
  final CodeItem data;
  static final ddItems = List.generate(100, (index) => index, growable: false);

  static final _gap = SizedBox(width: 10);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20.0 * data.indent),
        const Text("Wiederhole", style: TextStyle(fontSize: 25)),
        _gap,
        CodeDropDown<int>(
            listItems: ddItems,
            callback: (ddVal) {
              data.addValue(ddVal);
            }),
        _gap,
        const Text("mal", style: TextStyle(fontSize: 25))
      ],
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
        Text(
          data.text ?? "Fail",
          style: TextStyle(fontSize: 25),
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
    return Draggable<CodeItem>(
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

class CodeDropDown<T> extends StatefulWidget {
  const CodeDropDown(
      {super.key, required this.listItems, required this.callback});
  final List<T> listItems;
  final void Function(T elem) callback;

  @override
  State<CodeDropDown> createState() => _CodeDropDown<T>();
}

class _CodeDropDown<T> extends State<CodeDropDown<T>> {
  late T selected;

  @override
  void initState() {
    selected = widget.listItems.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      menuMaxHeight: 500,
      value: selected,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (value) {
        if (value != null && value != selected) {
          widget.callback(value);
          setState(() {
            selected = value;
          });
        }
      },
      items: widget.listItems.map<DropdownMenuItem<T>>((value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text("$value",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              )),
        );
      }).toList(growable: false),
    );
  }
}
