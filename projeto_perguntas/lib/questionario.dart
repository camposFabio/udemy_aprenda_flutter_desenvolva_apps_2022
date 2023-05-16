import 'package:flutter/material.dart';
import 'package:projeto_perguntas/questao.dart';
import 'package:projeto_perguntas/resposta.dart';

class Questionario extends StatelessWidget {
  const Questionario({
    super.key,
    required this.perguntas,
    required this.perguntaSelecionada,
    required this.responder,
  });

  final List<Map<String, Object>> perguntas;
  final void Function(int) responder;
  final int perguntaSelecionada;

  bool get temPerguntaSelecionada {
    return perguntaSelecionada < perguntas.length;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> respostas = temPerguntaSelecionada
        ? perguntas[perguntaSelecionada].cast()['respostas']
        : [];

    return Column(
      children: <Widget>[
        Questao(texto: perguntas[perguntaSelecionada]['texto'].toString()),
        ...respostas
            .map(
              (resp) => Resposta(
                  texto: resp['texto'].toString(),
                  onPressed: () =>
                      responder(int.parse(resp['pontuacao'].toString()))),
            )
            .toList(),
      ],
    );
  }
}
