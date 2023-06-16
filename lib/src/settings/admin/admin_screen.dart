import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_template/src/settings/admin/admin_persistence.dart';
import 'package:game_template/src/style/palette.dart';
import 'package:game_template/src/style/responsive_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final List<TextEditingController> _controllers = [];
  final _prefs = AdminPersistance();
  static const _gap = SizedBox(height: 60);

  Future<void> getItems() async {
    var itemList = await _prefs.getFortuneWheelOptions();
    setState(() {
      for (var txt in itemList) {
        _controllers.add(TextEditingController(text: txt));
      }
    });
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  void dispose() {
    for (var con in _controllers) {
      con.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pallete = context.watch<Palette>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: pallete.backgroundSettings,
      body: ResponsiveScreen(
        squarishMainArea: Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          child: ListView(
            shrinkWrap: true,
            children: [
              _gap,
              const Text(
                'Glücksrad Felder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 55,
                  height: 1,
                ),
              ),
              _gap,
              ..._controllers.indexed.map(
                (elem) => _WheelItem(
                  controller: elem.$2,
                  press: () {
                    setState(() {
                      _controllers.removeAt(elem.$1);
                    });
                  },
                ),
              ),
              //_gap,
              IconButton(
                onPressed: () {
                  setState(() {
                    _controllers.add(TextEditingController());
                  });
                },
                icon: Icon(
                  Icons.add_circle_outlined,
                  size: 100,
                  color: Colors.blue[800],
                ),
              ),
              _gap
            ],
          ),
        ),
        rectangularMenuArea: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final newItems = _controllers
                        .map((e) => e.text)
                        .where((element) => element.isNotEmpty)
                        .toList();

                    _prefs.setFortuneWheelOptions(options: newItems);
                  },
                  child: const Text("Speichern"),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text("Back"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  const _WheelItem({required this.controller, required this.press});
  final TextEditingController controller;
  final void Function() press;
  static const _gap = SizedBox(width: 60);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _gap,
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            _gap,
            IconButton(
              onPressed: press,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 40,
              ),
            ),
            SizedBox(width: 20)
          ],
        ),
      ),
    );
  }
}
