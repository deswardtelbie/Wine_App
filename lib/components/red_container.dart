import 'package:flutter/material.dart';

class RedContainer extends StatelessWidget {
  final Widget child;
  const RedContainer({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade900,
            spreadRadius: 1,
            offset: const Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
