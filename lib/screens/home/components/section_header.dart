import 'package:flutter/material.dart';
import 'package:lojavirtual/models/section.dart';

class SectionHeader extends StatelessWidget {

  const SectionHeader(this.section);

  final Sections section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        section.name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}
