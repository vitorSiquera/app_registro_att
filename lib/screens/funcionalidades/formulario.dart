import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/modelo_principal.dart';

class FormularioPedido extends StatefulWidget {
  final Pedido? pedidoParaEditar;

  const FormularioPedido({super.key, this.pedidoParaEditar});

  @override
  State<FormularioPedido> createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  final _controladorDescricao = TextEditingController();
  final _controladorQuantidade = TextEditingController();
  final _controladorValor = TextEditingController();
  final _controladorCategoria = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pedidoParaEditar != null) {
      _controladorDescricao.text = widget.pedidoParaEditar!.descricao;
      _controladorQuantidade.text = widget.pedidoParaEditar!.quantidade.toString();
      _controladorValor.text = widget.pedidoParaEditar!.valor.toString();
      _controladorCategoria.text = widget.pedidoParaEditar!.categoria;
    }
  }

  @override
  void dispose() {
    _controladorDescricao.dispose();
    _controladorQuantidade.dispose();
    _controladorValor.dispose();
    _controladorCategoria.dispose();
    super.dispose();
  }

  void _salvarPedido() {
    final descricao = _controladorDescricao.text.trim();
    final quantidade = int.tryParse(_controladorQuantidade.text.trim());
    final valor = double.tryParse(_controladorValor.text.trim().replaceAll(',', '.'));
    final categoria = _controladorCategoria.text.trim();

    if (descricao.isEmpty || quantidade == null || valor == null || categoria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    final pedido = Pedido(descricao, quantidade, valor, categoria);
    Navigator.pop(context, pedido);
  }

  @override
  Widget build(BuildContext context) {
    final titulo = widget.pedidoParaEditar == null ? 'Novo Pedido' : 'Editar Pedido';

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Editor(
              controlador: _controladorDescricao,
              rotulo: 'Descrição',
              dica: 'Ex: Notebook Dell',
              icone: Icons.description,
            ),
            Editor(
              controlador: _controladorCategoria,
              rotulo: 'Categoria',
              dica: 'Ex: Eletrônicos',
              icone: Icons.category,
            ),
            Editor(
              controlador: _controladorQuantidade,
              rotulo: 'Quantidade',
              dica: '1',
              icone: Icons.format_list_numbered,
              tipoTeclado: TextInputType.number,
            ),
            Editor(
              controlador: _controladorValor,
              rotulo: 'Valor (R\$)',
              dica: '0.00',
              icone: Icons.attach_money,
              tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarPedido,
                  child: const Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
