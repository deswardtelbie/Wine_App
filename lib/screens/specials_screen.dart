import 'package:flutter/material.dart';

class SpecialsScreen extends StatefulWidget {
  const SpecialsScreen({Key? key}) : super(key: key);

  @override
  State<SpecialsScreen> createState() => _SpecialsScreenState();
}

class _SpecialsScreenState extends State<SpecialsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Specials Screen'),);
  }
}