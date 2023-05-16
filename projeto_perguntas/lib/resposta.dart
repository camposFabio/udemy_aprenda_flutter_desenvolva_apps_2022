import 'package:flutter/material.dart';

class Resposta extends StatelessWidget {
  const Resposta({super.key, required this.texto, required this.onPressed});

  final String texto;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(color: Colors.white)),
        onPressed: onPressed,
        child: Text(texto),
      ),
    );
  }
}
