import 'package:flutter/material.dart';

enum AppBarAction { Profile }

class CurveAppBar extends StatelessWidget {
  final Widget? child;
  final Widget? title;
  final List<Widget>? actions;
  CurveAppBar({this.child, this.title, this.actions});

  void _onChangeMenu(AppBarAction v) {
    switch (v) {
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            title!,
            Row(
              children: actions!,
            )
          ]),
        ),
        const SizedBox(height: 30.0),
        Container(
          height: MediaQuery.of(context).size.height - 116.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.0),
                topRight: Radius.circular(35.0)),
          ),
          child: ListView(
            primary: false,
            padding: const EdgeInsets.only(left: 25.0, right: 20.0),
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height - 300.0,
                      child: child)),
            ],
          ),
        )
      ],
    );
  }
}
