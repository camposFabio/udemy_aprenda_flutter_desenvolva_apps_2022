import 'package:flutter/material.dart';

class Resultado extends StatelessWidget {
  const Resultado({
    super.key,
    this.pontuacao = 0,
    required this.reiniciarQuestionario,
  });

  final int pontuacao;
  final void Function() reiniciarQuestionario;

  String get fraseResultado {
    if (pontuacao < 8) {
      return 'Parabéns';
    } else if (pontuacao < 12) {
      return 'Você é bom';
    } else if (pontuacao < 16) {
      return 'Impressionante';
    } else {
      return 'Nível Jedi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            fraseResultado,
            style: const TextStyle(fontSize: 28),
          ),
        ),
        TextButton(
          onPressed: reiniciarQuestionario,
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
          child: const Text(
            'Reinicar',
          ),
        )
      ],
    );
  }
}