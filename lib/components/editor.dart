import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;
  final TextInputType tipoTeclado;

  const Editor({
    super.key,
    this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.tipoTeclado = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controlador,
        keyboardType: tipoTeclado,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: dica,
          prefixIcon: icone != null ? Icon(icone) : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
