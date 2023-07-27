import 'package:flutter/material.dart';
import 'package:campo_minado/models/campo.dart';

class CampoWidget extends StatelessWidget {
  const CampoWidget({
    super.key,
    required this.campo,
    required this.onAbrir,
    required this.onAlternarMarcacao,
  });

  final Campo campo;
  final void Function(Campo) onAbrir;
  final void Function(Campo) onAlternarMarcacao;

  Widget _getImage() {
    int qtdeMinas = campo.qtdeMinasNaVizinhanca;

    if (campo.aberto) {
      if (campo.minado) {
        if (campo.explodido) {
          return Image.asset('assets/images/bomba_0.jpeg');
        }
        return Image.asset('assets/images/bomba_1.jpeg');
      }
      return Image.asset('assets/images/aberto_$qtdeMinas.jpeg');
    } else if (campo.marcado) {
      return Image.asset('assets/images/bandeira.jpeg');
    }
    return Image.asset('assets/images/fechado.jpeg');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onAbrir(campo),
      onLongPress: () => onAlternarMarcacao(campo),
      child: _getImage(),
    );
  }
}
